# Tools for PHP
https://thevaluable.dev/code-quality-check-tools-php/

**PHP CodeSniffer**  
Check coding standard like missing PHPDoc and too long lines

**PHPMD**  
Works like findbugs

**PHPStan**  
Works like compilor and find errors.  
You can ignore all the errors that exists at the project generation, which is
when you have not touched anything by running:
```
vendor/bin/phpstan analyse --generate-baseline
```

**Psalm**
Basically does type checking.  
Run the command below to initialise.  
```
./vendor/bin/psalm --init
```

**PHP-CS-Fixer**  
Formatting tool  
Nice helper to write config file:
https://mlocati.github.io/php-cs-fixer-configurator/

# Vim Plugins
## PHP in general
https://thevaluable.dev/vim-php-ide/

## Laravel
https://github.com/noahfrederick/vim-laravel
