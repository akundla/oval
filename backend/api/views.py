
from .serializers import UserSerializer
from rest_framework import viewsets
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post


class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all().order_by('last_name')
    serializer_class = UserSerializer