from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from Account import views

urlpatterns = [
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('details', views.AccountDetailsAPI.as_view()),
    path('login', views.LoginAPIView.as_view()),
    path('register', views.RegisterAPIView.as_view()),

]
