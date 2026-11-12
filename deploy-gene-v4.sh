#!/usr/bin/env bash
set -euo pipefail
APP="/opt/oil-clash/bot-files/oil-clash-bot"
REPO_ZIP="https://raw.githubusercontent.com/winryelric3245-afk/Oil-clash/main/OAO_Gene_Clash_v4_Quick_Assign.zip"
echo "Gene Clash v4 upgrade (keeps .env and data)"
command -v docker >/dev/null
docker compose version >/dev/null
command -v unzip >/dev/null || { apt-get update && apt-get install -y unzip; }
command -v curl >/dev/null || { apt-get update && apt-get install -y curl; }
test -f "$APP/.env" || { echo "Missing .env; refusing deployment"; exit 1; }
test -d "$APP/data" || { echo "Missing data directory; refusing deployment"; exit 1; }
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
curl -fLsS "$REPO_ZIP" -o "$WORK/v4.zip"
unzip -q "$WORK/v4.zip" -d "$WORK/new"
SOURCE="$WORK/new/oil-clash-bot"
for f in bot.py storage.py compose.yaml Dockerfile requirements.txt; do
  test -s "$SOURCE/$f" || { echo "Missing $f in v4 ZIP; stopping"; exit 1; }
done
BACKUP="/root/gene-clash-pre-v4-$(date +%Y%m%d-%H%M%S).tgz"
tar -czf "$BACKUP" -C "$APP" .env data bot.py storage.py compose.yaml Dockerfile requirements.txt
echo "Backup saved: $BACKUP"
cd "$APP"
docker compose stop
for f in bot.py storage.py compose.yaml Dockerfile requirements.txt README.md launch.sh; do
  if [ -f "$SOURCE/$f" ]; then cp "$SOURCE/$f" "$APP/$f"; fi
done
chmod 600 "$APP/.env"
docker compose up -d --build
docker compose ps
docker compose logs --tail=40
echo "Update installed. Verify Discord /gene commands and existing roster."
