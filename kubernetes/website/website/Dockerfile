# website-image
# optimize javascript with closure compiler
FROM debian as closure
RUN apt-get update && apt-get install closure-compiler htmlmin -y
COPY www/ /www
WORKDIR /www
# compile js
RUN find . -name "*.js" ! -name "*.min.js" -exec closure-compiler --js {} --js_output_file {}.min --language_in ECMASCRIPT5 \;
RUN find . -name "*.js" ! -name "*.min.js" -exec rm -f {} \; -exec mv {}.min {} \;
# minify html
RUN find . -name "*.html" ! -name "*.min.html" -exec htmlmin -cs {} {}.min \;
RUN find . -name "*.html" ! -name "*.min.html" -exec rm -f {} \; -exec mv {}.min {} \;
# minify css
RUN find . -name "*.css" ! -name "*.min.css" -exec htmlmin -cs {} {}.min \;
RUN find . -name "*.css" ! -name "*.min.css" -exec rm -f {} \; -exec mv {}.min {} \;

# pre-compress files
FROM alpine as optimizer
RUN apk add brotli util-linux libwebp-tools
COPY --from=closure /www/ /www
WORKDIR /www
# optimize jpg images
RUN find . -type f -name "*.jpg" -exec cwebp {} -o {}.webp \;
RUN find . -type f -name "*.jpg" -exec rm -f {} \;
RUN find . -type f -name "*.jpg.webp" -exec rename .jpg.webp .webp {} \;
RUN grep -Rl ".jpg" . | xargs sed -i 's/\.jpg/.webp/g'
# optimize png images
RUN find . -type f -name "*.png" -exec cwebp {} -o {}.webp \;
RUN find . -type f -name "*.png" -exec rm -f {} \;
RUN find . -type f -name "*.png.webp" -exec rename .png.webp .webp {} \;
RUN grep -Rl ".png" . | xargs sed -i 's/\.png/.webp/g'
# optimize gif images
RUN find . -type f -name "*.gif" -exec gif2webp {} -o {}.webp \;
RUN find . -type f -name "*.gif" -exec rm -f {} \;
RUN find . -type f -name "*.gif.webp" -exec rename .gif.webp .webp {} \;
RUN grep -Rl ".gif" . | xargs sed -i 's/\.gif/.webp/g'
# compress everything with gzip compression
RUN find . -type f -exec gzip --best -k {} \;
# compress web files with brotli compression
RUN find . -type f -regex '.*\.\(css\|html\|js\|json\|svg\|xml\)$' -exec brotli --best {} \;


FROM caddy:2-alpine
# non-root user
RUN adduser -DH caddy
RUN chown -R caddy:caddy /usr/share/caddy
RUN chown -R caddy:caddy /config/caddy
RUN chown -R caddy:caddy /data/caddy
USER caddy
COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=optimizer /www/ /www
