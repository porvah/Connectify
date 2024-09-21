from django.urls import path
from . import views
from . import authviews

urlpatterns = [
    path('signup/', views.SignUp),
    path('login/', views.LogIn),
    path('getusers/', views.Get),
    path('resend/', views.ResendCode),
    path('getsavedusers/', views.GetSavedUsers),
    path('signupauth/', authviews.SignUpAuthentication),
    path('loginauth/', authviews.LogInAuthentication),
]
