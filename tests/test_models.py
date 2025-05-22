from app.models import User


def test_user_model(client):
    user = User(username="admin", email="admin@admin.com")
    assert user.username == "admin"
    assert user.email == "admin@admin.com"
