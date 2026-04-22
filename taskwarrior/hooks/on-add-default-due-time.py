#!/usr/bin/env python3

import sys
import json
from datetime import datetime, time

DEFAULT_TIME = time(18, 0, 0)  # Your wanted default time
TZ_LOCAL = datetime.now().astimezone().tzinfo


def is_local_midnight(timestamp: datetime) -> bool:
    return timestamp.astimezone(TZ_LOCAL).time() == time(0, 0, 0)


def set_default_time(timestamp: datetime) -> datetime:
    return timestamp.astimezone(TZ_LOCAL).replace(
        hour=DEFAULT_TIME.hour,
        minute=DEFAULT_TIME.minute,
        second=DEFAULT_TIME.second,
    )


task = json.loads(sys.stdin.readline())
if "due" in task:
    ts = datetime.fromisoformat(task["due"])
    if is_local_midnight(ts):
        task["due"] = set_default_time(ts).isoformat()

print(json.dumps(task))
sys.exit(0)
