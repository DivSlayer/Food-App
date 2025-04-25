from django.urls import path

from Restaurant import views

urlpatterns = [
    path('close-res', views.CloseRestaurants.as_view()),
    path('<str:uuid>', views.SingleRestaurantAPI.as_view()),
    path('', views.SingleRestaurantAPI.as_view()),
]
