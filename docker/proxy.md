# Docker behind Proxy

## systemd

This is used for `docker pull` etc.

- Edit `/etc/systemd/system/docker.service.d/proxy.conf`
  ```
  [Service]
  Environment="HTTP_PROXY=<proxy>"
  Environment="HTTPS_PROXY=<proxy>"
  ```
- Load the config
  ```
  systemctl daemon-reload
  systemctl restart docker
  ```

## Docker config

This is used for image build and runtime.

- Edit `~/.docker/config.json`
  ```json
  {
    "proxies": {
      "default": {
        "httpProxy": "<proxy>",
        "httpsProxy": "<proxy>",
        "noProxy": "localhost,127.0.0.0/8"
      }
    }
  }
  ```
