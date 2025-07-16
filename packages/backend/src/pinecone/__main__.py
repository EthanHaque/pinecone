"""Main entry point for the Pinecone application."""

from dotenv import load_dotenv

from pinecone import create_app
from pinecone.logging import get_logger, setup_logging


def main() -> None:
    """Entry point."""
    setup_logging()

    load_dotenv()

    logger = get_logger()
    logger.info("READY")

    app = create_app()
    app.run()


if __name__ == "__main__":
    main()
