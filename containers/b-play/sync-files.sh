cd "$(dirname "$0")"
rsync -e "ssh -p 2206" -vr ./ bevrist@play.brettevrist.net:~/b-play/
# rsync -vr ./ bevrist@192.168.1.10:~/b-play/