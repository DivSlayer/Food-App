from django.urls import path

from Banner import views

urlpatterns = [
    path('', views.BannerAPIListView.as_view())
]
