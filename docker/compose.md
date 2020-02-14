# Docker Compose

## docker-compose.yml

### Environment variables
**Terminology**
- `.env` variables: variables defined in `.env` file
- `compose` variables: variables listed under `environment` key
- `env_file` variables: variables defined in a file listed under `env_file` key

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

<span id=env_example>**Eg. Use environment variables inside Dockerfile**</span>

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
....
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
....
volumes:
  static:
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
