if ! status --is-interactive
    exit
end

## ubuntu
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

## tmux
abbr --add --global ta tmux attach

## git
abbr --add --global ga git add
abbr --add --global gai git add -i
abbr --add --global gb git branch
abbr --add --global gba git branch
abbr --add --global gbo git branch -vv \| grep gone
abbr --add --global gbod git branch -vv \| grep gone \| awk '\'{print $1}\'' \| xargs -r git branch -d
abbr --add --global gbl 'git branch --format \'%(refname:short) %(upstream)\' | awk \'{if (!$2) print $1;}\''
abbr --add --global gbld 'git branch --format \'%(refname:short) %(upstream)\' | awk \'{if (!$2) print $1;}\' | xargs -r git branch -d'
abbr --add --global gcm git commit -m
abbr --add --global gd git diff
abbr --add --global gdn git diff --name-only
abbr --add --global gdc git diff --cached
abbr --add --global gdt git difftool
abbr --add --global gdtc git difftool --cached
abbr --add --global gf git fetch
abbr --add --global gfp git fetch --prune --prune-tags
abbr --add --global gg git log
abbr --add --global ggu git log origin..HEAD
abbr --add --global ggf 'git log --oneline | fzf | awk \'{print $1}\''
abbr --add --global gps git push
abbr --add --global gpl git pull
abbr --add --global gr git reset
abbr --add --global groh git reset-origin --hard
abbr --add --global grs git restore
abbr --add --global gs git status
abbr --add --global gst git stash
abbr --add --global gstl git stash list
abbr --add --global gstp git stash pop
abbr --add --global gstm git stash push -m
abbr --add --global grb git rebase -i
abbr --add --global grbs git rebase -i --autosquash --autostash
abbr --add --global grbc git rebase --continue
abbr --add --global gvd git vimdifftab HEAD~1
abbr --add --global gw git switch
abbr --add --global gwc git switch -c
abbr --add --global gwt git worktree
abbr --add --global gwta git worktree add
abbr --add --global gwtl git worktree list
abbr --add --global gwtr git worktree remove

# GitHub CLI
abbr --add --global ghi gh issue
abbr --add --global ghic gh issue create -t
abbr --add --global ghie gh issue edit
abbr --add --global ghil gh issue list
abbr --add --global ghilm gh issue list --assignee=@me
abbr --add --global ghilc gh issue list --state closed
abbr --add --global ghim gh issue comment
abbr --add --global ghip gh issue develop -c
abbr --add --global ghiv gh issue view
abbr --add --global ghp gh pr
abbr --add --global ghpc gh pr create
abbr --add --global ghpd gh pr diff
abbr --add --global ghpe gh pr edit
abbr --add --global ghpl gh pr list
abbr --add --global ghpm gh pr merge -d
abbr --add --global ghpmr gh pr merge -d -r
abbr --add --global ghpn gh pr comment
abbr --add --global ghpo gh pr checkout
abbr --add --global ghpv gh pr view

# GitLab CLI
abbr --add --global gl glab
abbr --add --global gli glab issue
abbr --add --global glic glab issue create -t
abbr --add --global glil glab issue list
abbr --add --global glilm glab issue list --assignee=@me
abbr --add --global glilc glab issue list -c
abbr --add --global glin glab issue note
abbr --add --global gliu glab issue update
abbr --add --global gliv glab issue view
abbr --add --global glm glab mr
abbr --add --global glmc glab mr create --remove-source-branch -s \(git branch --show-current\)
abbr --add --global glmcl glab mr create --remove-source-branch --copy-issue-labels -s \(git branch --show-current\)
abbr --add --global glmd glab mr diff
abbr --add --global glml glab mr list
abbr --add --global glmm glab mr merge -d
abbr --add --global glmn glab mr note
abbr --add --global glmo glab mr checkout
abbr --add --global glmu glab mr update
abbr --add --global glmv glab mr view

## docker
abbr --add --global do docker
abbr --add --global dob docker build --force-rm -t
abbr --add --global dobp docker builder prune -a
abbr --add --global doc docker container
abbr --add --global docs docker container ls -a
abbr --add --global docp docker container prune
abbr --add --global docsr docker rm \(docker stop \)
abbr --add --global dox docker exec -it
abbr --add --global doi docker image
abbr --add --global dois docker images -a
abbr --add --global doisd docker images -f dangling=true -q
abbr --add --global doip docker image prune -a
abbr --add --global doirr docker rmi \(docker images -a -f reference=\'\' -q\)
abbr --add --global dor docker run -it --rm
abbr --add --global dord docker run -d --rm
abbr --add --global dov docker volume
abbr --add --global dovs docker volume ls
abbr --add --global dovp docker volume prune
abbr --add --global doyd docker system df -v
abbr --add --global doyp docker system prune -a --volumes

## docker swarm
abbr --add --global dow docker swarm
abbr --add --global dowi docker swarm init --advertise-addr \(hostname -i\)
abbr --add --global dost docker stack
abbr --add --global dostd docker stack deploy
abbr --add --global dosv docker service
abbr --add --global dosvl docker service logs

## docker compose
abbr --add --global dc docker compose
abbr --add --global dcx docker compose exec
abbr --add --global dcb docker compose build
abbr --add --global dcd docker compose down
abbr --add --global dcu docker compose up -d
abbr --add --global dcub docker compose up -d --build
abbr --add --global dcl docker compose logs --follow
abbr --add --global dcr docker compose run
abbr --add --global dce docker compose restart

## kubectl
abbr --add --global kc kubectl

## terraform
abbr --add --global tf terraform

## go
abbr --add --global got go test
abbr --add --global gotr go test -run

## taskwarrior
abbr --add --global tt taskwarrior-tui -r nice

## ranger
abbr --add --global rng ranger
