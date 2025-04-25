from django.urls import path

from Comment.views import CommentAPIList

urlpatterns = [
    path('<str:uuid>', CommentAPIList.as_view()),
]
