# OAO Gene Clash Bot — v4.1 A/B/C batch import

**GitHub update is available.** The v4.1 change is committed as `gene-v4-to-v4.1.patch` along with an upgraded `deploy-gene-v4.sh` installer. The installer downloads the previously uploaded v4 archive, applies the v4.1 changes, tests them, backs up the live roster and .env, and deploys.

## New batch import

Use Discord `/gene batch` with one account per line:

```text
Player Name | Role(s) | March A | March B | March C | Discord ID (optional)
Winry | Lair Hitter | 45M | 40M | 35M
LittleBear | Rig Holder | 38M | 32M | 28M
```

Existing 1–4-column format still works. Empty A/B/C columns leave previously saved march values unchanged. Multiple game accounts can share the same Discord ID.

## Deploy on DigitalOcean (iPhone-friendly)

Open the console for droplet `oao-oil-clash` and paste:

```bash
cd /opt/oil-clash && git pull --ff-only && bash deploy-gene-v4.sh
```

The script refuses to deploy if the bot token file, database directory or required files are missing. It verifies the patch and runs unit tests **before** stopping the current bot. It saves a timestamped backup under `/root/`. After deployment, verify `/gene batch` and `/gene roster` in Discord.

Do not put a Discord token, .env file, or roster database in this public repository.

**Status:** GitHub patch and deployment helper committed. The live server has **not** yet been updated or verified.
