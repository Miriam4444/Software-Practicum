import jwt
from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from model.Users import User
from service.security import decode_access_token

security = HTTPBearer()


async def protect(credentials: HTTPAuthorizationCredentials = Depends(security)) -> User:
    try:
        user_id = decode_access_token(credentials.credentials)
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Not authorized, token failed")
    user = await User.get(user_id)
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail="Not authorized")
    return user
