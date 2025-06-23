from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from flask_login import UserMixin

db = SQLAlchemy()


class Recipe(db.Model):
    __tablename__ = 'recipes'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text, nullable=False)
    cooking_time = db.Column(db.Integer, nullable=False)
    servings = db.Column(db.Integer, nullable=False)
    ingredients = db.Column(db.Text, nullable=False)
    steps = db.Column(db.Text, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    user = db.relationship('User', backref='recipes')
    images = db.relationship('Image', backref='recipe', cascade="all, delete-orphan")
    reviews = db.relationship('Review', backref='recipe', cascade="all, delete-orphan")


class User(UserMixin, db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), nullable=False, unique=True)  
    password_hash = db.Column(db.String(255), nullable=False)         
    last_name = db.Column(db.String(100), nullable=False)              
    first_name = db.Column(db.String(100), nullable=False)            
    middle_name = db.Column(db.String(100))                           
    role_id = db.Column(db.Integer, db.ForeignKey('roles.id'), nullable=False)  

class Role(db.Model):
    __tablename__ = 'roles'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False, unique=True) 
    description = db.Column(db.Text, nullable=False)               
    users = db.relationship('User', backref='role', lazy=True)     

class Image(db.Model):
    __tablename__ = 'images'
    id = db.Column(db.Integer, primary_key=True)
    filename = db.Column(db.String(255), nullable=False)         
    mime_type = db.Column(db.String(100), nullable=False)        
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.id', ondelete="CASCADE"), nullable=False)  

class Review(db.Model):
    __tablename__ = 'reviews'
    id = db.Column(db.Integer, primary_key=True)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.id', ondelete="CASCADE"), nullable=False)     
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)          
    rating = db.Column(db.Integer, nullable=False)                                      
    text = db.Column(db.Text, nullable=False)                                           
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)        

    user = db.relationship('User', backref='reviews')     
