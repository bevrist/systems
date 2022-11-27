FROM ubuntu:20.04

# install nginx
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install nginx -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# remove default site
RUN rm /etc/nginx/sites-enabled/default
RUN rm -rf /var/www/html

# copy configs
COPY ./sites-enabled /etc/nginx/sites-enabled

# link logs to docker output
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80 443

## Test https connection Locally
# curl -D - --resolve 'brettevrist.net:443:127.0.0.1' https://brettevrist.net:443/
