#!/bin/bash
task $@ _unique tags | sed 's/,/\n/g' | grep -q --line-regexp review

if [[ $? -eq 0 ]]; then
  task $@ modify -review 2>/dev/null
else
  task $@ modify +review 2>/dev/null
fi
