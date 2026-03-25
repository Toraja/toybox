---
syntax: markdown
---

# Image

## Find images matching name
Specify the image name as reference. Wildcard can be used but it does not match `/`.
i.e. To match `toraja/alps`, it must be `toraja/*` or `*/alps`.
```sh
docker images -a -f reference='<image name>'
```

## View list of commands applied to an image (like Dockerfile)
```sh
docker [image] history --no-trunc <image name>
```

# Container

## Find modifed files/directory since the container is created
```sh
docker diff <container>
```

## Get IP address of container
```sh
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container>
```

# Volume

## Rename volume (kind of)
```sh
docker volume create --name <new_volume>
docker run --rm -it -v <old_volume>:/from -v <new_volume>:/to alpine ash -c "cd /from ; cp -a . /to"
docker volume rm <old_volume>
```

# Log

## Get log file path of container
```sh
docker inspect --format='{{.LogPath}}' <container>
```

## Truncate the log
```sh
sudo truncate -s 0 (docker inspect --format='{{.LogPath}}' <container>)
```

# Prune

## Prune everything
```sh
docker system prune -all
docker volume prune -all
```

# Misc

## Get capacity that docker related stuff occupies
```sh
docker system df -v
```
