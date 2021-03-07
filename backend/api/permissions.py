from rest_framework.exceptions import ValidationError
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post
from rest_framework import permissions

class IsOwnerOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        # GET, HEAD, and OPTIONS are allowed by all
        if request.method in permissions.SAFE_METHODS:
            return True

        # Write permissions are only allowed to the owner of the snippet.
        return obj.owner == request.user

class IsInClass(permissions.BasePermission):
    def has_permission(self, request, view):
        class_in = request.query_params.get("class_in")
        if class_in is not None:
            current_class = Class.objects.get(pk=class_in)
            return request.user in current_class.enrollees.all() or request.user.pk == current_class.primary_instructor.pk
        else:
            raise ValidationError(detail="class_in parameter is required.")
         