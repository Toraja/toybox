# Docker in general

## Troubleshoot
- `docker login` fails  
  Install `gnupg2` and `pass` package

## Best practice
- Place `ARG` as later as possible since the change in the value causes to
  invalidate all the later images and not to cache.

## Change detach key
By default, detach key is bound to Ctrl-p, and it causes glitchy behaviour when
working inside containers (e.g. `sh`, `vim`).  
Change the keybind to other key by adding `"detachKeys": "ctrl-<key>,<key>"` to
`~/.docker/config.json` file. (Create it if not exist)  
Some synbols can be used. (My choice is `ctrl-^,^`)  
Reference: [Use the Docker command line | Docker Documentation](https://docs.docker.com/engine/reference/commandline/cli/#default-key-sequence-to-detach-from-containers)

## Misc
- To use GUI app, set `DISPLAY` environment variable on the container to the
  same value as the one on the host.
