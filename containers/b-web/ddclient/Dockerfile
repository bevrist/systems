FROM lscr.io/linuxserver/ddclient:latest

COPY ddclient.conf /config/ddclient.conf

RUN printf '#!/bin/bash  \n\
sed -i "s,<CF_TOKEN>,$CF_TOKEN,g" /config/ddclient.conf  \n\
sed -i "s,<CF_ZONE>,$CF_ZONE,g" /config/ddclient.conf  \n\
sed -i "s,<CF_DOMAIN>,$CF_DOMAIN,g" /config/ddclient.conf  \n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

CMD ['/entrypoint.sh']
