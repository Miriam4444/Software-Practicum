from pymongo.errors import DuplicateKeyError

from model.Users import User
from service.security import hash_password, verify_password


class EmailAlreadyRegistered(Exception):
    pass

class UserDoesNotExist(Exception):
    pass

async def create_user(name: str, email: str, password: str) -> User:
    email = email.strip().lower()
    if await User.find_one(User.email == email):
        raise EmailAlreadyRegistered("Email already registered")
    user = User(name=name, email=email, hashed_password=hash_password(password))
    try:
        await user.create()
    except DuplicateKeyError:
        raise EmailAlreadyRegistered("Email already registered")
    return user

async def authenticate_user(email: str, password: str) -> User | None:
    email = email.strip().lower()
    user = await User.find_one(User.email == email)
    if not user or not verify_password(password, user.hashed_password):
        return None
    return user
