#!/bin/bash

current_context=$(task _get rc.context)
if [[ $current_context == 'default' ]]; then
  task context myday 2>/dev/null
  exit 0
fi
task context default 2>/dev/null
