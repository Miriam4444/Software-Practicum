from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, EmailStr, Field

from model.Users import User
from routes.dependencies import protect
from service.security import create_access_token
from service.Users import EmailAlreadyRegistered, authenticate_user, create_user

router = APIRouter(prefix="/auth", tags=["auth"])


class RegisterRequest(BaseModel):
    name: str
    email: EmailStr
    password: str = Field(min_length=8, max_length=72)


class LoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(max_length=72)


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


@router.post("/register", response_model=TokenResponse, status_code=201)
async def register(body: RegisterRequest):
    try:
        user = await create_user(body.name, body.email, body.password)
    except EmailAlreadyRegistered:
        raise HTTPException(status_code=409, detail="Email already registered")
    return TokenResponse(access_token=create_access_token(str(user.id)))


@router.post("/login", response_model=TokenResponse)
async def login(body: LoginRequest):
    user = await authenticate_user(body.email, body.password)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return TokenResponse(access_token=create_access_token(str(user.id)))


@router.get("/me")
async def me(user: User = Depends(protect)):
    return {"id": str(user.id), "name": user.name, "email": user.email}
