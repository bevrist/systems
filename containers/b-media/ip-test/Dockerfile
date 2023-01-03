FROM debian:11

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install curl -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/

RUN printf "#!/bin/bash \n\
curl -s http://v4.ipv6-test.com/api/myip.php >> /app/ip.txt \n\
echo '' >> /app/ip.txt \n\
sleep 30 \n\
" > /entrypoint.sh && chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
