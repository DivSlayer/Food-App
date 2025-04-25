from django.urls import path

from Instruction import api_views

urlpatterns = [
    path('<str:uuid>', api_views.SingleInstructionAPIView.as_view()),
    path('', api_views.InstructionsListAPIView.as_view()),
]
