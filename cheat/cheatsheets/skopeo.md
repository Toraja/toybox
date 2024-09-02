---
syntax: markdown
---

# List tags of a image
```sh
skopeo inspect docker://<host>/[<user>/]<image> | jq .RepoTags
```
e.g. codercom/code-server on docker hub
```sh
skopeo inspect docker://docker.io/codercom/code-server | jq .RepoTags
```
