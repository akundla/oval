
from .serializers import UserSerializer, RoleSerializer
from rest_framework import viewsets
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post


class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all().order_by('last_name')
    serializer_class = UserSerializer

class RoleViewSet(viewsets.ModelViewSet):
    queryset = Role.objects.all().order_by('name')
    serializer_class = RoleSerializer
