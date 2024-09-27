#!/bin/bash

set -eo pipefail

shortcuts=$(task show shortcut | sed -e 's/uda\.taskwarrior-tui\.//')

# "" is required to preserve newlines
num_commands="$(echo "$shortcuts" | grep shortcuts | sed -e 's/shortcuts\.//')"
declare -A num_command_map
while read line; do
  arr=($line)
  num=${arr[0]}
  cmd=$(basename ${arr[1]})
  rest=${arr[2]}
  num_command_map+=([$num]="$cmd $rest")
done <<< "$num_commands"

shell_opts=$(set +o)
set -f # disable globbing (i.e. * being expanded)
num_keys=$(echo "$shortcuts" | grep keyconfig | sed -e 's/keyconfig\.shortcut//')
declare -A num_key_map
while read line; do
  arr=($line)
  num=${arr[0]}
  key=${arr[1]}
  num_key_map+=([$num]="$key")
done <<< "$num_keys"
eval "$shell_opts"

for num in "${!num_command_map[@]}"
do
  key="${num_key_map[$num]}"
  printf "  %s   %1s   %s\n" "$num" "$key" "${num_command_map[$num]}"
done | sort | less
