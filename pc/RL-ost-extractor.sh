#!/bin/bash

# this script extracts and prints the songnames from *.bnk files for rocket league

RL_DIR="/mnt/e/SteamLibrary/steamapps/common/rocketleague/"


# extract string version of all files in /tmp/rltmp/strings/<file>
rm -rf /tmp/rltmp
mkdir -p /tmp/rltmp/strings
find $RL_DIR -name "MX_*.bnk" -execdir bash -c 'cat {} | strings > /tmp/rltmp/strings/{}' \;

# trim nonsense stings from all files
# all songs are form Aa_Bb(_Cc), so trim out rest
find /tmp/rltmp/strings -type f -execdir sed -Ei '/^[A-Z0-9][A-Za-z0-9]+_[A-Z0-9][_A-Za-z0-9]+$/!d' {} \;
# trim out 5 char matches in the form "Aa_Bb"
find /tmp/rltmp/strings -type f -execdir sed -Ei '/^[A-Za-z0-9]{2}_[A-Za-z0-9]{2,3}$/d' {} \;

# output text of filenames with data
find /tmp/rltmp/strings -type f -execdir bash -c 'echo === {} === ; cat {}' \;
