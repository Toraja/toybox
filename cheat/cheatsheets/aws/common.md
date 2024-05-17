---
syntax: markdown
---

# Specify endpoint URL
```sh
aws --endpoint-url https://xxx s3 ls
```

# Credential

## Setup

Commands below add credentials to `~/.aws/credentials`.
Without `--profile` flag, the command sets up default profile.
```sh
aws configure set [--profile <profile>] aws_access_key_id <ID>
aws configure set [--profile <profile>] aws_secret_access_key <SECRET>
```

## Usage
Set `AWS_PROFILE` environment variable to one of the profiles in `~/.aws/credentials`.
