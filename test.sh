#!/bin/bash

MY_PROJECT_DIR="mymisago"
MY_PROJECT_ENV_DIR="mymisagoenv"
DJANGO_PROJECT_DIR="myproject"
NGINX_SITE_NAME="my_misago"
USER_NAME="lucifer"
SERVER_DOMAINS=("nzdreamer.com" "www.nzdreamer.com")



echo ${SERVER_DOMAINS[@]}





NGINX_CONTENT="server {
    listen 80;
    server_name ${SERVER_DOMAINS[@]};

    location = /favicon.ico { access_log off; log_not_found off; }
    location /static/ {
        root /home/$USER_NAME/$MY_PROJECT_DIR;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}"

sudo bash -c "echo '$NGINX_CONTENT' > ./$NGINX_SITE_NAME"

cat ./$NGINX_SITE_NAME
