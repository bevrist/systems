#!/bin/bash
# REPOS LIST Updated `Jun 9 2023` # TODO UPDATE THIS LIST!
REPOS="git@github.com:bevrist/advent-of-code.git
git@github.com:bevrist/aws-hackathon.git
git@github.com:bevrist/b-server.git
git@github.com:bevrist/cloudflare-workers-go.git
git@github.com:bevrist/gcp-hackathon.git
git@github.com:bevrist/golang-library-bin-sizes.git
git@github.com:bevrist/isodraw.git
git@github.com:bevrist/playground.git
git@github.com:bevrist/scouting-app.git
git@github.com:bevrist/shell-compose.git
git@github.com:bevrist/simple-notify.git
git@github.com:bevrist/workout-site.git
git@github.com:bevrist/systems.git
git@github.com:bevrist/go-wake-on-lan-server.git
git@github.com:bevrist/resume.git"

BACKUP_DIR="./github-backup-$(date +"%Y_%m_%d")"
echo "backing up bevrist git repos to $BACKUP_DIR ..."; sleep 5
mkdir "$BACKUP_DIR"
cd "$BACKUP_DIR"
for repo in $REPOS ; do git clone --mirror $repo ; done
