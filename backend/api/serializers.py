from rest_framework import serializers
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post


class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email']

class RoleSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Role
        fields = ['name']

class PostSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Post
        fields = ['created_date', 'modified_date', 'title', 'body', 'answerable', 'tags', 'upvotes', 'author', 'comments', 'answers']
