if status --is-interactive
## ubuntu
    abbr --add --global apd sudo apt update
    abbr --add --global apg sudo apt upgrade
    abbr --add --global apl apt list
    abbr --add --global aplg apt list --upgradable
## shell
    abbr --add --global mg mkdirgo
    abbr --add --global fig find -type f -exec grep -Hn {} \\\;
## git
    abbr --add --global gb git branch
    abbr --add --global gs git status
    abbr --add --global gl git log
    abbr --add --global glf 'git log --oneline | fzf | awk \'{print $1}\''
    abbr --add --global gd git diff
    abbr --add --global gdc git diff --cached
    abbr --add --global gdt git difftool
    abbr --add --global gdtc git difftool --cached
    abbr --add --global ga git add
    abbr --add --global gai git add -i
    abbr --add --global gcm git commit -m
    abbr --add --global gw git switch
    abbr --add --global gr git reset
    abbr --add --global grs git restore
    abbr --add --global gst git stash
    abbr --add --global gstl git stash list
    abbr --add --global gstp git stash pop
    abbr --add --global gstm git stash push -m
    abbr --add --global grb git rebase -i
    abbr --add --global grbs git rebase -i --autosquash --autostash
    abbr --add --global grbc git rebase --continue
## docker
    abbr --add --global do docker
    abbr --add --global dob docker build --force-rm -t
    abbr --add --global doc docker container
    abbr --add --global docs docker container ls -a
    abbr --add --global docip docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
    abbr --add --global docp docker container prune
    abbr --add --global docsr docker rm \(docker stop \)
    abbr --add --global dox docker exec -it
    abbr --add --global doi docker image
    abbr --add --global dois docker images -a
    abbr --add --global doisd docker images -f dangling=true -q
    abbr --add --global doip docker image prune -f
    abbr --add --global doirr docker rmi \(docker images -a -f reference=\'\' -q\)
    abbr --add --global dor docker run -it --name
    abbr --add --global dord docker run -d --name
    abbr --add --global dolt sudo truncate -s 0 \(docker inspect --format='{{.LogPath}}' \)
## docker swarm
    abbr --add --global dow docker swarm
    abbr --add --global dowi docker swarm init --advertise-addr \(hostname -i\)
    abbr --add --global dost docker stack
    abbr --add --global dostd docker stack deploy
    abbr --add --global dosv docker service
    abbr --add --global dosvl docker service logs
## docker-compose
    abbr --add --global dc docker-compose
    abbr --add --global dcx docker-compose exec
    abbr --add --global dcb docker-compose build
    abbr --add --global dcd docker-compose down
    abbr --add --global dcu docker-compose up -d
    abbr --add --global dcub docker-compose up -d --build
    abbr --add --global dcl docker-compose logs --follow
    abbr --add --global dcr docker-compose run
    abbr --add --global dce docker-compose restart
## go
    abbr --add --global got go test
    abbr --add --global gotr go test -run
end
