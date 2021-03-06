from django.conf.urls import include
from django.urls import path
from rest_framework import routers
from rest_framework.authtoken.views import obtain_auth_token
from . import views

router = routers.DefaultRouter()
router.register(r'users', views.UserViewSet)
router.register(r'roles', views.RoleViewSet)
router.register(r'enrolled', views.EnrolledViewSet)
router.register(r'class', views.ClassViewSet)
router.register(r'term', views.TermViewSet)
router.register(r'tag', views.TagViewSet)
router.register(r'comment', views.CommentViewSet)
router.register(r'answer', views.AnswerViewSet)
router.register(r'posts', views.PostViewSet, basename="Posts")

# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path('', include(router.urls)),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    path('api-token-auth/', obtain_auth_token, name='api_token_auth') # <-- And here
]