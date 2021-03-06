from rest_framework import serializers
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email']
        depth = 1

class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = ['name']
        depth = 1

class EnrolledSerializer(serializers.ModelSerializer):
    class Meta:
        model = Enrolled
        fields = ['user_id', 'class_id', 'role', 'tag']
        depth = 1

class ClassSerializer(serializers.ModelSerializer):
    class Meta:
        model = Class
        fields = ['name', 'description', 'information_page', 'enrolles', 'primary_instructor']
        depth = 1

class TermSerializer(serializers.ModelSerializer):
    class Meta:
        model = Term
        fields = ['full_name', 'code']
        depth = 1

class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        fields = ['name']
        depth = 1

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['created_date', 'modified_date', 'body', 'upvotes', 'author']
        depth = 1

class AnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Answer
        fields = ['created_date', 'modified_date', 'body', 'upvotes', 'author', 'comments']
        depth = 1

class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ['created_date', 'modified_date', 'title', 'body', 'answerable', 'tags', 'upvotes', 'author', 'comments', 'answers']
        depth = 1
