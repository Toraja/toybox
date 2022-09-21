#!/bin/bash
task $@ _unique tags | sed 's/,/\n/g' | grep -q --line-regexp awaiting

if [[ $? -eq 0 ]]; then
  task $@ modify -awaiting 2>/dev/null
else
  task $@ modify +awaiting 2>/dev/null
fi
