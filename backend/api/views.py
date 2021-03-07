
from .serializers import UserSerializer, RoleSerializer, EnrolledSerializer, ClassSerializer, TermSerializer, TagSerializer, CommentSerializer, AnswerSerializer, PostSerializer
from rest_framework import viewsets, mixins
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

# User Routes
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all().order_by('last_name')
    serializer_class = UserSerializer

class RoleViewSet(viewsets.ModelViewSet):
    queryset = Role.objects.all().order_by('name')
    serializer_class = RoleSerializer

class EnrolledViewSet(viewsets.ModelViewSet):
    queryset = Enrolled.objects.all().order_by('tag')
    serializer_class = EnrolledSerializer

class ClassViewSet(viewsets.ModelViewSet):
    queryset = Class.objects.all().order_by('name')
    serializer_class = ClassSerializer

class TermViewSet(viewsets.ModelViewSet):
    queryset = Term.objects.all().order_by('code')
    serializer_class = TermSerializer

class TagViewSet(viewsets.ModelViewSet):
    queryset = Tag.objects.all().order_by('name')
    serializer_class = TagSerializer

class CommentViewSet(viewsets.ModelViewSet):
    queryset = Comment.objects.all().order_by('created_date')
    serializer_class = CommentSerializer

class AnswerViewSet(viewsets.ModelViewSet):
    queryset = Answer.objects.all().order_by('created_date')
    serializer_class = AnswerSerializer

class PostViewSet(viewsets.ModelViewSet):
    permission_classes = (IsAuthenticated,)

    queryset = Post.objects.all().order_by('created_date')
    serializer_class = PostSerializer

# class CreateUserViewSet(APIView):
    
#     def post(self, request, format)

# Needed Routes
# Sign Up
# Login

# View User
# Edit User

# Create Class
# View Class (statistics)
# Edit Class (for primary instructor only)

# Create Post
# View Posts (paginated, filered)
# View Single Post
# Edit single post (author only)

# Up Vote
# Undo Up Vote
# View up votes

# Create Tag (primary instructor only)
# Edit Tags (primary instructor only)
# View Tags

# Add Comment
# View Comments
# Edit Comment (author only)

# Add Answer
# View Answers
# Edit Answer

# Get Course Info page
# Edit Course Info Page (primary instructor only)

# Request join link

# Notes
# edit/create tags, changing course settings, and editing course info should be on a settings page
