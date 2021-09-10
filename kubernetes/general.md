# Kubernetes in general

## Kubectl
### Installation
Refer to [this
page](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

### Useful Commands
**Pass multiple file to command**  
For commands that takes `-f` or `--filename` option (`apply` etc.), pass multiple file by
concatenating them with `,`.
```fish
kubectl apply -f deployment.yml,service.yml
kubectl apply --filename=deployment.yml,service.yml
```

Note that `configmap` does not allow csv syntax, but understands the shell
array/list instead. The blow command creates `configmap` with two entries.
```fish
# this works on fish
set mylist key1=val1 key2=val2
kubectl create configmap testmap1 --from-literal=$mylist
```

## Good (if not best) Practice
### ConfigMap
#### Access updated value without restart
There is 3 ways to use `ConfigMap`; 1) container start-up command argument,
2) environment variable and 3) volume.  
With (1) and (2), updating value in `ConfigMap` does not affect value inside
runtime environment until container (or Pod?) is restarted, While with (3),
values in the mounted volume are updated (not immediately but within a few
mimutes) when `ConfigMap` is updated.  
So, to use the updated value (though this is my untested best guess), match the
`Key` of `ConfigMap` the config file an process uses, set `Value` in the format
that the process understands (JSON, YAML, TOML etc.). Then have the process
monitored the file and reloaded config when change to the file is observed.  
Obviously, this does not work for processes that do not have such capability
(e.g. nginx). In such case, use another process (or container?) to reboot the
process when change in the config file is observed.

## Local Kubernetes Engines
### Minikube
https://minikube.sigs.k8s.io/docs/  
Official kubernetes engine only for local development.  
Requires `systemctl` (?)  

### MicroK8s
https://duckduckgo.com/?t=ffab&q=microk8s&atb=v268-1&ia=web  
Requires `systemctl`  

### K3d
https://k3d.io/  
Lightweight kubernetes engine using docker.  
Suitable for WSL since it does not require `systemctl`  
Note that version of `kubectl` needs to be same as the version of k3s which k3d
bases on.  

#### Start up
Run below command to start up k3d.  
To enable access to pods/containers inside kubernetes cluster, port must be
exposed.  
Range of port can be expose as demonstrated in the below commands.
```sh
# Using NodePort as frontend.
k3d cluster create mycluster --registry-create --api-port 6550 --port '30000-30001:30000-30001@agent[0]' --agents 2 # --volume ~/workspace:/workspace

# Using LoadBalancer as frontend.
# It simply transfers request to pods listening to the same port.
k3d cluster create mycluster --registry-create --api-port 6550 --port '30000-30010:30000-30010@loadbalancer' --agents 2 # --volume ~/workspace:/workspace
```

The below seems not needed
```
export KUBECONFIG="$(k3d get-kubeconfig --name=k3s-default)"
```
