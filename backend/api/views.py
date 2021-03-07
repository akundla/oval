
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
    permission_classes = [IsAuthenticated, IsInClass]
    queryset = Answer.objects.all().order_by('created_date')
    serializer_class = AnswerSerializer


class PostViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsInClass]
    serializer_class = PostSerializer
    pagination_class = PageNumberPagination

    def get_queryset(self):
        current_class = Class.objects.get(
            pk=self.request.query_params.get("class_in", None))

        return Post.objects.filter(class_in=current_class.pk).order_by('created_date')


