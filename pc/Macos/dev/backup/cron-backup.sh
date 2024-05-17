#!/bin/bash
# crontab -e
#   */10 * * * * /Users/bevrist/dev/backup/cron-backup.sh >> /tmp/cron-backup.log 2>&1
# add "/usr/sbin/cron" to macos security "Full Disk Access" group
#   (⌘ + ⇧ + G) to type any path in finder when using "+" button

set -e

HOME="/Users/bevrist"

BACKUP_LAST_RUN_FILE="/tmp/cron-backup_last-backup"

RESTIC_REPO="$HOME/.backup/restic-repo"
export RESTIC_PASSWORD="password"

##################################################

echo ">>Started:  $(date)"

# create backup timestamp file (backdated really old) if it doesnt exist
if [ ! -f $BACKUP_LAST_RUN_FILE ]; then touch -t 201001010000 $BACKUP_LAST_RUN_FILE; echo creating $BACKUP_LAST_RUN_FILE; fi

# if script ran in last 59 minutes (3540s), dont run again.
if [ "$(( $(date +%s) - $(date -r $BACKUP_LAST_RUN_FILE +%s) ))" -lt 3540 ]; then
  echo ">>exiting because last backup was less than 59 minutes (3540s) ago. [$(( $(date +%s) - $(date -r $BACKUP_LAST_RUN_FILE +%s) ))s]"
  exit 0
fi

# error if restic repo doesnt exist
if [ ! -d "$RESTIC_REPO" ]; then
  echo "ERROR: Restic repo does not exist!"
  exit 1
fi

##### BACKUPS #####
### PRE BACKUP ###
# vscode extensions
mkdir -p "$HOME/.backup/backup"
code --list-extensions > "$HOME/.backup/backup/vscode-extensions.txt" 2> /dev/null

### RESTIC BACKUP ###
restic -r "$RESTIC_REPO" backup --exclude .git --compression max \
  $HOME/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/B-Obsidian-Vault/ `#Obsidian Personal Vault (dir)` \
  $HOME/Library/Application\ Support/Firefox/Profiles/*/places.sqlite `#Firefox History/bookmarks` \
  $HOME/Library/Application\ Support/Code/User/settings.json `#Vscode Settings` \
  $HOME/.backup/backup/vscode-extensions.txt `#Vscode Extensions`

  # $HOME/Library/Group\ Containers/group.com.apple.notes/ `#Apple Notes App` \
  # $HOME/Library/Application\ Support/Orion/Defaults/favourites.plist `#Orion Browser Bookmarks` \
  # $HOME/Library/Application\ Support/Orion/Defaults/browser_state.plist `#Orion Browser Tabs` \

# restic cleanup
restic -r $RESTIC_REPO forget --prune --compression max --group-by '' \
  --keep-hourly  5  \
  --keep-daily   10 \
  --keep-weekly  8  \
  --keep-monthly 12

# update last backup timestamp
echo -e ">>Backed Up: $(date "+%Y-%m-%d_%H:%M")\n" | tee $BACKUP_LAST_RUN_FILE
