FROM ubuntu

RUN apt-get update && apt-get install -y \
		sssd-tools \
		nginx \
		libnginx-mod-http-auth-pam

RUN usermod -aG shadow www-data
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

COPY assets/nsswitch.conf /etc/nsswitch.conf
COPY assets/default /etc/nginx/sites-available/default
COPY assets/nginx_exec /etc/pam.d/nginx_exec
COPY assets/check_group.sh /check_group.sh
COPY assets/entrypoint.sh /entrypoint.sh

RUN chmod +x /check_group.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]