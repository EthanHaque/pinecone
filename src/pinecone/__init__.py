"""A package that replicates some of the functionality of Pine."""

from flask import Flask


def create_app() -> None:
    """Construct flask app."""
    app = Flask(__name__)

    @app.route("/")
    def hello_world() -> str:
        return "<p>Hello, World! ahhh</p>"

    return app
