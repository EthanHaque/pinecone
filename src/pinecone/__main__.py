"""Main entry point for the Pinecone application."""

from dotenv import load_dotenv
from flask import Flask

from pinecone.logging import get_logger, setup_logging


def main() -> None:
    """Entry point."""
    setup_logging()

    load_dotenv()

    logger = get_logger()
    logger.info("READY")

    create_app()


def create_app() -> None:
    """Construct flask app."""
    app = Flask(__name__)

    @app.route("/")
    def hello_world() -> str:
        return "<p>Hello, World!</p>"

    app.run()


if __name__ == "__main__":
    main()
