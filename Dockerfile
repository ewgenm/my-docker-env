FROM debian:bookworm

# 1. Замена зеркала на mirror.corbina.net в новом формате deb822 (Bookworm)
RUN sed -i 's|deb.debian.org|mirror.corbina.net|g' /etc/apt/sources.list.d/debian.sources

# 2. Установка базовых зависимостей и добавление репозитория PHP 8.3 (Ondřej Surý)
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    curl \
    wget \
    unzip \
    git \
    && curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ bookworm main" > /etc/apt/sources.list.d/php.list

# 3. Установка Apache, PHP 8.3 и расширений для Laravel и PostgreSQL
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
    nodejs \
    composer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

    RUN apt-get update && apt-get install -y npm

# 4. Включение модулей Apache
RUN a2enmod rewrite && a2enmod headers

# 5. Копируем скрипт автоматической настройки хостов
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 6. Рабочая директория
WORKDIR /var/www/html

# 7. Точка входа
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]


