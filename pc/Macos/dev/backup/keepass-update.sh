#!/bin/bash
set -e

BACKUP_DIR="${HOME}/.backup/backup/"
NOW=$(date +"%Y-%m-%d")

# pull primary from SFTP server
mkdir -p "${BACKUP_DIR}"
scp -P 2215 bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/keepass/BrettsPassDatabase.kdbx "${BACKUP_DIR}BrettsPassDatabase_$NOW.kdbx"

# sync to web server
scp -P 2222 "${BACKUP_DIR}BrettsPassDatabase_$NOW.kdbx" bevrist@play.brettevrist.net:/www/brettevrist.net/share/keePass/BrettsPassDatabase.kdbx
# move old backups to "_OLD" directory, append current date to file added on webserver
ssh -p 2222 bevrist@play.brettevrist.net "mv /www/brettevrist.net/share/keePass/BrettsPassDatabase_*.kdbx /www/brettevrist.net/share/keePass/_OLD/ \
  ; mv /www/brettevrist.net/share/keePass/BrettsPassDatabase.kdbx /www/brettevrist.net/share/keePass/BrettsPassDatabase_$NOW.kdbx \
  && chmod 775 /www/brettevrist.net/share/keePass/*.kdbx"

# clean up old local copies of database
find "${BACKUP_DIR}" -name "BrettsPassDatabase_*.kdbx" | sort | ghead -n -3 | xargs rm -f
