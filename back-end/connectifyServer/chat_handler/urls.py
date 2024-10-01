from django.urls import path
from . import views

urlpatterns = [
    path('getmessages/', views.GetMessages),
]