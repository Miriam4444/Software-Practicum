from datetime import datetime, timezone
from typing import Annotated

from beanie import Document, Indexed
from pydantic import EmailStr, Field


class User(Document):
    name: str
    email: Annotated[EmailStr, Indexed(unique=True)]
    hashed_password: str
    is_active: bool = True
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))

    class Settings:
        name = "Users"
