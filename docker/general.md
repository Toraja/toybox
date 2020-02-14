# Docker in general

## Troubleshoot
- `docker login` fails
  Install `gnupg2` and `pass` package

## Best practice
- Place `ARG` as later as possible since the change in the value causes to
  invalidate all the later images and not to cache.

## Useful commands
**Find images matching name**  
Specify the as reference. Wildcard can be used but it does not match '/'.  
i.e. To match `toraja/alps`, it must be `toraja/*` or `*/alps`.  
```
docker images -a -f reference=''
```

**Find modifed files/directory since the container is created**
```
docker diff CONTAINER
```

## Misc
- To use GUI app, set `DISPLAY` environment variable on the container to the
  same value as the one on the host.
