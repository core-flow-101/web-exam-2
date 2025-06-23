from flask import Flask, render_template, request, redirect, url_for, flash
from flask_migrate import Migrate
import os
from sqlalchemy import func
import bleach
from flask_login import LoginManager, login_user, logout_user, login_required, current_user
from werkzeug.security import check_password_hash
from dotenv import load_dotenv
import pymysql

from models import db, Recipe, User, Image, Review
from forms import RecipeForm, ReviewForm, LoginForm
from markupsafe import Markup
import markdown


pymysql.install_as_MySQLdb()

load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('FLASK_SECRET_KEY')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = os.getenv('SQLALCHEMY_TRACK_MODIFICATIONS', 'False').lower() == 'true'
app.config['UPLOAD_FOLDER'] = os.getenv('UPLOAD_FOLDER')

required_env_vars = ['FLASK_SECRET_KEY', 'DATABASE_URL', 'UPLOAD_FOLDER']
missing_vars = [var for var in required_env_vars if not os.getenv(var)]
if missing_vars:
    raise RuntimeError(f'Отсутствуют обязательные переменные окружения: {", ".join(missing_vars)}')

db.init_app(app)
migrate = Migrate(app, db)


os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)


login_manager = LoginManager(app)
login_manager.login_view = 'login'
login_manager.login_message = 'Для выполнения данного действия необходимо пройти процедуру аутентификации'
login_manager.login_message_category = 'warning'


@login_manager.user_loader
def load_user(user_id):
    return db.session.get(User, int(user_id))


@app.route('/')
@login_required
def index():
    page = request.args.get('page', 1, type=int)
    per_page = 10

    recipes_query = (
        db.session.query(
            Recipe,
            func.coalesce(func.avg(Review.rating), 0).label('avg_rating'),
            func.count(Review.id).label('reviews_count')
        )
        .outerjoin(Review, Review.recipe_id == Recipe.id)
        .group_by(Recipe.id)
        .order_by(Recipe.created_at.desc())
    )

    pagination = recipes_query.paginate(page=page, per_page=per_page, error_out=False)
    recipes = pagination.items

    return render_template('index.html', recipes=recipes, pagination=pagination)


@app.route('/add-recipe', methods=['GET', 'POST'])
@login_required
def add_recipe():
    form = RecipeForm()
    if form.validate_on_submit():
        description = bleach.clean(form.description.data)
        ingredients = bleach.clean(form.ingredients.data)
        steps = bleach.clean(form.steps.data)
        recipe = Recipe(
            title=form.title.data,
            description=description,
            cooking_time=form.cooking_time.data,
            servings=form.servings.data,
            ingredients=ingredients,
            steps=steps,
            user_id=current_user.id  
        )
        try:
            db.session.add(recipe)
            db.session.commit()
            if form.images.data:
                for image in form.images.data:
                    if image.filename:
                        filename = image.filename
                        mime_type = image.mimetype
                        path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                        image.save(path)
                        img = Image(filename=filename, mime_type=mime_type, recipe_id=recipe.id)
                        db.session.add(img)
                db.session.commit()
            flash('Рецепт успешно добавлен!', 'success')
            return redirect(url_for('index'))
        except Exception as e:
            db.session.rollback()
            flash('При сохранении данных возникла ошибка. Проверьте корректность введённых данных.', 'danger')
            return render_template('add_recipe.html', form=form)
    return render_template('add_recipe.html', form=form)

@app.route('/edit-recipe/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_recipe(id):
    recipe = Recipe.query.get_or_404(id)
    is_admin = current_user.role and current_user.role.name == 'Администратор'
    if recipe.user_id != current_user.id and not is_admin:
        flash('У вас недостаточно прав для выполнения данного действия', 'danger')
        return redirect(url_for('index'))
    form = RecipeForm(obj=recipe)
    if form.validate_on_submit():
        recipe.title = form.title.data
        recipe.description = form.description.data
        recipe.cooking_time = form.cooking_time.data
        recipe.servings = form.servings.data
        recipe.ingredients = form.ingredients.data
        recipe.steps = form.steps.data
        db.session.commit()
        flash('Рецепт успешно обновлен!', 'success')
        return redirect(url_for('index'))
    return render_template('edit_recipe.html', form=form, recipe=recipe)

@app.route('/recipe/<int:id>')
@login_required
def view_recipe(id):
    recipe = Recipe.query.get_or_404(id)
    images = Image.query.filter_by(recipe_id=recipe.id).all()
    reviews = Review.query.filter_by(recipe_id=recipe.id).all()

    description_html = Markup(markdown.markdown(recipe.description, extensions=['extra']))
    ingredients_html = Markup(markdown.markdown(recipe.ingredients, extensions=['extra']))
    steps_html = Markup(markdown.markdown(recipe.steps, extensions=['extra']))

    return render_template(
        'view_recipe.html',
        recipe=recipe,
        images=images,
        description_html=description_html,
        ingredients_html=ingredients_html,
        steps_html=steps_html,
        reviews=reviews
    )

@app.route('/delete-recipe/<int:id>', methods=['POST'])
@login_required
def delete_recipe(id):
    recipe = Recipe.query.get_or_404(id)
    try:
        for image in recipe.images:
            image_path = os.path.join(app.config['UPLOAD_FOLDER'], image.filename)
            if os.path.exists(image_path):
                os.remove(image_path)
        db.session.delete(recipe)
        db.session.commit()
        flash('Рецепт успешно удалён!', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Ошибка при удалении рецепта.', 'danger')
    return redirect(url_for('index'))

@app.route('/recipe/<int:recipe_id>/add-review', methods=['GET', 'POST'])
@login_required
def add_review(recipe_id):
    recipe = Recipe.query.get_or_404(recipe_id)
    form = ReviewForm()
    user_id = current_user.id  

    
    existing_review = Review.query.filter_by(recipe_id=recipe_id, user_id=user_id).first()
    if existing_review:
        flash('Вы уже оставляли отзыв на этот рецепт.', 'warning')
        return redirect(url_for('view_recipe', id=recipe_id))

    if form.validate_on_submit():
        text = bleach.clean(form.text.data)
        review = Review(
            recipe_id=recipe_id,
            user_id=user_id,
            rating=form.rating.data,
            text=text
        )
        try:
            db.session.add(review)
            db.session.commit()
            flash('Отзыв успешно добавлен!', 'success')
            return redirect(url_for('view_recipe', id=recipe_id))
        except Exception as e:
            db.session.rollback()
            flash('Ошибка при сохранении отзыва.', 'danger')
    return render_template('add_review.html', form=form, recipe=recipe)


@app.template_filter('markdown')
def markdown_filter(text):
    return Markup(markdown.markdown(text, extensions=['extra']))


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    error = None
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user and check_password_hash(user.password_hash, form.password.data):
            login_user(user, remember=form.remember.data)
            return redirect(url_for('index'))
        else:
            error = 'Невозможно аутентифицироваться с указанными логином и паролем'
    return render_template('login.html', form=form, error=error)


@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Вы вышли из аккаунта.', 'success')
    return redirect(url_for('login'))


if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=os.getenv('FLASK_DEBUG', 'False').lower() == 'true') 


