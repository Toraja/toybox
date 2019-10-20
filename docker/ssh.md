# Docker ssh

## Start daemon
```
# -D option tells sshd to run in foreground
/usr/sbin/sshd -D
```
If the command above is the last command (i.e. command to keep a container running),  
then when the client closes ssh connection, sshd shuts down and the container exits.  
(Is it an expected behaviour?)  
Also, if sshd is started with `RUN` instruction of dockerfile (without `-D` option),  
it has somehow exited when container is running.  
To avoid this, run sshd before the last command and use do nothing command as the last command  
(such as `tail -f /dev/null`), inside script file and set the script as `ENTRYPOINT`.  

## Access
### Network
Network needs to be created in order to access to a containter from another.  
```sh
docker network create -d bridge <network name>
```

Containers must be on the network. Add `--network <network name>` option  
to `docker run` command like below.  
```sh
docker run -it --name <container> --network <network name> <image>
```

### IP Address
IP address of docker is the one under `eth0` of `ip addr`.  
Somehow it's possible to access via default port and **not possible**  
via exposed port.  

### hostname
Service name inside `docker-compose.yml` will be the destination host.  
`hostname` specified under each service is for internal use (e.g. output of `hostname` command)  
and cannot be used as hostname for `ssh` command.
