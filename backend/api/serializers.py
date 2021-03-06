from rest_framework import serializers
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email']

class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = ['name']

class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ['created_date', 'modified_date', 'title', 'body', 'answerable', 'tags', 'upvotes', 'author', 'comments', 'answers']
