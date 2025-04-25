from django.urls import path

from Address import views

urlpatterns = [
    path('', views.AddressListAPIView.as_view()),
    path('<str:uuid>', views.SingleAPIView.as_view())
]
