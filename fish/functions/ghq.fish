function ghq --description "ghq wrapper"
    switch $argv[1]
        case dirty
            __ghq_dirty $argv[2..]
        case '*'
            command ghq $argv
    end

end

# With status option, output of `git status` is appended.
function __ghq_dirty --description "List dirty repos paths"
    argparse s/status -- $argv

    for repo in (command ghq list --full-path)
        if [ -z "$(git -C $repo status --porcelain)" ]
            test -z "$(git -C $repo remote)"; and continue; or true
            test -n "$(git -C $repo cherry 2>/dev/null)"; and echo "$repo [unpushed commits]"; or true
        else
            echo $repo
            test -n "$_flag_status"; and git -C $repo status --short; or true
        end
    end
end
