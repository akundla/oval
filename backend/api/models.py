from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import ugettext_lazy as _
from .managers import CustomUserManager


class User(AbstractUser):
    username = None
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    email = models.EmailField(unique=True)

    USERNAME_FIELD = 'email'
    EMAIL_FIELD = 'email'
    REQUIRED_FIELDS = ['first_name', 'last_name']

    objects = CustomUserManager()

class Role(models.Model):
    name = models.CharField(max_length=255)

class Enrolled(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    class_id = models.ForeignKey("Class", on_delete=models.CASCADE)
    role = models.ForeignKey(Role, on_delete=models.CASCADE)
    tag = models.CharField(max_length=255)

class Class(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    information_page = models.TextField()
    enrolles = models.ManyToManyField(User, through=Enrolled, related_name="classes_enrolled")
    primary_instructor = models.ForeignKey(User, on_delete=models.CASCADE, related_name="primary_instructor_in_class", default = 1)

class Term(models.Model):
    full_name = models.CharField(max_length=255)
    code = models.CharField(max_length=10)

class Tag(models.Model):
    name = models.CharField(max_length=255)

class Comment(models.Model):
    created_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)
    body = models.TextField()
    upvotes = models.ManyToManyField(User, related_name="comments_upvoted")
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name="comments_authored")

class Answer(models.Model):
    created_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)
    body = models.TextField()
    upvotes = models.ManyToManyField(User, related_name="answers_upvoted")
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name="answers_authored")
    comments = models.ManyToManyField(Comment)

class Post(models.Model):
    created_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)
    title = models.CharField(max_length=255)
    body = models.TextField()
    answerable = models.BooleanField()
    tags = models.ManyToManyField(Tag)
    upvotes = models.ManyToManyField(User, related_name="posts_upvoted")
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name="posts_authored")
    comments = models.ManyToManyField(Comment)
    answers = models.ManyToManyField(Answer)



