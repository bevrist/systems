FROM alpine:3
RUN apk add samba tini

RUN mkdir -p /usr/local/samba/var/cores
RUN chmod 700 /usr/local/samba/var/cores

RUN adduser -D user
# RUN echo "user:pass" | chpasswd
RUN echo -e "password1\npassword1" | smbpasswd -a user

COPY --chown=root:root smb.conf /etc/samba/smb.conf
RUN mkdir /share && chmod -R 777 /share && echo "works!" > /share/test.txt

ENTRYPOINT ["/sbin/tini", "--", "smbd", "--foreground", "--debug-stdout", "--no-process-group"]

EXPOSE 137/udp
EXPOSE 138/udp
EXPOSE 139 445
