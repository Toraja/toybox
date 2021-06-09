# Docker Compose

## docker-compose.yml

### Variable substitution
**Default value**  
`${VARIABLE:-default}`

**Error if not set**
`${VARIABLE:?error msg}`  
`error msg` is optional.  
The below is an example of message by docker when the variable is not set.  
`<error msg>` in the message will be replaced by the string you define along
with the variable.
```
# message from docker-compose
ERROR: Missing mandatory value for "image" option interpolating python-tdd_app_${ENV_TYPE:?} in service "app": <error msg>

# message from docker stack
invalid interpolation format for services.app.image: "required variable ENV_TYPE is missing a value: <error msg>". You may need to escape any $ with another $.
```

Colon after variable name means docker considers variable is not set when the
variable IS set but EMPTY. With colon, the value of variable does not matter as
long as the variable is defined.

### Environment variables
#### Terminology
These are terminologies that are used in this section.
- `.env` variables: variables defined in `.env` file
- `compose` variables: variables listed under `environment` key
- `env_file` variables: variables defined in a file listed under `env_file` key

#### Characteristics of each environment variables
- `.env` variables will be accessible from within compose file.
- `.env` variables are for docker and not accessible from containers unless they
  are `compose` or `env_file` variables.
- For `compose` and `env_file` to take effect, containers must be `down` and
  `up` again.  
- `env_file` variables are only accessible from containers, not from compose file.
- It is possible to list only variable name (without _=value_) in `env_file`,
  then the value of the variable will be inherited from host or `.env`.
- `compose` and `env_file` variables are for runtime only and not available
  during build time (both on Dockerfile and inside containers). To use those
  variables while building, use `arg` under `build` key in compose file and use
  `ARG` and `ENV` on Dockerfile. See the [example](#env_example) below.  
  Note that `ENTRYPOINT` and `CMD` are runtime so `.env` variables are
  accessible from the command.

<span id="env_example"></span>
#### Example use of environment variables inside Dockerfile

Scneario: Build process requires `ENV_TYPE` environment variables to be defined.  
(The example below assumes `ENV_TYPE` is already defined on the host or inside
.env file)

**docker-compose**
```yaml
services:
  app:
    build:
      context: .
      args:
        # Without value, it is filled with the value of the environment variable
        # of the same name
        - ENV_TYPE
```
**Dockerfile**
```dockerfile
...
# `ENV_TYPE` is filled with the `ENV_TYPE` on copmose file
ARG ENV_TYPE
# ${ENV_TYPE} is evaluated as `ENV_TYPE` defined with ARG, then it is assigned
# to `ENV_TYPE` environment variable and will be available inside container.
ENV ENV_TYPE ${ENV_TYPE}
...
```

### Volumes

#### Volume sharing
In the example below, the contents in `/app/static` of `app` and
`/opt/app/static` of `webserver` will be same, and modification to one will be
shared to the other.
```yaml
services:
  app:
    volumes:
      - type: volume
        source: static
        target: /app/static
....
  webserver:
    volumes:
      - type: volume
        source: static
        target: /opt/app/static
volumes:
  static:
```

#### NFS volume

##### Setup NFS
Reference: [How to Install and Configure an NFS Server on Ubuntu 18.04 | Linuxize](https://linuxize.com/post/how-to-install-and-configure-an-nfs-server-on-ubuntu-18-04/)  

**Senario**: `master` as NFS server, `app` and `web` as clients

Install NFS server on `master` nodes
```sh
apt install nfs-kernel-server
```

Install NFS client on `app` and `web` nodes
```sh
apt install nfs-common
```

On `master`, create a directory to be shared.  
Here, it will be `/nfs/static`.  
To allow clients to write to NFS mount, `chmod` the directory.

Next, add below to `/etc/exports`  
(`app/web` can be IP address)
```
/nfs/static     app(rw,sync,no_subtree_check) web(ro,sync,no_subtree_check)
```

Then run the command below
```sh
sudo exportfs -ra
```

To check if successfully exported, run:
```sh
sudo exportfs -v
```

##### Compose file
```yaml
volumes:
  static:
    driver_opts:
      type: nfs
      o: addr=<ip/hostname>,rw # ip or DNS resolvable name of NFS server
      device: ":/nfs/static" # path to NFS share on NFS server
```

### Networks

#### Static IP address
```yaml
services:
  app:
....
    networks:
      netty:
        ipv4_address: 172.16.0.11
....
  webserver:
    networks:
      netty:
        ipv4_address: 172.16.0.10
....
networks:
  netty:
    driver: bridge
    ipam:
      config:
        - subnet: 172.16.0.0/24
```

### Tips
- `config` command validates `docker-compose.yml` evaluating variables in the file.
- If you need to override compose configuration (e.g. for dev environment),
  create `dockerfile-compose.override.yml` and the configuration inside it will
  override the ones in `docker-compose.yml`. Note that list options such as
  `environments` and `volumes` are not overridden but merged (i.e. entries from
  both compose files will be available), unless certain condition is met (same
  name for `environment` and same target path for `volumes`).
- In override compose file, add `image` key or specify different `image` if
  overriding container uses different Dockerfile and you do not want to override
  the original image.
