#!/bin/bash
set -e

PROJECTS_DIR="/var/www/html"
APACHE_SITES_AVAILABLE="/etc/apache2/sites-available"
APACHE_SITES_ENABLED="/etc/apache2/sites-enabled"

# Очищаем старые сгенерированные конфиги
rm -f $APACHE_SITES_AVAILABLE/auto_*.conf
rm -f $APACHE_SITES_ENABLED/auto_*.conf

# Проходим по всем папкам в projects
for dir in "$PROJECTS_DIR"/*; do
    if [ -d "$dir" ]; then
        project_name=$(basename "$dir")
        
        # Исправляем права для Laravel проектов
        if [ -d "$dir/storage" ]; then
            chown -R www-data:www-data "$dir/storage"
            chmod -R 775 "$dir/storage"
        fi
        
        if [ -d "$dir/bootstrap/cache" ]; then
            chown -R www-data:www-data "$dir/bootstrap/cache"
            chmod -R 775 "$dir/bootstrap/cache"
        fi
        
        # Определяем, является ли проект Laravel
        if [ -f "$dir/public/index.php" ]; then
            doc_root="/$project_name/public"
        else
            doc_root="/$project_name"
        fi

        # Создаем конфигурацию VirtualHost
        cat <<EOF > "$APACHE_SITES_AVAILABLE/auto_${project_name}.conf"
<VirtualHost *:80>
    ServerName ${project_name}.test
    ServerAlias *.${project_name}.test
    DocumentRoot ${PROJECTS_DIR}${doc_root}

    <Directory ${PROJECTS_DIR}${doc_root}>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/${project_name}_error.log
    CustomLog \${APACHE_LOG_DIR}/${project_name}_access.log combined
</VirtualHost>
EOF

        # Включаем сайт
        ln -s "$APACHE_SITES_AVAILABLE/auto_${project_name}.conf" "$APACHE_SITES_ENABLED/"
    fi
done

# Запускаем Apache
exec apache2ctl -D FOREGROUND