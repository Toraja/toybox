---
syntax: markdown
---

# General

Option to specify alertmanager's URL is required unless specified in config file.
You can put username/password in the URL as basic auth.
```sh
amtool --alertmanager.url=http[s]://[<user>:<pass>@]<host> <command>
```

# List alerts

# -o option to change output format
```sh
amtool alert [query] [-o simple | extended | json]
```

# Add alerts

# Add alerts
```sh
amtool alert add [<flags>] [<labels>...]
```
e.g. Add alerts with some annotations and labels
```sh
amtool alert add --annotation=summary='test alert' --annotation=description='This is a test alert' TestAlert severity=warning job=dev_some_superjob
```

# View config
e.g. Get route config
```sh
amtool config --output json | jq -r .config.original | yq .route
```
e.g. Get receivers config
```sh
amtool config --output json | jq -r .config.original | yq .receivers
```

# Test config

# Test that with the current config, alerts with given label are redirected to the specified receiver.
```sh
amtool config routes test --tree --verify.receivers=<receiver> [<labels>...]
```

e.g. Test if alerts with labels are routed to dev-some-warning receiver.
```sh
amtool config routes test --tree --verify.receivers=dev-some-warning severity=warning job=dev_some_superjob
```
