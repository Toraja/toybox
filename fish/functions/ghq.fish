function ghq --description "ghq wrapper"
    switch $argv[1]
        case dirty
            ghq_dirty $argv[2..]
        case '*'
            command ghq $argv
    end

end

# With status option, output of `git status` is appended.
function ghq_dirty --description "List dirty repos paths"
    argparse 's/status' -- $argv

    for repo in (command ghq list --full-path)
        git -C $repo diff-index --quiet HEAD --
        if [ $status -eq 0 ]
            test -z (git -C $repo remote); and continue
            set --local current_branch (git -C $repo branch | grep '*' | awk '{ print $2 }')
            git -C $repo diff-index --quiet origin/$current_branch -- &>/dev/null; or echo "$repo [unpushed commits]"
        else
            echo $repo
            test -n "$_flag_status"; and git -C $repo status --short
        end
    end
end
