#!/bin/bash

REPO="/Users/bevrist/.backup/restic-repo"
GOOGLE_DRIVE_ROOT_PATH="/Users/bevrist/Library/CloudStorage/GoogleDrive-brettevrist10@gmail.com/My Drive/"
BACKUP_LOCKFILE="/tmp/cron_backup/_last-backup"

# restic backup immediately
rm -f "$BACKUP_LOCKFILE"
~/dev/backup/cron-backup.sh

# copy restic repo to B-Server
rsync -rvzh --delete --info=progress2 --append-verify -e 'ssh -p 2215' "$REPO/" "bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/restic-repo"

# copy restic repo to google drive
rsync -avhW --no-compress --delete --progress "$REPO/" "$GOOGLE_DRIVE_ROOT_PATH/_Backup/restic-repo"
sleep 5
rsync -avhW --no-compress --delete --progress "$REPO/" "$GOOGLE_DRIVE_ROOT_PATH/_Backup/restic-repo"
