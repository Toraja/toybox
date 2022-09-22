#!/bin/bash
task $@ _unique tags | sed 's/,/\n/g' | grep -q --line-regexp zzz

if [[ $? -eq 0 ]]; then
  task $@ modify -zzz 2>/dev/null
else
  task $@ modify +zzz 2>/dev/null
fi
