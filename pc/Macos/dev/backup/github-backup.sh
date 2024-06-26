#!/bin/bash
# REPOS LIST Updated `Jun 9 2024` # NOTE: UPDATE THIS LIST!
REPOS="git@github.com:bevrist/advent-of-code.git
git@github.com:bevrist/cloudflare-workers-go.git
git@github.com:bevrist/golang-library-bin-sizes.git
git@github.com:bevrist/playground.git
git@github.com:bevrist/resume.git
git@github.com:bevrist/scouting-app.git
git@github.com:bevrist/shell-compose.git
git@github.com:bevrist/systems.git
git@github.com:bevrist/workout-site.git"

BACKUP_DIR="./github-backup-$(date +"%Y_%m_%d")"
echo "backing up bevrist git repos to $BACKUP_DIR ..."; sleep 5
mkdir "$BACKUP_DIR"
cd "$BACKUP_DIR"
for repo in $REPOS ; do git clone --mirror $repo ; done
