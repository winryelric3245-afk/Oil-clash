#!/usr/bin/env bash
set -euo pipefail
APP="/opt/oil-clash/bot-files/oil-clash-bot"
REPO="https://raw.githubusercontent.com/winryelric3245-afk/Oil-clash/main"
echo "Gene Clash v4.1 upgrade (preserves .env and roster)"
for name in docker curl unzip patch python3; do
  command -v "$name" >/dev/null || { echo "Missing $name. Install first."; exit 1; }
done
docker compose version >/dev/null
test -f "$APP/.env" || { echo "Missing .env. Refusing deployment."; exit 1; }
test -d "$APP/data" || { echo "Missing data folder. Refusing deployment."; exit 1; }
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
curl -fLsS "$REPO/OAO_Gene_Clash_v4_Quick_Assign.zip" -o "$WORK/v4.zip"
curl -fLsS "$REPO/gene-v4-to-v4.1.patch" -o "$WORK/v4.1.patch"
unzip -q "$WORK/v4.zip" -d "$WORK/new"
SOURCE="$WORK/new/oil-clash-bot"
for f in bot.py storage.py compose.yaml Dockerfile requirements.txt; do
  test -s "$SOURCE/$f" || { echo "Missing $f in archive"; exit 1; }
done
cd "$SOURCE"
patch --batch --forward --dry-run -p1 < "$WORK/v4.1.patch"
patch --batch --forward -p1 < "$WORK/v4.1.patch"
python3 -m compileall -q bot.py storage.py
python3 -m unittest discover -s tests -q
echo "v4.1 patch and tests passed. Backing up live deployment."
BACKUP="/root/gene-clash-pre-v4.1-$(date +%Y%m%d-%H%M%S).tgz"
tar -czf "$BACKUP" -C "$APP" .env data bot.py storage.py compose.yaml Dockerfile requirements.txt
echo "Backup: $BACKUP"
cd "$APP"
docker compose stop
for f in bot.py storage.py compose.yaml Dockerfile requirements.txt README.md launch.sh; do
  if [ -f "$SOURCE/$f" ]; then cp "$SOURCE/$f" "$APP/$f"; fi
done
chmod 600 "$APP/.env"
docker compose up -d --build
docker compose ps
docker compose logs --tail=40
echo "Gene Clash v4.1 installed; verify Discord /gene batch and saved roster."
