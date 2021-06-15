FROM base_ide:latest

USER root

RUN apt-get update && apt-get install --no-install-recommends --yes \
    unzip php \
    php-cli php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-bcmath \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ARG USER
USER ${USER}

CMD ["tail", "-f", "/dev/null"]
