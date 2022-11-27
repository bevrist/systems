#!/bin/bash
COUNT=1
while true
do
    rsync -rvzh --dry-run --delete --info=progress2 --append-verify --timeout=60 -e 'ssh -p 2215' bevrist@b.evri.st:/mnt/6TB-5400RPM/media /mnt/f/Plex-Backup_DATE
    if [ "$?" = "0" ] ; then
        echo "rsync completed normally"
        exit
    else
        echo "count: $COUNT - Rsync failure. Backing off and retrying..."
        ((COUNT=COUNT+1))
        sleep 180
    fi
done
