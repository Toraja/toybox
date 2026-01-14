#!/bin/bash

set -eo pipefail

link="$(task _get ${1}.link)"

if [[ "$TERM" =~ ^(screen|tmux) ]]; then
  tmux set-buffer -w "$link"
else
  printf "\033]52;c;$(printf "$link" | base64 -w 0)\a" > /dev/tty
fi
