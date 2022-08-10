function __fish_git_branches_and_heads
    __fish_git_branches
    __fish_git_heads
end
complete --command git --no-files --condition "__fish_seen_subcommand_from vimdifftab" --long-option help --short-option h --long-option fzf --short-option f
complete --command git --no-files --condition "__fish_seen_subcommand_from vimdifftab && not __fish_seen_subcommand_from (__fish_git_branches_and_heads)" --arguments '(__fish_git_branches_and_heads)'
