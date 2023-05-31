# #!/bin/bash
# NOW=$(date +"%Y-%m-%d")
exit 1

# update `_Backup` files in Google Drive
# - all backup files shoud be updated
# - Emulator Game Saves
# - generate ticktick.com backup https://ticktick.com/webapp/#settings/backup

# copy updated `_backup` folder to OneDrive

# Google Takeout: Calendar, Contacts, Drive, Mail, Maps
# - Remove unneeded stuff from drive takeout

# backup big folders:
# - `Games Archive`
# - `Google Takeout`
# - `Google Drive _Backup Folder (update files within)`
# - `Github Backup`


###################### B-PC Backup script ############################
## expects the following directory layout:
$ tree -L 2
# .
# ├── _Backup_2023-1-13
# │   ├── BrettsPassDatabase_1-13-2023.kdbx
# │   ├── Evan_Baby_Tracker_export.zip
# │   ├── Extra Steam Keys 1-13-2023.xlsx
# │   ├── GAMES ARCHIVE ON SERVER AND HARD DRIVE
# │   ├── Game Saves
# │   ├── github-backup-2023_01_13.7z
# │   ├── plox
# │   ├── restic-repo_1-13-2023.7z
# │   └── TickTick-backup-2023-01-13.csv
# ├── Games Archive
# │   ├── Gamecube
# │   ├── Old Console Games
# │   ├── PC Game Mods
# │   ├── Switch
# │   ├── VR
# │   ├── Wii
# │   └── Wii U
# └── Takeout_2023-1-13
#     ├── archive_browser.html
#     ├── Calendar
#     ├── Contacts
#     ├── Drive
#     ├── Google Play Books
#     └── Mail

## use find to create list of directories to export (edit output)
$ find /mnt/g -type d -maxdepth 2
# /mnt/g/Games Archive  # <- (IGNORE THIS)
# /mnt/g/Takeout_2023-1-13
# /mnt/g/Takeout_2023-1-13/Calendar
# /mnt/g/Takeout_2023-1-13/Contacts
# /mnt/g/Takeout_2023-1-13/Drive
# /mnt/g/Takeout_2023-1-13/Google Play Books
# /mnt/g/Takeout_2023-1-13/Mail
# /mnt/g/_Backup_2023-1-13
# /mnt/g/_Backup_2023-1-13/Game Saves
# /mnt/g/_Backup_2023-1-13/GAMES ARCHIVE ON SERVER AND HARD DRIVE  # <- (REMOVE THIS EMPTY DIR)
# /mnt/g/_Backup_2023-1-13/plox

## Backup with restic (DO NOT BACKUP GAMES_ARCHIVE)
$ export RESTIC_PASSWORD=<PASSWORD_IN_PASSWORD_MANAGER>
$ restic -r "/mnt/g/pc-restic-repo" --host "b-pc" backup --exclude .git  \
    /mnt/g/Takeout_2023-1-13  \
    /mnt/g/Takeout_2023-1-13/Calendar  \
    /mnt/g/Takeout_2023-1-13/Contacts  \
    /mnt/g/Takeout_2023-1-13/Drive  \
    /mnt/g/Takeout_2023-1-13/Google\ Play\ Books  \
    /mnt/g/Takeout_2023-1-13/Mail  \
    /mnt/g/_Backup_2023-1-13  \
    /mnt/g/_Backup_2023-1-13/Game\ Saves  \
    /mnt/g/_Backup_2023-1-13/plox


## if multiple backups were necessary, trim extra backups with this
$ restic -r "/mnt/g/pc-restic-repo" forget --prune --compression max  \
  --keep-weekly  1


## Sync restic repo to server
# verify what is being deleted
$ rsync -rvzh --dry-run --delete --info=progress2 --append-verify --timeout=60 -e 'ssh -p 2215' "/mnt/g/pc-restic-repo" "bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/" | grep "deleting"
# perform backup with retries
$ export RSYNC_RESTIC_COUNT=1
$ while [[ "$RSYNC_RESTIC_DONE" != "true" ]]; do
  rsync -rvzh --delete --info=progress2 --append-verify --timeout=60 -e 'ssh -p 2215' "/mnt/g/pc-restic-repo" "bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/"
  if [ "$?" = "0" ] ; then
    echo "rsync completed normally"
    RSYNC_RESTIC_DONE="true"
  else
    echo "count: $RSYNC_RESTIC_COUNT - Rsync failure. Backing off and retrying..."
    ((RSYNC_RESTIC_COUNT=RSYNC_RESTIC_COUNT+1))
    sleep 180
  fi
done; unset RSYNC_RESTIC_DONE


## Backup 'Games Archive' to server
# verify what is being deleted
$ rsync -rvzh --dry-run --delete --info=progress2 --append-verify --timeout=60 -e 'ssh -p 2215' "/mnt/g/Games Archive" "bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/" | grep "deleting"
# perform backup with retries
$ export RSYNC_GAME_ARCHIVE_COUNT=1
$ while [[ "$RSYNC_GAME_ARCHIVE_DONE" != "true" ]]; do
  rsync -rvzh --delete --info=progress2 --append-verify --timeout=60 -e 'ssh -p 2215' "/mnt/g/Games Archive" "bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/"
  if [ "$?" = "0" ] ; then
    echo "rsync completed normally"
    RSYNC_GAME_ARCHIVE_DONE="true"
  else
    echo "count: $RSYNC_GAME_ARCHIVE_COUNT - Rsync failure. Backing off and retrying..."
    ((RSYNC_GAME_ARCHIVE_COUNT=RSYNC_GAME_ARCHIVE_COUNT+1))
    sleep 180
  fi
done; unset RSYNC_GAME_ARCHIVE_DONE


## Verify Sync Succeeded
# > if restic repo mounted on SMB share: `export GODEBUG=asyncpreemptoff=1`
# > if restic repo mounted on SMB share: use `--no-lock` in restic command
# run `restic check -r "/mtn/PATH/TO/pc-restic-repo"`
# run rsync with -c to verify all non-restic files transferred correctly
