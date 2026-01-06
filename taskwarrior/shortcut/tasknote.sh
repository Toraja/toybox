#!/bin/bash

# taskopen --include=notes ${1}
tasknote ${1}

if [[ $? -ne 0 ]]; then
  read -n 1 -s -r -p "Press any key to continue..."
  echo
fi
