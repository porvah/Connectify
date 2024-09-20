import random
from .userAuthModel import UserAuthModel

def generateCode():
    code = ''.join(random.choices('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=8))
    while UserAuthModel.objects.filter(code=code).exists():
        code = ''.join(random.choices('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=8))
    return code
