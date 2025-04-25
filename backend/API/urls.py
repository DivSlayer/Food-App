from django.urls import path, include

from API import views

urlpatterns = [
    path('account/', include('Account.urls')),
    path('category/', include('Category.api_urls')),
    path('restaurant/', include('Restaurant.urls')),
    path('food/', include('Food.urls')),
    path('address/', include('Address.urls')),
    path('transaction/', include('Transaction.urls')),
    path('comment/', include('Comment.urls')),
    path('banner/', include('Banner.urls')),
    path('fix', views.FixAPI.as_view()),
    path('check', views.check),
    path('search', views.SearchAPIView.as_view()),
]
