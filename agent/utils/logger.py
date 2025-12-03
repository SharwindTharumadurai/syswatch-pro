import logging
from pathlib import Path


def get_logger(name: str, log_file: str = "syswatch.log", level: str = "INFO") -> logging.Logger:
    """
    Configure and return a logger instance.
    """
    log_level = getattr(logging, level.upper(), logging.INFO)

    logger = logging.getLogger(name)
    logger.setLevel(log_level)

    # Avoid adding multiple handlers if logger is reused
    if not logger.handlers:
        log_path = Path(log_file)
        print("LOG FILE WILL BE WRITTEN TO:", log_path.resolve())


        # File handler
        fh = logging.FileHandler(log_path)
        fh.setLevel(log_level)

        # Console handler
        ch = logging.StreamHandler()
        ch.setLevel(log_level)

        formatter = logging.Formatter(
            "[%(asctime)s] [%(levelname)s] %(name)s - %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S",
        )

        fh.setFormatter(formatter)
        ch.setFormatter(formatter)

        logger.addHandler(fh)
        logger.addHandler(ch)

    return logger
