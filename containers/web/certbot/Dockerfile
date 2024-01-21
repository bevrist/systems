FROM certbot/dns-cloudflare

COPY ./credentials /root/credentials

# output message if credentials.ini missing, otherwise run certbot command
RUN printf "#!/bin/bash \n\
    if [ ! -d /etc/letsencrypt/live ]; then \n\
        echo \n\
        echo \n\
        echo '============================================================' \n\
        if [ ! -f /root/credentials/credentials.ini ]; then \n\
            echo 'credentials.ini Missing! certbot cannot generate certs!!!' \n\
            echo '============================================================' \n\
            echo \n\
            exit 1 \n\
        fi \n\
        echo 'certbot is generating new certs for brettevrist.net(+others)...' \n\
        echo '============================================================' \n\
        echo \n\
        sleep 15 \n\
    certbot certonly --dns-cloudflare --dns-cloudflare-propagation-seconds 30 --dns-cloudflare-credentials /root/credentials/credentials.ini --email brettevrist10@gmail.com --agree-tos --no-eff-email \
        -d brettevrist.net -d evri.st -d *.brettevrist.net \n\
        echo \n\
        exit \n\
    fi \n\
    \n\
    # list certificates \n\
    certbot certificates \n\
    echo \n\
    echo \n\
    # renew certificates \n\
    certbot renew \n\
    " > /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh

RUN cat /docker-entrypoint.sh

ENTRYPOINT [""]
CMD ["/bin/sh", "/docker-entrypoint.sh"]


## Test https connection Locally
# curl -D - --resolve 'brettevrist.net:443:127.0.0.1' https://brettevrist.net:443/

## Build and Run Image
# docker build -t certbot . && docker run --rm -it -v /var/b-web/letsencrypt:/etc/letsencrypt certbot sh

# ---

##### Certbot Commands #####
## List Certificates
# certbot certificates

## Generate New Certificate with Listed Domains (run in certbot container)
# rm -rf /etc/letsencrypt/*
# certbot certonly --dns-cloudflare --dns-cloudflare-propagation-seconds 30 --dns-cloudflare-credentials /root/credentials/credentials.ini --email brettevrist10@gmail.com --agree-tos --no-eff-email \
# -d brettevrist.net -d www.brettevrist.net -d play.brettevrist.net -d svn.brettevrist.net -d git.brettevrist.net
