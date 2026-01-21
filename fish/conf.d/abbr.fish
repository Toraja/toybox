if ! status --is-interactive
    exit
end

## ubuntu
abbr --add --global apa sudo apt autoremove --purge
abbr --add --global api sudo apt install
abbr --add --global apd sudo apt update
abbr --add --global apg sudo apt upgrade
abbr --add --global apl apt list
abbr --add --global aplg apt list --upgradable

## shell
abbr --add --global mg mkdirgo
abbr --add --global mf mkfile
if type --query fd && type --query rg
    set fig_cmd 'fd -t f -X rg --color=always'
else
    set fig_cmd 'find -type f -exec grep -Hn {} ;'
end
abbr --add --global fig $fig_cmd
abbr --add --global his history
abbr --add --global hisd history delete
abbr --add --global hisdd history delete "'history delete'"
abbr --add --global hisde history delete --exact --case-sensitive
abbr --add --global hism history merge

## tmux
abbr --add --global ta tmux attach

## git
abbr --add --global ga git add
abbr --add --global gai git add --interactive
abbr --add --global gb git branch
abbr --add --global gba git branch --all
abbr --add --global gbd git branch --delete
abbr --add --global gbdf git branch --delete --force
abbr --add --global gbdr git push origin --delete \(git branch --show-current\)
abbr --add --global gbo git branch -vv \| grep gone
abbr --add --global gbod git branch -vv \| grep gone \| awk '\'{print $1}\'' \| xargs --no-run-if-empty git branch --delete
abbr --add --global gbl git branch --format '\'%(refname:short) %(upstream)\'' \| awk '\'{if (!$2) print $1;}\''
abbr --add --global gbld git branch --format '\'%(refname:short) %(upstream)\'' \| awk '\'{if (!$2) print $1;}\'' \| xargs --no-run-if-empty git branch --delete
abbr --add --global gcm git commit --message
abbr --add --global gco git checkout
abbr --add --global gcp git cherry-pick
abbr --add --global gcpc git cherry-pick --continue
abbr --add --global gcpa git cherry-pick --abort
abbr --add --global gd git diff
abbr --add --global gdn git diff --name-only
abbr --add --global gds git diff --name-status
abbr --add --global gdc git diff --cached
abbr --add --global gdf git diff-tree --no-commit-id --name-status -r
abbr --add --global gdt git difftool
abbr --add --global gdtc git difftool --cached
abbr --add --global gf git fetch
abbr --add --global gfo git fetch origin \(git remote show origin \| grep 'HEAD branch' \| awk '{print $3}'\)
abbr --add --global gfp git fetch --prune --prune-tags
abbr --add --global gftf git fetch --tags --force
abbr --add --global gg git log
abbr --add --global ggc git log \(git branch --show-current\)..main
abbr --add --global ggc git log --oneline \| fzf \| awk '\'{print $1}\''
abbr --add --global ggs git log --oneline --name-status
abbr --add --global ggu git log origin..HEAD
abbr --add --global gps git push
abbr --add --global gpl git pull
abbr --add --global gplp git pull --prune
abbr --add --global gpld git pull-default
abbr --add --global gr git reset
abbr --add --global groh git reset-origin --hard
abbr --add --global grs git restore
abbr --add --global gs git status
abbr --add --global gst git stash
abbr --add --global gstu git stash --include-untracked
abbr --add --global gstl git stash list
abbr --add --global gstp git stash pop
abbr --add --global gstm git stash push --message
abbr --add --global grb git rebase --rebase-merges
abbr --add --global grbi git rebase --rebase-merges --interactive
abbr --add --global grbs git rebase --rebase-merges --autosquash --autostash
abbr --add --global grbsi git rebase --rebase-merges --autosquash --autostash --interactive
abbr --add --global grbc git rebase --continue
abbr --add --global grba git rebase --abort
abbr --add --global gw git switch
abbr --add --global gwc git switch --create
abbr --add --global gwt git worktree

# lazygit
abbr --add --global lg lazygit

# GitHub CLI
abbr --add --global ghi gh issue
abbr --add --global ghic gh issue create --title
abbr --add --global ghid gh issue develop --checkout
abbr --add --global ghie gh issue edit
abbr --add --global ghil gh issue list
abbr --add --global ghilm gh issue list --assignee=@me
abbr --add --global ghilz gh issue list --state closed
abbr --add --global ghim gh issue comment --editor
abbr --add --global ghiv gh issue view
abbr --add --global ghiz gh issue close --reason
abbr --add --global ghp gh pr
abbr --add --global ghpc gh pr create --fill
abbr --add --global ghpd gh pr diff
abbr --add --global ghpe gh pr edit
abbr --add --global ghpl gh pr list
abbr --add --global ghpm gh pr merge --delete-branch
abbr --add --global ghpmr gh pr merge --delete-branch --rebase
abbr --add --global ghpn gh pr comment
abbr --add --global ghpo gh pr checkout
abbr --add --global ghpv gh pr view

