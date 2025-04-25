from django.urls import path, include

from Category import api_views

urlpatterns = [
    path('<str:uuid>', api_views.SingleCategoryAPI.as_view()),
    path('', api_views.ListApi.as_view())
]
