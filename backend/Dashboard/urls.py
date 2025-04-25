from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from Account import views as acc_views
from Dashboard import views
from Extras.models import Extra

urlpatterns = [
    path('token/', views.GetToken.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('details', acc_views.AccountDetailsAPI.as_view()),
    path('login', views.LoginAPIView.as_view()),
    path('test', views.test),
    path('check', views.check),
    path('transaction/', include('Transaction.urls')),
    path('food', views.ListFoodApiView.as_view()),
    path('food/<str:uuid>', views.SingleFoodApiView.as_view()),
    path('food/size/<str:uuid>', views.SizeApiView.as_view()),
    path('extras/', include('Extras.api_urls')),
    path('instruction/', include('Instruction.api_urls')),
    path('category/', include('Category.api_urls')),
    path('address/', include('Address.urls')),
    path('restaurant/', include('Restaurant.api_urls')),
    path('search/', include('Search.dash_urls')),
    path('comments/', include('Comment.dash_urls')),
]
