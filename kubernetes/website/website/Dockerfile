# optimize javascript with closure compiler
FROM debian as closure
RUN apt-get update && apt-get install closure-compiler -y
COPY www/ /www
WORKDIR /www
# compile particles.js
RUN closure-compiler --js brettevrist.net/assets/js/particles.js --js_output_file brettevrist.net/assets/js/particles.min.js
RUN rm -f brettevrist.net/assets/js/particles.js
RUN mv brettevrist.net/assets/js/particles.min.js brettevrist.net/assets/js/particles.js
# compile wave/js/app.js
RUN closure-compiler --js brettevrist.net/wave/js/app.js --js_output_file brettevrist.net/wave/js/app.min.js --language_in ECMASCRIPT5
RUN rm -f brettevrist.net/wave/js/app.js
RUN mv brettevrist.net/wave/js/app.min.js brettevrist.net/wave/js/app.js


# pre-compress Files
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
RUN find . -type f -regex ".*\.\(css\|html\|js\|json\|svg\|xml\)$" -exec brotli --best {} \;


FROM caddy:2-alpine
# non-root user
RUN adduser -DH caddy
RUN find / -type d -name caddy -exec chown -R caddy:caddy {} \;
USER caddy
COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=optimizer /www/ /www
