FROM php:8.1.0-fpm

ARG APCU_VERSION=5.1.21

LABEL Maintainer="Maris Liepins"

RUN apt-get update && apt-get install -y \
    build-essential \
    libicu-dev \
    librabbitmq-dev \
    libzip-dev \
    locales \
    libonig-dev \
    curl \
    zip \
    unzip \
    git \
    curl \
    wget \
    supervisor

RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

RUN docker-php-ext-configure zip

RUN docker-php-ext-install \
        bcmath \
        mbstring \
        pcntl \
        intl \
        zip \
        opcache

RUN pecl install \
        apcu-${APCU_VERSION} \
        xdebug \
        amqp \
    && docker-php-ext-enable \
        apcu \
        xdebug \
        intl \
        amqp


RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget https://cs.symfony.com/download/php-cs-fixer-v2.phar -O /usr/local/bin/php-cs-fixer
RUN chmod +x /usr/local/bin/php-cs-fixer

RUN apt-get update && apt-get install -y gnupg2
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn
RUN yarn install

# Install symfony cli https://symfony.com/download
RUN echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | tee /etc/apt/sources.list.d/symfony-cli.list
RUN apt update
RUN apt install -y symfony-cli

COPY . /var/www
WORKDIR /var/www

ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN composer install --no-interaction
RUN chmod +x /usr/local/bin/composer

EXPOSE 8000

CMD ["php-fpm"]

# Serve symfony
CMD symfony server:start
