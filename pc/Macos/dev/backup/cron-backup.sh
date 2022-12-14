#!/bin/bash
# crontab -e
#   */10 * * * * /Users/bevrist/dev/backup/cron-backup.sh >> /tmp/cron-backup.txt
# add "/usr/sbin/cron" to macos security "Full Disk Access" group
#   (⌘ + ⇧ + G) to type any path in finder when using "+" button

set -e

HOME="/Users/bevrist"
PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

BACKUP_TMP="/tmp/cron_backup"
mkdir -p "$BACKUP_TMP"
BACKUP_LAST_RUN="$BACKUP_TMP/_last-backup"
BACKUP_DRIVE_FAIL_COUNT="$BACKUP_TMP/_gdrive-mount-fail-count"

RESTIC_REPO="$HOME/.backup/restic-repo"
RESTIC_HOSTNAME="Bretts-Air.lan"
export RESTIC_PASSWORD="password"

GOOGLE_DRIVE_ROOT_PATH="/Users/bevrist/Library/CloudStorage/GoogleDrive-brettevrist10@gmail.com/My Drive/"

##################################################

# create backup timestamp file (backdated really old) if it doesnt exist
if [ ! -f $BACKUP_LAST_RUN ]; then touch -t 201001010000 $BACKUP_LAST_RUN; echo creating $BACKUP_LAST_RUN; fi

# if script ran in last 59 minutes (3540s), dont run again.
if [ "$(( $(date +%s) - $(date -r $BACKUP_LAST_RUN +%s) ))" -lt 3540 ]; then
  echo ">>exiting because last backup was less than 59 minutes (3540s) ago. [$(( $(date +%s) - $(date -r $BACKUP_LAST_RUN +%s) ))s]"
  exit 0
fi

echo "Running:  $(date)"

# test that google drive is mounted, exit 1 if too many failures
if [ ! -d "$GOOGLE_DRIVE_ROOT_PATH" ]; then
  # create file to store fail count
  if [ ! -f "$BACKUP_DRIVE_FAIL_COUNT" ]; then
    echo 0 > "$BACKUP_DRIVE_FAIL_COUNT"
  fi
  FAIL_COUNT=$(<"$BACKUP_DRIVE_FAIL_COUNT")
  ((FAIL_COUNT+=1))
  echo $FAIL_COUNT > "$BACKUP_DRIVE_FAIL_COUNT"
  # fail if mount fails 3 timesin a row
  if [ "$FAIL_COUNT" -gt "3" ]; then
    echo "Repeatedly failed to mount Google Drive. fail count: $FAIL_COUNT"
    exit 1
  fi
  echo "google drive not mounted, exiting. fail count: $FAIL_COUNT"
  exit 0
fi
# reset fail count if mount succeeded
echo 0 > "$BACKUP_DRIVE_FAIL_COUNT"

##################################################

# error if restic repo doesnt exist
if [ ! -d "$RESTIC_REPO" ]; then
  echo "ERROR: Restic repo does not exist!"
  exit 1
fi

##### BACKUPS #####
### PRE BACKUP ###
# vscode extensions
mkdir -p "$HOME/.backup/backup"
code --list-extensions > "$HOME/.backup/backup/vscode-extensions.txt"

### RESTIC BACKUP ###
# Obsidian Personal Vault (dir)
# Obsidian Shared Vault (dir)
# Orion Browser Bookmarks
# Orion Browser Tabs
# Backup folder (dir)
## Vscode Settings
## Keepass Database
# Vscode Extensions
# Hledger Files (dir)
restic -r "$RESTIC_REPO" --host "$RESTIC_HOSTNAME" backup --exclude .git --compression max \
  $HOME/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/B-Obsidian-Vault/ \
  $HOME/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Shared-Vault/ \
  $HOME/Library/Application\ Support/Orion/Defaults/favourites.plist \
  $HOME/Library/Application\ Support/Orion/Defaults/browser_state.plist \
  $HOME/Library/Application\ Support/Code/User/settings.json \
  $HOME/.backup/backup/ \
  $HOME/.hledger

# restic cleanup
restic -r $RESTIC_REPO forget --prune --compression max \
  --keep-hourly  2  \
  --keep-daily   10 \
  --keep-weekly  8  \
  --keep-monthly 24

# update last backup timestamp
echo -e ">>Backed Up: $(date "+%Y-%m-%d_%H:%M")\n" | tee $BACKUP_LAST_RUN
