#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo 'Usage: toggle-tag.sh <tag> <task id>'
  exit 1
fi

tag=$1
task_id=$2

task $task_id _unique tags | sed 's/,/\n/g' | grep -q --line-regexp $tag

if [[ $? -eq 0 ]]; then
  task $task_id modify -$tag > /dev/null
else
  task $task_id modify +$tag > /dev/null
fi
