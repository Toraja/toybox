# Docker swarm

## Setup

### Initialise docker swarm
On the node (machine, instance, etc.) you want to use as manager
(controlling/orchestrating other swarm nodes), run:
```sh
docker swarm init --advertise-addr $(hostname -i)
```

This command will output something like:
```
Swarm initialized: current node (y2e3dgbu0omfv0e5ipimwj58d) is now a manager.

To add a worker to this swarm, run the following command:

docker swarm join --token SWMTKN-1-186u2xbsmu9qaq63dipulozntw7p367fqspo8kwasxvu0qathv-67ybrwj1r2pkz1utpep342vcp 10.138.0.12:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

### Add worker nodes
Go to the nodes you want to add and run the command output above.
```sh
docker swarm join --token SWMTKN-1-186u2xbsmu9qaq63dipulozntw7p367fqspo8kwasxvu0qathv-67ybrwj1r2pkz1utpep342vcp 10.138.0.12:2377
```

### Check if node is in swarm mode
```sh
docker info -f '{{ .Swarm.LocalNodeState }}'
```

### Label nodes
Label is useful for cases like controlling to deploy which service to which
node (`constraints` key).

To add label to node, run:
```sh
docker node update --label-add <LABELS...> <NODE>
```
Where `<NODE>` is `self` for the current node, or with node ID or hostname for
others, which can be found out by running `docker node ls`.

To see what label a node has, run:
```sh
docker node inspect -f '{{range $k, $v := .Spec.Labels }}{{ printf "%s: %s\n" $k $v }}{{end}}' <NODE>
```

### Deploy
<mark>NOTE</mark>: `docker stack` requires images either to be pullable or to
exist locally to the node running the task.
```sh
docker stack deploy <stack name>
```
If you need multiple compose files:
```sh
docker stack deploy --compose-file=docker-compose.stack.yml--compose-file=docker-compose.stack.yml <stack name>
```
`<stack name>` is an arbitrary string.

## Inspection

### List nodes for the manager node
This command can be run only on manager node
```sh
docker node ls
```
```
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2zmfwpmegwbx8bqcqpoln2eks     app                 Ready               Active                                  19.03.6
y2e3dgbu0omfv0e5ipimwj58d *   master              Ready               Active              Leader              19.03.6
yvx2s4rjn63soyoecshaavobh     web                 Ready               Active                                  19.03.6
```

### View stacks and the number of services running on each stack
```sh
docker stack ls
```
```
NAME                SERVICES            ORCHESTRATOR
python-tdd          3                   Swarm
```

### List services of a stack
```sh
docker stack services <stack name>
```
```
ID                  NAME                    MODE                REPLICAS            IMAGE                             PORTS
s3gilv095ufo        python-tdd_webserver    replicated          1/1                 python-tdd_webserver:latest       *:80->80/tcp
w6i3ydtv5m4d        python-tdd_visualizer   replicated          0/1                 dockersamples/visualizer:stable
yzw6fjz3621o        python-tdd_app          replicated          2/2                 python-tdd_app_prd:latest
```
The numerator of `REPLICAS` indicates the number or currently running containers
of the service.

### List the status and tasks (containers) of all services
```sh
docker stack ps <stack name>
```
```
ID                  NAME                      IMAGE                             NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
h8ynoev35ej1        python-tdd_webserver.1    python-tdd_webserver:latest       DESKTOP-7MRFM0N     Running             Running 12 minutes ago
jcvkijyqqjbx        python-tdd_visualizer.1   dockersamples/visualizer:stable                       Running             New 12 minutes ago
dan7ivthkooq        python-tdd_app.1          python-tdd_app_prd:latest         DESKTOP-7MRFM0N     Running             Running 12 minutes ago
d354o6u5s5o2        python-tdd_app.2          python-tdd_app_prd:latest         DESKTOP-7MRFM0N     Running             Running 13 seconds ago
```

### List the status and tasks (containers) of a service
```sh
docker service ps <service name>
```
Running service:
```
ID                  NAME                IMAGE                       NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
dan7ivthkooq        python-tdd_app.1    python-tdd_app_prd:latest   DESKTOP-7MRFM0N     Running             Running 16 minutes ago
d354o6u5s5o2        python-tdd_app.2    python-tdd_app_prd:latest   DESKTOP-7MRFM0N     Running             Running 4 minutes ago
```
Failing service:
```
ID                  NAME                         IMAGE                         NODE                DESIRED STATE       CURRENT STATE           ERROR                       PORTS
uam71kp3pw7e        python-tdd_webserver.1       python-tdd_webserver:latest   DESKTOP-7MRFM0N     Ready               Ready 1 second ago                               
kr65902tgkru         \_ python-tdd_webserver.1   python-tdd_webserver:latest   DESKTOP-7MRFM0N     Shutdown            Failed 4 seconds ago    "task: non-zero exit (1)"
pmye9rbvx4uy         \_ python-tdd_webserver.1   python-tdd_webserver:latest   DESKTOP-7MRFM0N     Shutdown            Failed 11 seconds ago   "task: non-zero exit (1)"
olr0cdcgjk48         \_ python-tdd_webserver.1   python-tdd_webserver:latest   DESKTOP-7MRFM0N     Shutdown            Failed 18 seconds ago   "task: non-zero exit (1)"
zblotcunf5nm         \_ python-tdd_webserver.1   python-tdd_webserver:latest   DESKTOP-7MRFM0N     Shutdown            Failed 26 seconds ago   "task: non-zero exit (1)"
```
You can find `<service name>` under `NAME` of the output of `docker stack
services` command.  

### Get the detail of a service
```sh
docker service inspect --pretty <service name>
```
Without `--pretty`, it returns json, which can be formatted with `--format`
option.

### View logs of a service
(aggregate of logs output by all containers belonging to the service)
```sh
docker service logs <service name>
```

## Shutdown

### Stop the whole stack
```sh
docker stack rm <stack name>
```

### Stop single service
```sh
docker service rm <service name>
```

### Terminate swarm mode
Note that running this on manager node 
```sh
docker swarm leave
```
