from django.urls import path
from . import views
from . import authviews

urlpatterns = [
    path('signup/', views.SignUp),
    path('getusers/', views.Get),
    path('getsavedusers/', views.GetSavedUsers),
    path('auth/', authviews.Authentication),
]
