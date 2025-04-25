from django.urls import path

from Comment.dash_views import CommentAPIList

urlpatterns = [
    path('', CommentAPIList.as_view()),
]
