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

**Larastan**
Extension for PHPStan tailored for laravel.  
Install `--dev orchestral/testbench` as well if error occurs.

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

My config:
```php
<?php
return PhpCsFixer\Config::create()
    ->setRules([
        '@PSR2' => true,
        'binary_operator_spaces' => [
            'default' => 'single_space',
            'operators' => [
                '=>' => 'align_single_space',
            ]
        ],
    ])
;
```


**phan**
Modern code analyser.  
https://php.libhunt.com/phan-alternatives

# Vim Plugins
## PHP in general
https://thevaluable.dev/vim-php-ide/

## Laravel
https://github.com/noahfrederick/vim-laravel
