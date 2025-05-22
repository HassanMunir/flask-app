from app.models import User
from app.database import db


def test_create_user(client):
    with client.application.app_context():
        user = User(username="admin", email="admin@admin.com")
        db.session.add(user)
        db.session.commit()

        queried_user = User.query.filter_by(email="admin@admin.com").first()
        assert queried_user is not None
        assert queried_user.username == "admin"
        assert queried_user.email == "admin@admin.com"
