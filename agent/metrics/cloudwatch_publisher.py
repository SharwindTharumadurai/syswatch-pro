from typing import Dict, Any, List
from botocore.exceptions import BotoCoreError, ClientError


def build_metric_data(metrics: Dict[str, float], dimensions: List[Dict[str, str]]) -> list:
    """
    Convert our local metrics dict into CloudWatch MetricData format.
    """
    return [
        {
            "MetricName": "CPUUtilization",
            "Dimensions": dimensions,
            "Unit": "Percent",
            "Value": float(metrics["cpu"]),
        },
        {
            "MetricName": "MemoryUtilization",
            "Dimensions": dimensions,
            "Unit": "Percent",
            "Value": float(metrics["memory"]),
        },
        {
            "MetricName": "DiskUsage",
            "Dimensions": dimensions,
            "Unit": "Percent",
            "Value": float(metrics["disk"]),
        },
    ]


def publish_metrics(
    cloudwatch_client,
    namespace: str,
    metrics: Dict[str, float],
    dimensions: list,
    logger,
) -> None:
    """
    Publish metrics to CloudWatch using PutMetricData.
    """
    metric_data = build_metric_data(metrics, dimensions)

    try:
        response = cloudwatch_client.put_metric_data(
            Namespace=namespace,
            MetricData=metric_data,
        )
        logger.info("Successfully pushed metrics to CloudWatch: %s", response)
    except (BotoCoreError, ClientError) as e:
        logger.error("Failed to push metrics to CloudWatch: %s", e)
