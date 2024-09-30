from asgiref.sync import sync_to_async

@sync_to_async
def get_user_phone(token):
    from users.loggedusersmodel import LoggedUsersModel
    user = LoggedUsersModel.objects.filter(token=token).first()
    return user.phone