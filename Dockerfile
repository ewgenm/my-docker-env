FROM debian:bookworm

# (Опционально) Исправление зеркала – если mirror.corbina.net недоступен, замените на deb.debian.org
RUN sed -i 's|deb.debian.org|mirror.corbina.net|g' /etc/apt/sources.list.d/debian.sources

# Базовые пакеты и репозиторий PHP
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    curl \
    wget \
    unzip \
    git \
    postgresql-client \
    && curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ bookworm main" > /etc/apt/sources.list.d/php.list

# Установка Node.js 20.x (и npm) через NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Установка Apache, PHP, расширений, Composer (без nodejs)
RUN apt-get update && apt-get install -y \
    apache2 \
    php8.3 \
    libapache2-mod-php8.3 \
    php8.3-pgsql \
    php8.3-redis \ 
    php8.3-mbstring \
    php8.3-xml \
    php8.3-curl \
    php8.3-zip \
    php8.3-gd \
    php8.3-bcmath \
    php8.3-intl \
    composer \
    iputils-ping \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Включение модулей Apache
RUN a2enmod rewrite && a2enmod headers

# Копируем entrypoint и т.д.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]