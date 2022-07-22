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
if type --query fd && type --query rg
    set fig_cmd 'fd -t f -X rg --color=always'
else
    set fig_cmd 'find -type f -exec grep -Hn {} ;'
end
abbr --add --global fig $fig_cmd

## tmux
abbr --add --global ta tmux attach

## git
abbr --add --global gb git branch
abbr --add --global gbo git branch -vv \| grep gone
abbr --add --global gbod git branch -vv \| grep gone \| awk '\'{print $1}\'' \| xargs -r git branch -d
abbr --add --global gf git fetch
abbr --add --global gfp git fetch --prune --prune-tags
abbr --add --global gs git status
abbr --add --global gl git log
abbr --add --global glu git log origin..HEAD
abbr --add --global glf 'git log --oneline | fzf | awk \'{print $1}\''
abbr --add --global gd git diff
abbr --add --global gdn git diff --name-only
abbr --add --global gdc git diff --cached
abbr --add --global gdt git difftool
abbr --add --global gdtc git difftool --cached
abbr --add --global ga git add
abbr --add --global gai git add -i
abbr --add --global gcm git commit -m
abbr --add --global gw git switch
abbr --add --global gwc git switch --no-track -c
abbr --add --global gr git reset
abbr --add --global grs git restore
abbr --add --global gst git stash
abbr --add --global gstl git stash list
abbr --add --global gstp git stash pop
abbr --add --global gstm git stash push -m
abbr --add --global grb git rebase -i
abbr --add --global grbs git rebase -i --autosquash --autostash
abbr --add --global grbc git rebase --continue
abbr --add --global gwt git worktree
abbr --add --global gwta git worktree add
abbr --add --global gwtl git worktree list
abbr --add --global gwtr git worktree remove

## docker
abbr --add --global do docker
abbr --add --global dob docker build --force-rm -t
abbr --add --global dobp docker builder prune -a
abbr --add --global doc docker container
abbr --add --global docs docker container ls -a
abbr --add --global docip docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
abbr --add --global docp docker container prune
abbr --add --global docsr docker rm \(docker stop \)
abbr --add --global dox docker exec -it
abbr --add --global doi docker image
abbr --add --global dois docker images -a
abbr --add --global doisd docker images -f dangling=true -q
abbr --add --global doip docker image prune -a
abbr --add --global doirr docker rmi \(docker images -a -f reference=\'\' -q\)
abbr --add --global dor docker run -it --rm --name
abbr --add --global dord docker run -d --rm --name
abbr --add --global dolt sudo truncate -s 0 \(docker inspect --format='{{.LogPath}}' \)
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
abbr --add --global kca kubectl apply -f
abbr --add --global kcb kubectl describe
abbr --add --global kcc kubectl create
abbr --add --global kcd kubectl delete
abbr --add --global kcdp kubectl delete pods
abbr --add --global kcds kubectl delete svc
abbr --add --global kcf kubectl config
abbr --add --global kcfgns kubectl config get-contexts
abbr --add --global kcfsns kubectl config set-context --current --namespace
abbr --add --global kcg kubectl get
abbr --add --global kcgd kubectl get deployments
abbr --add --global kcgp kubectl get pods
abbr --add --global kcgs kubectl get services
abbr --add --global kcl kubectl logs
abbr --add --global kco kubectl rollout
abbr --add --global kcoh kubectl rollout history
abbr --add --global kcos kubectl rollout status
abbr --add --global kcou kubectl rollout undo
abbr --add --global kcx kubectl exec -it

## terraform
abbr --add --global tf terraform

## go
abbr --add --global got go test
abbr --add --global gotr go test -run

## taskwarrior
abbr --add --global tt taskwarrior-tui
