function ghq --description "ghq wrapper"
    switch $argv[1]
        case dirty
            ghq_dirty $argv[2..]
        case '*'
            command ghq $argv
    end

end

function ghq_dirty --description "List dirty repos paths"
    argparse 's/status' -- $argv

    for repo in (command ghq list --full-path)
        git -C $repo diff-index --quiet HEAD -- ; or begin
            echo $repo
            test -n "$_flag_status"; and git -C $repo status --short
        end
    end
end
