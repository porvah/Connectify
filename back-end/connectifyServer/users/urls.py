from django.urls import path
from . import views
from . import authviews
from . import profileviews

urlpatterns = [
    path('signup/', views.SignUp),
    path('login/', views.LogIn),
    path('getusers/', views.Get),
    path('getloggedusers/', views.GetLoggedUsers),
    path('getcontacts/', views.getContacts),
    path('resend/', views.ResendCode),
    path('logout/', views.LogOut),
    path('deleteaccount/', views.DeleteAccount),
    path('opensession/', views.OpenSession),
    path('getsavedusers/', views.GetSavedUsers),
    path('signupauth/', authviews.SignUpAuthentication),
    path('loginauth/', authviews.LogInAuthentication),
    path('uploadphoto/',profileviews.Upload),
    path('getphotoes/',profileviews.getPhotoes),
]
