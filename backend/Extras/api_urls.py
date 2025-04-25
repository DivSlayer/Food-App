from django.urls import path

from Extras import api_views

urlpatterns = [
    path('<str:uuid>', api_views.SingleExtraAPIView.as_view()),
    path('', api_views.ExtrasListAPIView.as_view()),
]
