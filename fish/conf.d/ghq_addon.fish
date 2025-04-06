# This requires fish-ghq plugin
complete -f -c ghq -n __fish_ghq_needs_command -a dirty -d "List path of dirty repositories"
complete -f -c ghq -n "__fish_ghq_using_command dirty" -l status -s s -d "Display the status of each repository"
