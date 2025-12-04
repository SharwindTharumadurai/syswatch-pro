import json
import time
import yaml
from pathlib import Path

from metrics.system_metrics import collect_system_metrics
from metrics.cloudwatch_publisher import publish_metrics
from utils.logger import get_logger
from utils.cloudwatch_client import get_cloudwatch_client


BASE_DIR = Path(__file__).resolve().parent.parent  # project root = syswatch-pro
CONFIG_PATH = BASE_DIR / "config.yml"


def load_config(config_path: Path) -> dict:
    with open(config_path, "r") as f:
        return yaml.safe_load(f)


def main():
    # Load config
    config = load_config(CONFIG_PATH)

    agent_cfg = config.get("agent", {})
    logging_cfg = config.get("logging", {})
    aws_cfg = config.get("aws", {})

    interval = int(agent_cfg.get("interval_seconds", 60))
    log_file = logging_cfg.get("file", "syswatch.log")
    log_level = logging_cfg.get("level", "INFO")

    namespace = aws_cfg.get("namespace", "syswatch-pro")
    dimensions = aws_cfg.get("dimensions", [])

    logger = get_logger("syswatch-pro", log_file=log_file, level=log_level)
    cw_client = get_cloudwatch_client(config)

    logger.info("Starting syswatch-pro agent")
    logger.info("Interval set to %s seconds", interval)
    logger.info("CloudWatch namespace: %s", namespace)
    logger.info("CloudWatch dimensions: %s", dimensions)

    # For Windows local dev, we use C:\
    # For Linux/EC2 later, we'll use "/"
    disk_path = "C:\\" if (BASE_DIR.drive or "").upper().startswith("C") else "/"

    try:
        while True:
            metrics = collect_system_metrics(disk_path=disk_path)
            logger.info("Collected metrics: %s", metrics)

            # Print JSON to stdout (still useful for debugging)
            print(json.dumps(metrics))

            # Send to CloudWatch
            publish_metrics(
                cloudwatch_client=cw_client,
                namespace=namespace,
                metrics=metrics,
                dimensions=dimensions,
                logger=logger,
            )

            time.sleep(interval)

    except KeyboardInterrupt:
        logger.info("syswatch-pro agent stopped by user")


if __name__ == "__main__":
    main()
