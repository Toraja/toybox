#!/bin/bash

# taskopen --include=notes ${1}
# Pause for a bit to let you read error message
tasknote ${1} || sleep 3
