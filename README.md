# OAO Gene Clash Discord Bot

This repository currently contains the v3 archive. The **Gene Clash v4 Quick Assign** release must be uploaded as `OAO_Gene_Clash_v4_Quick_Assign.zip` before deployment.

## v4 update highlights
- Gene Clash and Action Points naming
- Multiple game accounts per Discord member
- Separate action points, reset availability, and A/B/C march power per game account
- Roster ordered by available-first, then total march power
- Quick role assignment: Lair Hitter or Rig Holder
- Admin-only new week, clear players, and full reset, with confirmation
- Save players, roles, and march power through new week

## Safe update on existing DigitalOcean server

1. Upload `OAO_Gene_Clash_v4_Quick_Assign.zip` to the **main** branch of this repository and commit.
2. Connect to the **oao-oil-clash** server console.
3. Run:

```bash
cd /opt/oil-clash && git pull --ff-only
bash /opt/oil-clash/deploy-gene-v4.sh
```

The script creates a timestamped backup of .env, database data, and old code before replacing the running bot. It uses the existing server path `/opt/oil-clash/bot-files/oil-clash-bot`, preserves the Discord token and database, builds the container, and displays startup logs.

**Do not run the deployment until the v4 archive exists in the repository.** Do not upload Discord tokens, `.env`, or your database.

Local v4 test result: **22 tests passed**. Live Discord deployment not yet verified.
