# PHP Language Server
## PHP Language Server
REPO: https://github.com/felixfbecker/php-language-server  

### Installation
```sh
composer global require felixfbecker/language-server
```

The below must be added to the top level of `~/.composer/composer.json`
```json
{
  ...
  "minimum-stability": "dev",
  "prefer-stable": true,
  ...
}
```

### Start Server
```sh
php ~/.composer/vendor/bin/php-language-server.php
```

## Phpactor
This is way better than PHP Language Server.  
It supports signature help and integrate with echodoc.vim  
REPO: https://github.com/phpactor/phpactor

### Installation
```sh
composer global require phpactor/phpactor
```
For vim, install is as vim plugin because as the document states, it might
confilics with other libraries.

### Start Server
```sh
# use absolute path if binary is not in PATH
phpactor language-server
```
