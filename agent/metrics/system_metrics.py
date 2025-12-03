import psutil
from datetime import datetime, timezone


def get_cpu_usage() -> float:
    """
    Return CPU usage percentage.
    """
    return psutil.cpu_percent(interval=1)


def get_memory_usage() -> float:
    """
    Return memory usage percentage.
    """
    mem = psutil.virtual_memory()
    return mem.percent


def get_disk_usage(path: str = "/") -> float:
    """
    Return disk usage percentage for a given path.
    On Windows, you can pass something like 'C:\\'.
    """
    disk = psutil.disk_usage(path)
    return disk.percent


def collect_system_metrics(disk_path: str = "/") -> dict:
    """
    Collect CPU, memory, and disk usage into a single dict.
    """
    cpu = get_cpu_usage()
    mem = get_memory_usage()
    disk = get_disk_usage(disk_path)

    return {
        "cpu": cpu,
        "memory": mem,
        "disk": disk,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }
