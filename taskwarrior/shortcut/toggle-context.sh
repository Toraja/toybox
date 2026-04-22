#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo 'Usage: $(basename $0) <context name>'
  exit 1
fi

context_name=$1

current_context=$(task _get rc.context)
if [[ $current_context != $context_name ]]; then
  task context $context_name > /dev/null
  exit 0
fi
task context default > /dev/null
