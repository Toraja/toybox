#!/bin/bash
# For how to get the part of tasks, see https://taskwarrior.org/docs/dom/

which xclip &>/dev/null
if [[ $? -gt 0 ]]; then
  echo xclip is not installed.
  exit 1
fi

task _get ${1}.description | xclip
