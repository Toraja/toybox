FROM base_ide:latest

USER root

RUN apt-get update && apt-get install --no-install-recommends --yes \
    unzip php \
    php-cli php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-bcmath \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL -o /usr/local/bin/phpctags https://raw.githubusercontent.com/vim-php/phpctags/gh-pages/install/phpctags.phar \
    && chmod +x /usr/local/bin/phpctags

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ARG USER
USER ${USER}

# php-parser is required by phpctags
RUN composer global require --dev \
    emielmolenaar/phpcs-laravel \
    friendsofphp/php-cs-fixer \
    nunomaduro/larastan \
    phpstan/phpstan \
    phpmd/phpmd \
    squizlabs/php_codesniffer \
    nikic/php-parser
# phpactor is installed via vim's plugin manager since phpactor is likely to cause
# conflicts with other packages.

CMD ["tail", "-f", "/dev/null"]
