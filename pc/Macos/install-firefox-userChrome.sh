#!/bin/bash
cd $(dirname "$0")

profile_dir=$(cat ~/Library/Application\ Support/Firefox/profiles.ini | grep -A5 Profile0 | grep Path | awk -F '=' '{print $2}')

mkdir -p ~/Library/Application\ Support/Firefox/$profile_dir/Chrome/

cp firefox-userChrome.css ~/Library/Application\ Support/Firefox/$profile_dir/Chrome/userChrome.css
# find ~/Library/Application\ Support/Firefox/Profiles -type d -depth 1 -exec bash -c 'mkdir -p "{}/Chrome/" && cp firefox-userChrome.css "{}/Chrome/userChrome.css"' \;

