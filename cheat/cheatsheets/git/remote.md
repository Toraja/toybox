# Set upstream automatically

In `.gitconfig`, add:
```ini
[push]
	default = current
```

## Without -u option, git pull complains that it does not know where to pull from.
```sh
git push -u
```

# Delete remote branch
```sh
git push origin :<branch>
```
