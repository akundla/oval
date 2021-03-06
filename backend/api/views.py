
from .serializers import UserSerializer, PostSerializer
from rest_framework import viewsets, mixins
from .models import User, Role, Enrolled, Class, Term, Tag, Comment, Answer, Post

# User Routes
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all().order_by('last_name')
    serializer_class = UserSerializer

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all().order_by('created_date')
    serializer_class = PostSerializer

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