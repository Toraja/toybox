#!/bin/bash

current_context=$(task _get rc.context)
if [[ $current_context == 'default' ]]; then
  task context myday > /dev/null
  exit 0
fi
task context default > /dev/null
