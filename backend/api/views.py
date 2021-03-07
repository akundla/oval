
from .serializers import UserSerializer, RoleSerializer, EnrolledSerializer, ClassSerializer, TermSerializer, TagSerializer, CommentSerializer, AnswerSerializer, PostSerializer
from rest_framework import viewsets, mixins, generics
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post
from .permissions import *
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.pagination import PageNumberPagination
from django.http import HttpResponse, JsonResponse
from rest_framework.exceptions import ValidationError


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
    #permission_classes = [IsAuthenticated]
    serializer_class = PostSerializer
    pagination_class = PageNumberPagination

    def get_queryset(self):
        class_in = self.request.query_params.get("class_in", None)
        if class_in is not None:
            #raise ValidationError(detail="class_in pk is a required parameter on this request.")
            current_class = Class.objects.get(pk=class_in)
        

            if (self.request.user not in current_class.enrollees.all()) and (self.request.user.pk != current_class.primary_instructor.pk):
                raise ValidationError(detail="The signed in user does not have access to this class.")

            queryset = Post.objects.filter(class_in=current_class.pk).order_by('created_date')
        else:
            queryset = Post.objects.all().order_by('created_date')

        return queryset

# Filters
# Paginated results per class

# Needed Routes

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
