from flask_wtf import FlaskForm
from flask_wtf.file import MultipleFileField
from wtforms import StringField, TextAreaField, IntegerField, SelectField, BooleanField, PasswordField
from wtforms.validators import DataRequired, NumberRange


class RecipeForm(FlaskForm):
    title = StringField('Название рецепта', validators=[DataRequired()])
    description = TextAreaField('Описание', validators=[DataRequired()])
    cooking_time = IntegerField('Время приготовления (в минутах)', validators=[DataRequired(), NumberRange(min=1)])
    servings = IntegerField('Количество порций', validators=[DataRequired(), NumberRange(min=1)])
    ingredients = TextAreaField('Ингредиенты', validators=[DataRequired()])
    steps = TextAreaField('Шаги приготовления', validators=[DataRequired()])
    images = MultipleFileField('Изображения')


class ReviewForm(FlaskForm):
    rating = SelectField(
        'Оценка',
        choices=[
            (5, 'отлично'),
            (4, 'хорошо'),
            (3, 'удовлетворительно'),
            (2, 'неудовлетворительно'),
            (1, 'плохо'),
            (0, 'ужасно')
        ],
        coerce=int,
        default=5
    )
    text = TextAreaField('Текст отзыва', validators=[DataRequired()])


class LoginForm(FlaskForm):
    username = StringField('Логин', validators=[DataRequired()])
    password = PasswordField('Пароль', validators=[DataRequired()])
    remember = BooleanField('Запомнить меня') 