# GitLab CLI
abbr --add --global gl glab
abbr --add --global glc glab ci
abbr --add --global glcl glab ci list
abbr --add --global glcs glab ci status --live
abbr --add --global glcv glab ci view
abbr --add --global gli glab issue
abbr --add --global --set-cursor glic glab issue create --title \'%\'
abbr --add --global --set-cursor glicm glab issue create --assignee=@me --title \'%\'
abbr --add --global glil glab issue list
abbr --add --global glilm glab issue list --assignee=@me
abbr --add --global glilz glab issue list --closed
abbr --add --global glin glab issue note
abbr --add --global gliu glab issue update
abbr --add --global gliv glab issue view
abbr --add --global glm glab mr
abbr --add --global glmc glab mr create --remove-source-branch --source-branch \(git branch --show-current\) --fill
abbr --add --global glmcl glab mr create --remove-source-branch --source-branch \(git branch --show-current\) --fill --copy-issue-labels --related-issue
abbr --add --global glmd glab mr diff
abbr --add --global glml glab mr list
abbr --add --global glmlr glab mr list --reviewer=@me
abbr --add --global glmla glab mr list --author=@me
abbr --add --global glmm glab mr merge --remove-source-branch
abbr --add --global glmn glab mr note
abbr --add --global glmo glab mr checkout
abbr --add --global --set-cursor glmof glab mr list --reviewer=@me% \| grep '^!' \| fzf --select-1 \| sed -E '\'s/^.*\(.*\).*\((.*)\)$/\1/\'' \| xargs -I {} --no-run-if-empty glab mr checkout --set-upstream-to origin/{} {}
abbr --add --global glmu glab mr update
abbr --add --global glmv glab mr view
abbr --add --global --set-cursor glmvf glab mr list --reviewer=@me% \| grep '^!' \| fzf --select-1 \| awk '{gsub("!", "", $1); print $1}' | xargs --no-run-if-empty glab mr view
abbr --add --global glpv glab repo view --branch \(git remote show origin \| grep "'HEAD branch'" \| awk '\'{print $3}\''\)

## docker
abbr --add --global dk docker
abbr --add --global dkb docker build --force-rm --tag
abbr --add --global dkbp docker builder prune --all
abbr --add --global dkc docker container
abbr --add --global dkcs docker container ls --all
abbr --add --global dkcp docker container prune
abbr --add --global --set-cursor dkcsr docker rm \(docker stop %\)
abbr --add --global dkx docker exec --interactive --tty
abbr --add --global dki docker image
abbr --add --global dkis docker images --all
abbr --add --global dkisd docker images --filter dangling=true --quiet
abbr --add --global dkip docker image prune --all
abbr --add --global dkirr docker rmi \(docker images --all --filter reference=\'\' --quiet\)
abbr --add --global dkr docker run --interactive --tty --rm
abbr --add --global dkrd docker run --detach --rm
abbr --add --global dkv docker volume
abbr --add --global dkvs docker volume ls
abbr --add --global dkvp docker volume prune
abbr --add --global dkyd docker system df --verbose
abbr --add --global dkyp docker system prune --all --volumes

## docker swarm
abbr --add --global dkw docker swarm
abbr --add --global dkwi docker swarm init --advertise-addr \(hostname --ip-address\)
abbr --add --global dkst docker stack
abbr --add --global dkstd docker stack deploy
abbr --add --global dksv docker service
abbr --add --global dksvl docker service logs

## docker compose
abbr --add --global dc docker compose
abbr --add --global dcx docker compose exec
abbr --add --global dcb docker compose build
abbr --add --global dcd docker compose down
abbr --add --global dcu docker compose up --detach
abbr --add --global dcub docker compose up --detach --build
abbr --add --global dcl docker compose logs --follow
abbr --add --global dcr docker compose run --rm
abbr --add --global dce docker compose restart

## kubectl
abbr --add --global kc kubectl

## terraform
abbr --add --global tf terraform

## go
abbr --add --global got go test
abbr --add --global gotr go test -run

## taskwarrior
abbr --add --global tt taskwarrior-tui --report nice

## misc
abbr --add --global yz yazi
