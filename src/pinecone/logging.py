"""Logging setup."""

import logging
import os
import sys

import structlog


def setup_logging() -> None:
    """
    Configure logging and structlog for the application.

    This function should be called once at application startup.
    """
    log_level = os.getenv("LOG_LEVEL", "DEBUG").upper()

    if sys.stderr.isatty():
        # Pretty printing when we run in a terminal session.
        renderer = [structlog.dev.ConsoleRenderer()]
    else:
        # Print JSON when we run, e.g., in a Docker container.
        renderer = [
            structlog.processors.dict_tracebacks,
            structlog.processors.JSONRenderer(),
        ]

    logging.basicConfig(
        format="%(message)s",
        stream=sys.stdout,
        level=log_level,
        force=True,
    )

    structlog.configure(
        processors=[
            structlog.stdlib.filter_by_level,
            structlog.contextvars.merge_contextvars,
            structlog.stdlib.add_logger_name,
            structlog.stdlib.add_log_level,
            structlog.stdlib.PositionalArgumentsFormatter(),
            structlog.processors.TimeStamper(fmt="iso", utc=True),
            structlog.processors.StackInfoRenderer(),
            structlog.processors.format_exc_info,
            structlog.processors.UnicodeDecoder(),
            structlog.processors.CallsiteParameterAdder(
                {
                    structlog.processors.CallsiteParameter.FILENAME,
                    structlog.processors.CallsiteParameter.FUNC_NAME,
                    structlog.processors.CallsiteParameter.LINENO,
                }
            ),
            *renderer,
        ],
        wrapper_class=structlog.make_filtering_bound_logger(log_level),
        logger_factory=structlog.stdlib.LoggerFactory(),
        cache_logger_on_first_use=True,
    )


def get_logger(name: str | None = None) -> structlog.stdlib.BoundLogger:
    """
    Return a pre-configured structlog logger.

    Parameters
    ----------
    name:
        The name of the logger, typically __name__ of the module.
    """
    if not name:
        name = "pinecone"
    return structlog.get_logger(name)
