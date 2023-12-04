---
syntax: markdown
---

# Repository

## Download chart from repository
- Check if the repository for the chart has been added
    `helm repo list`
    - If not added, add the repo (`<repo name>` is arbitrary)
        `helm repo add <repo name> <repo url>`
    - Else, update the local cache of repo info
        `helm repo update <repo name>`
- Pull from repo
    `helm pull [--untar] <repo name>/<chart name>`

## Get versions of charts on repository
List latest version of each repos added by `helm repo add`.
With `filter word`, only charts that match the filter will be listed.
With `-l/--versions`, all the available versions will be listed.
`helm search repo [-l | --versions] [filter word]`
