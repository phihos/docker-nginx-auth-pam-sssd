FROM ubuntu

RUN apt-get update && apt-get install -y \
		sssd-tools \
		nginx \
		libnginx-mod-http-auth-pam

RUN usermod -aG shadow www-data

COPY assets/nsswitch.conf /etc/nsswitch.conf
COPY assets/default /etc/nginx/sites-available/default

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]