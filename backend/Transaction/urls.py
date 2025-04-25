from django.urls import path

from Transaction import views

urlpatterns = [
    path('', views.TransactionListView.as_view()),
    path('income', views.IncomeAPIView.as_view()),
    path('<str:serial>', views.TransactionView.as_view()),
    path('delete/<str:serial>', views.TransactionListView.as_view()),
    path('verification/<str:serial>/<int:code>', views.TransactionVerification.as_view()),
]
