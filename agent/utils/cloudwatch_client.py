import boto3
from typing import Dict, Any


def get_cloudwatch_client(config: Dict[str, Any]):
    """
    Return a boto3 CloudWatch client using region from config.
    """
    aws_cfg = config.get("aws", {})
    region_name = aws_cfg.get("region_name", "us-east-1")

    return boto3.client("cloudwatch", region_name=region_name)
