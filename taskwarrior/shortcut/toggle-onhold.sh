#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo 'Usage: toggle-onhold.sh <task id>'
  exit 1
fi

task_id=$1

# XXX: since taskwarrior-tui does not support colouring UDA, add tag for colouring
if [ -z "$(task $task_id _unique onhold)" ]; then
  task $task_id modify 'onhold:-' > /dev/null
  task $task_id modify +zzz > /dev/null
  task stop $task_id > /dev/null || true
else
  task $task_id modify 'onhold:' > /dev/null
  task $task_id modify -zzz > /dev/null
fi
