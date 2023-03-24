#!/bin/bash

MY_PROJECT_DIR="mymisago"
MY_PROJECT_ENV_DIR="mymisagoenv"
DJANGO_PROJECT_NAME="myproject"
NGINX_SITE_NAME="my_misago"
USER_NAME="lucifer"
SERVER_DOMAINS=("nzdreamer.com" "www.nzdreamer.com")



# cp -r $DJANGO_PROJECT_NAME/ .
for SERVER_DOMAIN in ${SERVER_DOMAINS[@]}
do
    if sudo certbot certificates --domain $SERVER_DOMAIN | grep -q 'Certificate Path'; then
  echo "Certificate already exists for domain $SERVER_DOMAIN"
else
  echo "no certificates"
fi
done