from django.urls import path

from Search import dash_views

urlpatterns = [

    path('',dash_views.SearchView.as_view(), name='search'),
]