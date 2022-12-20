#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo 'Usage: toggle-myday.sh <task id>'
  exit 1
fi

task_id=$1

if [ -z "$(task $task_id _unique myday)" ]; then
  task $task_id modify 'myday:*' 2>/dev/null
else
  task $task_id modify 'myday:' 2>/dev/null
fi
