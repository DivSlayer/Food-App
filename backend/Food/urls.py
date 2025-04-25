from django.urls import path

from Food import api_views

urlpatterns = [
    path('check/', api_views.CheckFoodsExistence.as_view()),
    path('<str:uuid>', api_views.SingleFoodApiView.as_view()),
    path('', api_views.ListFoodApiView.as_view()),
]
