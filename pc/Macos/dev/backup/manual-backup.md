# Manual Backup Checklist

use the following format for naming all backup files: `file-Name_$(date +"%Y-%m-%d")`

1) Open apple books and wait for data to sync, then export all books

2) update `_Backup` files in Google Drive: `MOVE ALL BACKUP ZIPS TO SERVER BACKUP/ DIRECTLY`
> - all backup files in google drive backup folder should be updated  

3) copy updated `_backup` folder to OneDrive

4) Google Takeout: Calendar, Contacts, Drive, Mail, Maps, Youtube
> - Remove unneeded stuff from drive takeout

5) copy big folders to server and backup drives:
> - Games Archive
> - Google Takeout
> - Google Drive _Backup Folder
> - Books
> - Playnite Library (Windows)

## Sync data to server:
```bash
# verify what is being deleted
rsync -rvzh --dry-run --delete --info=progress2 --append-verify --timeout=60 -e 'ssh -p 2215' "/mnt/g/BACKUP/" "bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/" | grep "deleting"
```
```bash
# perform backup with retries
export RSYNC_RESTIC_COUNT=1
while [[ "$RSYNC_RESTIC_DONE" != "true" ]]; do
  rsync -rvzh --delete --info=progress2 --append-verify --timeout=60 -e 'ssh -p 2215' "/mnt/g/BACKUP/" "bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/"
  if [ "$?" = "0" ] ; then
    echo "rsync completed normally"
    RSYNC_RESTIC_DONE="true"
  else
    echo "count: $RSYNC_RESTIC_COUNT - Rsync failure. Backing off and retrying..."
    ((RSYNC_RESTIC_COUNT=RSYNC_RESTIC_COUNT+1))
    sleep 60
  fi
done; unset RSYNC_RESTIC_DONE
```
