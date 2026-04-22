#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo 'Usage: $(basename $0) <workflow name> <task id>'
  exit 1
fi

workflow_name=$1
task_id=$2

if [ "$(task $task_id _unique workflow)" == $workflow_name ]; then
  task $task_id modify 'workflow:' > /dev/null
else
  task $task_id modify "workflow:$workflow_name" > /dev/null
fi
