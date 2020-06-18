# Docker Machine
## Installation
Change version to your desired one
```sh
sudo curl -L -o /usr/local/bin/docker-machine https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-$(uname -s)-$(uname -m)
```

## Setup
### GCP
#### Permissions
Create service accound with the below permissions.
- compute.firewalls.create
- compute.networks.updatePolicy
- compute.instances.create
- compute.disks.create
- compute.images.useReadOnly
- compute.subnetworks.use
- compute.subnetworks.useExternalIp
- compute.instances.setTags
- compute.instances.setServiceAccount
The first 2 are sufficed by `Compute Security Admin` role.
The rest are sufficed by `Compute Instance Admin (v1)` role.
The accound must also have `Service Account User` role.

Refer to [this page](https://cloud.google.com/iam/docs/understanding-roles) for
the list of roles and permissions.

#### Credential
Download the key of the service account and place it somewhere on your local
machine, and set an environment variable as below:
```sh
export GOOGLE_APPLICATION_CREDENTIALS=<PATH_TO_THE_KEY>
```

#### Run docker commands on local terminal
By setting environment variables, you will be able to run docker command in
remote machine without SSH. Run:
```sh
eval $(docker-machine env docintosh)
```
The command might fail telling you that you need to run `docker-machine
regenerate-certs [machine name]`. And when you run `docker-machine
regenerate-certs`, it might timeout.  
I fixed this by restarting system of VM by running `sudo shutdown -r`.  

## Configuration
To change docker machine's port for SSH access, open
`~/.docker/machine/machines/<MACHINE_NAME>/config.json` and change the value of
`SSHPort`.

## Usage
Remember to set an environment variable before running any command.  
Refer to [Credential section](#credential) for how.  
Otherwise, you might see the error below.
```
Error checking TLS connection: google: could not find default credentials. See https://developers.google.com/accounts/docs/application-default-credentials for more information.
```

### Create VM
```sh
docker-machine create --driver google --google-project <PROJECT ID> --google-machine-type f1-micro --google-disk-size 30 --google-machine-image <PROJECT ID>/glo bal/images/ubuntu1804-mini-basic --google-zone us-west1-b [machine name]
```
To see what parameters are available, run:
```sh
docker-machine create --help | less;
```
For cloud specific parameters, run:
```sh
docker-machine create --driver google --help | less;
```

### List docker machines
```sh
docker-machine ls
```

### Start instance
```sh
docker-machine start [machine name]
```

### Stop instance
```sh
docker-machine stop [machine name]
```

### SSH into instance
```sh
docker-machine stop [machine name]
```
