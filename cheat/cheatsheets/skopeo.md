---
syntax: markdown
---

# List tags of a image
`skopeo inspect docker://<host>/[<user>/]<image> | jq .RepoTags`
e.g. codercom/code-server on docker hub
`skopeo inspect docker://docker.io/codercom/code-server | jq .RepoTags`
