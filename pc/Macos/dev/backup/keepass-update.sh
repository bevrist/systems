#!/bin/bash
set -e

NOW=$(date +"%Y-%m-%d")

# Copy locally
GOOGLE_DRIVE_ROOT_PATH="/Users/bevrist/My Drive"
mkdir -p ~/.backup/
cp "$GOOGLE_DRIVE_ROOT_PATH/Personal Files/BrettsPassDatabase.kdbx" ~/.backup/backup/BrettsPassDatabase.kdbx

ssh -p 2222 bevrist@play.brettevrist.net "mv /www/brettevrist.net/share/keePass/*.kdbx /www/brettevrist.net/share/keePass/_OLD/ || true"
scp -P 2222 ~/.backup/backup/BrettsPassDatabase.kdbx bevrist@play.brettevrist.net:/www/brettevrist.net/share/keePass/BrettsPassDatabase_"$NOW".kdbx
ssh -p 2222 bevrist@play.brettevrist.net "chmod 775 /www/brettevrist.net/share/keePass/*.kdbx"
