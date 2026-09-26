#!/bin/sh
set -e

if [ ! -f .env ]; then
    cp .env.example .env
fi

# `php artisan serve` only forwards a whitelist of environment variables to its workers,
# so write the container settings into .env where every process will read them.
for var in APP_URL DB_CONNECTION DB_HOST DB_PORT DB_DATABASE DB_USERNAME DB_PASSWORD QUEUE_CONNECTION; do
    value=$(printenv "$var" || true)
    if [ -n "$value" ]; then
        if grep -q "^$var=" .env; then
            sed -i "s|^$var=.*|$var=$value|" .env
        else
            echo "$var=$value" >> .env
        fi
    fi
done

if ! grep -q '^APP_KEY=base64:' .env; then
    php artisan key:generate --force
fi

# Only the web container prepares the database; queue/scheduler just wait for it.
if [ "${RUN_MIGRATIONS:-false}" = "true" ]; then
    php artisan migrate --force
    php artisan db:seed --force
    php artisan filament:assets
fi

exec "$@"
