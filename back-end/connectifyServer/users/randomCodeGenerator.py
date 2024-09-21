import random
from .userAuthModel import UserAuthModel
from .loggedusersmodel import LoggedUsersModel

def generateCode():
    code = ''.join(random.choices('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=8))
    while UserAuthModel.objects.filter(code=code).exists():
        code = ''.join(random.choices('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=8))
    return code

def generateSessionCode():
    code = ''.join(random.choices('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=8))
    while LoggedUsersModel.objects.filter(code=code).exists():
        code = ''.join(random.choices('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=8))
    return code
