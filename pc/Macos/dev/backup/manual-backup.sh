#!/bin/bash
NOW=$(date +"%Y-%m-%d")

# Create backup folders
mkdir -p ~/backup/_backup/bookmarks_${NOW}
mkdir -p ~/backup/_backup/keepass_${NOW}
mkdir -p ~/backup/_backup/hledger_${NOW}
mkdir -p ~/backup/_backup/GoogleTakeout_${NOW}
mkdir -p ~/backup/GoogleDrive_${NOW}

echo "Mac Backup:
> ~/backup/_backup/bookmarks_${NOW}       chrome bookmarks
> ~/backup/_backup/keepass_${NOW}         export chrome passwords to keepass (disable search for chrome group)
> ~/backup/_backup/hledger_${NOW}         hledger and repo
> ~/backup/_backup/ticktick_${NOW}        https://ticktick.com/webapp/#settings/backup 'Generate Backup'
> ~/backup/_backup/GoogleTakeout_${NOW}   Google Takeout: Calendar, Chrome, Contacts, Play Books, Mail, Maps
>> also run this: 'cd ~/backup/_backup/GoogleTakeout_${NOW} ; tree -L 2 > ~/backup/_backup/GoogleTakeout_${NOW}-tree.txt'

PC Backup:
> ~/backup/GoogleDrive_${NOW}             Google Takeout: Drive
>> also run this: 'cd ~/backup/GoogleDrive_${NOW} ; tree -L 2 > ~/backup/GoogleDrive_${NOW}-tree.txt'
# FIXME add code to delete recursive '_backup' folder in gdrive takeout
"
# FIXME: Finish PC Backup Instructions

# TODO: add if statement to actually do backup instead of exiting after printing help
exit 0  # FIXME

# TODO: Restic backup the ~/backup directory
# TODO: password 7z all directories in ~/backup/_backup/ directory
# TODO: copy ~/backup/_backup/ files to google drive _backup

REPO="/Users/bevrist/.backup/restic-repo"
BACKUP_LOCKFILE="/tmp/last-backup"

# create backup timestamp file (backdated really old) if it doesnt exist
if [ ! -f $BACKUP_LOCKFILE ]; then touch -t 201001010000 $BACKUP_LOCKFILE; echo creating $BACKUP_LOCKFILE; fi

# if script ran in last 59 minutes (3540s), dont run again.
if [ "$(( $(date +%s) - $(date -r "$BACKUP_LOCKFILE" "+%s") ))" -lt 3540 ]; then
  echo ">>exiting because last backup was less than 59 minutes (3540s) ago. [$(( $(date +%s) - $(stat -f%m $BACKUP_LOCKFILE) ))s]"
  exit 0
fi

##################################################

# TODO: use apple keychain to store a proper password: https://scriptingosx.com/2021/04/get-password-from-keychain-in-shell-scripts/
export RESTIC_PASSWORD="password"

# error if restic repo doesnt exist
if [ ! -d $REPO ]; then
  echo "ERROR: Restic repo does not exist!"
  exit 1
fi

##### BACKUPS #####
### PRE BACKUP ###
# list vscode extensions
code --list-extensions > /tmp/vscode-extensions.txt

### RESTIC BACKUP ###
# Obsidian Personal Vault
# Obsidian Shared Vault
# Vscode Settings
# Vscode Extensions
# Hledger Files
restic -r $REPO backup --exclude .git \
  /Users/bevrist/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/B-Obsidian-Vault \
  /Users/bevrist/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Shared-Vault \
  /Users/bevrist/Library/Application\ Support/Code/User/settings.json \
  /tmp/vscode-extensions.txt \
  /Users/bevrist/.hledger*.journal

# TODO: add more items to manually backup in the `~/.backup/backup/ folder`

# restic cleanup
restic -r $REPO forget --prune --group-by '' --keep-hourly 2 --keep-daily 10 --keep-weekly 8 --keep-monthly 24

# update last backup timestamp
echo -e ">>Backed Up: $(date "+%Y-%m-%d_%H:%M")\n" | tee $BACKUP_LOCKFILE
