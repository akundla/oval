from rest_framework import serializers
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
<<<<<<< HEAD
        fields = ['pk', 'first_name', 'last_name', 'email']
        depth = 1
=======
        fields = ['pk', 'first_name', 'last_name', 'email', 'password']
>>>>>>> 9d3e88080428b3c5b9121af89c432cbc23107e43

class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = ['pk', 'name']

class EnrolledSerializer(serializers.ModelSerializer):
    class Meta:
        model = Enrolled
        fields = ['pk', 'user_id', 'class_id', 'role', 'tag']

class ClassSerializer(serializers.ModelSerializer):
    class Meta:
        model = Class
        fields = ('pk', 'name', 'description', 'information_page', 'enrolles', 'primary_instructor')

    def to_representation(self, instance):
        self.fields['primary_instructor'] = UserSerializer(read_only=True)
        return super(ClassSerializer, self).to_representation(instance)

class TermSerializer(serializers.ModelSerializer):
    class Meta:
        model = Term
        fields = ['pk', 'full_name', 'code']

class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        fields = ['pk', 'name']

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['pk', 'created_date', 'modified_date', 'body', 'upvotes', 'author']

class AnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Answer
        fields = ['pk', 'created_date', 'modified_date', 'body', 'upvotes', 'author', 'comments']

class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ['created_date', 'modified_date', 'title', 'body', 'answerable', 'tags', 'upvotes', 'author', 'comments', 'answers']

class UserCreationSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email', 'password']
        fields = ['pk', 'created_date', 'modified_date', 'title', 'body', 'answerable', 'tags', 'upvotes', 'author', 'comments', 'answers']
    
    def to_representation(self, instance):
        self.fields['author'] = UserSerializer(read_only=True)
        return super(PostSerializer, self).to_representation(instance)
