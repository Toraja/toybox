---
syntax: markdown
---

# Template only subset of helmfile
Go to the directory where the root helmfile resides (the one that defines `environments`).
This is not necessary if the helmfile does not use environments.

## Generate manifests
```sh
helmfile [-e <env>] -f <path to helmfile> template --output-dir <dir>
```
