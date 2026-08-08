# Root-level mirror of backend/Dockerfile.render, path-adjusted for a
# repo-root build context — Render's web-service creation defaults to
# ./Dockerfile with context ".", with no way to point it at a nested
# Dockerfile via this integration. Free-tier demo profile only (SQLite,
# sync queue, no Reverb — see backend/Dockerfile.render's own header and
# PRODUCTION_READINESS.md for why this isn't the real SRS §25 architecture).
FROM php:8.4-cli

RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libonig-dev libsqlite3-dev sqlite3 \
    && docker-php-ext-install pdo_sqlite zip gd \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY backend/composer.json backend/composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

COPY backend/ .
RUN composer dump-autoload --optimize \
    && mkdir -p database \
    && touch database/database.sqlite \
    && chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache /var/www/database

CMD ["sh", "-c", "export APP_KEY=$(php artisan key:generate --show) && php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=${PORT:-8080}"]
