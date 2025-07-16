import json
import logging
import logging.config

import pytest
import structlog

from pinecone.logging import get_logger, setup_logging


@pytest.mark.parametrize("level", ["NOTSET", "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"])
def test_setup_logging_level(level: str, monkeypatch: pytest.MonkeyPatch) -> None:
    """Test if the root logger level is configured correctly from the env var."""
    monkeypatch.setenv("LOG_LEVEL", level)
    setup_logging()
    root_logger = logging.getLogger()
    assert root_logger.getEffectiveLevel() == logging.getLevelName(level)


def test_json_output_structure(monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> None:
    """Test if a logged message is formatted as a JSON string with the correct keys."""
    logger_name = "json_structure_test"
    monkeypatch.setenv("LOG_LEVEL", "INFO")

    setup_logging()

    log = get_logger(logger_name)
    log.info("This is an info message.")
    log.warning("This is a warning message.")

    captured_stdout = capsys.readouterr().out
    log_lines = [json.loads(line) for line in captured_stdout.strip().split("\n")]

    assert len(log_lines) == 2
    assert "This is an info message." in captured_stdout

    assert log_lines[0]["event"] == "This is an info message."
    assert log_lines[0]["level"] == "info"
    assert log_lines[0]["logger"] == logger_name
    assert "timestamp" in log_lines[0]

    assert log_lines[1]["level"] == "warning"


def test_contextual_logging_with_contextvars(
    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
) -> None:
    """Test that context bound with structlog.contextvars appears in the final log output."""
    monkeypatch.setenv("LOG_LEVEL", "INFO")
    setup_logging()
    logger = get_logger("context_test")

    structlog.contextvars.clear_contextvars()
    structlog.contextvars.bind_contextvars(request_id="a7b3c9f1", peer_ip="192.168.1.100")
    logger.warning("Payment processing failed")

    captured_stdout = capsys.readouterr().out
    log_lines = [json.loads(line) for line in captured_stdout.strip().split("\n")]

    assert log_lines[0]["request_id"] == "a7b3c9f1"
    assert log_lines[0]["peer_ip"] == "192.168.1.100"
    assert log_lines[0]["level"] == "warning"
