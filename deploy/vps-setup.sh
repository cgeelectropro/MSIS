#!/usr/bin/env bash
# One-shot setup for a fresh Ubuntu 22.04/24.04 VM (written for Oracle Cloud's
# "Always Free" Ampere A1 instance, but works on any Ubuntu VPS with a public
# IP and ports 80/443 reachable). Run as a user with sudo, from inside a
# clone of this repo on the VM:
#
#   git clone https://github.com/cgeelectropro/MSIS.git && cd MSIS
#   DOMAIN=your-subdomain.duckdns.org EMAIL=you@example.com ./deploy/vps-setup.sh
#
# Idempotent-ish: safe to re-run, but the certbot step will skip issuance if
# a cert for DOMAIN already exists. See PRODUCTION_READINESS.md for what this
# deliberately does NOT automate (renewal, backups off-site, monitoring).
set -euo pipefail

: "${DOMAIN:?Set DOMAIN, e.g. DOMAIN=msis-demo.duckdns.org}"
: "${EMAIL:?Set EMAIL for TLS certificate expiry notices}"

echo "==> Installing Docker + Compose plugin (skipped if already present)"
if ! command -v docker &>/dev/null; then
    curl -fsSL https://get.docker.com | sudo sh
    sudo usermod -aG docker "$USER"
fi

echo "==> Installing certbot (skipped if already present)"
if ! command -v certbot &>/dev/null; then
    sudo apt-get update -y
    sudo apt-get install -y certbot
fi

echo "==> Oracle Cloud ships Ubuntu with its OWN iptables blocking inbound"
echo "    traffic even after you open 80/443 in the Console's Security"
echo "    List/NSG — both layers need it. Opening 80/443/22 here:"
sudo iptables -C INPUT -p tcp --dport 80 -j ACCEPT 2>/dev/null || sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -C INPUT -p tcp --dport 443 -j ACCEPT 2>/dev/null || sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
sudo netfilter-persistent save 2>/dev/null || true

echo "==> Preparing root .env (compose-level secrets)"
if [ ! -f .env ]; then
    cp .env.example .env
    DB_PW=$(openssl rand -base64 24)
    ROOT_PW=$(openssl rand -base64 24)
    sed -i "s#^DB_PASSWORD=.*#DB_PASSWORD=${DB_PW}#" .env
    sed -i "s#^MYSQL_ROOT_PASSWORD=.*#MYSQL_ROOT_PASSWORD=${ROOT_PW}#" .env
    echo "    Generated random DB_PASSWORD/MYSQL_ROOT_PASSWORD in .env"
fi
# shellcheck disable=SC1091
source .env

echo "==> Preparing backend/.env"
if [ ! -f backend/.env ]; then
    cp backend/.env.example backend/.env
    sed -i "s#^DB_PASSWORD=.*#DB_PASSWORD=${DB_PASSWORD}#" backend/.env
    sed -i "s#^APP_URL=.*#APP_URL=https://${DOMAIN}#" backend/.env
    sed -i "s#^APP_DEBUG=.*#APP_DEBUG=false#" backend/.env
    echo "    NOTE: FCM_CREDENTIALS_PATH, mail, and any other real secrets still need to be set in backend/.env by hand."

    echo "==> Building the app image and generating APP_KEY (no PHP needed on the host)"
    sudo docker compose build app_laravel
    sudo docker compose run --rm app_laravel php artisan key:generate --force
else
    echo "    backend/.env already exists — leaving APP_KEY untouched (regenerating"
    echo "    it would silently break decryption of already-stored encrypted messages)."
fi

echo "==> Issuing a TLS certificate for ${DOMAIN} (standalone — needs port 80 free)"
if [ ! -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
    sudo docker compose down 2>/dev/null || true
    sudo certbot certonly --standalone -d "${DOMAIN}" --email "${EMAIL}" --agree-tos -n
else
    echo "    Certificate already exists, skipping issuance."
fi

echo "==> Rendering nginx config for ${DOMAIN}"
DOMAIN="${DOMAIN}" envsubst '${DOMAIN}' < docker/nginx/production.conf.template > docker/nginx/production.conf

echo "==> Building and starting the full stack"
sudo docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build

echo "==> Running database migrations"
sudo docker compose exec -T app_laravel php artisan migrate --force

echo ""
echo "Done. https://${DOMAIN} should be live."
echo "Reminder: certs expire in 90 days. Renewal isn't automated by this"
echo "script (see the comment in docker/nginx/production.conf.template) —"
echo "run 'sudo docker compose down && sudo certbot renew && sudo docker"
echo "compose -f docker-compose.yml -f docker-compose.prod.yml up -d' before then."
