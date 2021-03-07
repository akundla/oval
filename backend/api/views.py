
from .serializers import *
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
from rest_framework.decorators import action



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

    @action(detail=True, methods=['post'])
    # pk is the class primary key, the class id
    def enroll(self, request, pk=None):
        # Both of these lines ull the correct data
        currentClass = self.get_object()
        user_id = self.request.user.pk

        if ('state' in request.data) and ('role_id' in request.data):
            if request.data['state']:
                # If this is going to fail let it fail here
                role_id = int(request.data['role_id'])
                role = Role.objects.get(pk=role_id)

                enrollment = Enrolled(user=self.request.user, enrolled_class=currentClass, role=role, tag=None)
                enrollment.save()
            return Response({'enrolled': request.data['state']})
        else:
            raise ValidationError(detail="Bad request.")

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

    @action(detail=True, methods=['post'])
    def upvote(self, request, pk=None):
        answer = self.get_object()
        current_class = answer.post.class_in
        # if (self.request.user not in current_class.enrollees.all()) and (self.request.user.pk != current_class.primary_instructor.pk):
        #         raise ValidationError(detail="You cannot upvote this post.")
        if 'state' in request.data:
            upvoted = request.data['state'] == True
            if request.data['state'] and self.request.user not in answer.upvotes.all():
                    answer.upvotes.add(self.request.user)
                    answer.save()
            elif not request.data['state'] and self.request.user in answer.upvotes.all():
                answer.upvotes.remove(self.request.user)
                answer.save()
            return Response(
                {
                    'upvoted': upvoted,
                    'upvotes': len(post.upvotes.all())
                }
            )
        else:
            raise ValidationError(detail="Bad request.")

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

            queryset = Post.objects.filter(class_in=current_class.pk).order_by('-created_date', reversed=True)
        else:
            queryset = Post.objects.all().order_by('-created_date')

        return queryset

    @action(detail=True, methods=['post'])
    def upvote(self, request, pk=None):
        post = self.get_object()
        current_class = post.class_in
        # if (self.request.user not in current_class.enrollees.all()) and (self.request.user.pk != current_class.primary_instructor.pk):
        #         raise ValidationError(detail="You cannot upvote this post.")
        if 'state' in request.data:
            upvoted = request.data['state'] == True
            if request.data['state'] and self.request.user not in post.upvotes.all():
                    post.upvotes.add(self.request.user)
                    post.save()
            elif not request.data['state'] and self.request.user in post.upvotes.all():
                post.upvotes.remove(self.request.user)
                post.save()
            return Response(
                {
                    'upvoted': upvoted,
                    'upvotes': len(post.upvotes.all())
                }
            )
        else:
            raise ValidationError(detail="Bad request.")
    
    @action(detail=True, methods=['post'])
    def view(self, request, pk=None):
        post = self.get_object()
        current_class = post.class_in

        if 'state' in request.data:
            if request.data['state']:
                    post.views.add(self.request.user)
                    post.save()
                    viewed = True
            elif not request.data['state']:
                post.views.remove(self.request.user)
                post.save()
                viewed = False
            return Response({'viewed': viewed})
        else:
            raise ValidationError(detail="Bad request.")

    @action(detail=True, methods=['post'])
    def answer(self, request, pk=None):
        post = self.get_object()
        ps = QuickAnswerSerializer(data=request.data)
        if ps.is_valid() and self.request.user is not None:
            p = Answer()
            p.body = ps['body'].value
            p.post = post
            p.author = self.request.user
            p.save()
            return Response(AnswerSerializer(context={'request': request}).to_representation(p))
        # if ('body' in request.data and 'title' in request.data):
        #     p = Post()
        #     p.title = request.data['title']

        raise ValidationError(detail="Bad request.")

    def create(self, request):
        ps = QuickPostSerializer(data=request.data)
        if ps.is_valid() and self.request.user is not None:
            p = Post()
            p.title = ps['title'].value
            p.body = ps['body'].value
            p.answerable = True
            p.class_in = Class.objects.get(pk=5)
            p.author = self.request.user
            p.save()
            return Response(PostSerializer(context={'request': request}).to_representation(p))
        # if ('body' in request.data and 'title' in request.data):
        #     p = Post()
        #     p.title = request.data['title']

        raise ValidationError(detail="Bad request.")

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
