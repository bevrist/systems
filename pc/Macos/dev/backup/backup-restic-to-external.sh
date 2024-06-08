#!/bin/bash

set -e

REPO="/Users/bevrist/.backup/restic-repo"
BACKUP_LAST_RUN_FILE="/tmp/cron-backup_last-backup"

# restic backup immediately
rm -f "$BACKUP_LAST_RUN_FILE" || :;
~/dev/backup/cron-backup.sh

# copy restic repo to B-Server
rsync -rvzh --delete --info=progress2 --append-verify -e 'ssh -p 2215' "$REPO/" "bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/restic-repo"
