from rest_framework import serializers
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['pk', 'first_name', 'last_name', 'email', 'password']
        extra_kwargs = {'password': {'write_only': True}}
    
    def create(self, validated_data):
        user = User(
            email=validated_data['email'],
            first_name=validated_data['first_name'],
            last_name=validated_data['last_name']

        )
        user.set_password(validated_data['password'])
        user.save()
        return user


class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = ['pk', 'name']

class EnrolledSerializer(serializers.ModelSerializer):
    class Meta:
        model = Enrolled
        fields = ['pk', 'user', 'enrolled_class', 'role', 'tag']

class ClassSerializer(serializers.ModelSerializer):
    class Meta:
        model = Class
        fields = ('pk', 'name', 'description', 'information_page', 'enrollees', 'primary_instructor')

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

class CurrentUserAction(serializers.Serializer):
    def to_representation(self, upvotes):
        user = None
        request = self.context.get("request")
        if request and hasattr(request, "user"):
            user = request.user
        
        if user is not None:
            return user in upvotes.all()
        return str("hi")

class AnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Answer
        fields = ['pk', 'created_date', 'modified_date', 'body', 'upvote_count', 'user_upvoted', 'author', 'comments', 'post']

    author = UserSerializer(read_only=True)
    upvote_count = serializers.IntegerField(
        source='upvotes.count', 
        read_only=True
    )
    user_upvoted = CurrentUserAction(read_only=True, source='upvotes')

class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ['pk', 'created_date', 'modified_date', 'title', 'body', 'answerable', 'tags', 'author', 'comments', 'class_in', 'upvote_count', 'user_upvoted', 'user_viewed', 'answers_post']
    
    user_upvoted = CurrentUserAction(read_only=True, source='upvotes')
    user_viewed = CurrentUserAction(read_only=True, source='views')
    upvote_count = serializers.IntegerField(
        source='upvotes.count', 
        read_only=True
    )
    answers_post = AnswerSerializer(read_only=True, many=True)
    def to_representation(self, instance):
        self.fields['author'] = UserSerializer(read_only=True)
        self.fields['class_in'] = ClassSerializer(read_only=True)
        
        return super(PostSerializer, self).to_representation(instance)

