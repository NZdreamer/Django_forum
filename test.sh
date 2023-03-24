#!/bin/sh

MY_PROJECT_DIR="mymisago"
MY_PROJECT_ENV_DIR="mymisagoenv"
DJANGO_PROJECT_DIR="myproject"
USER_NAME="lucifer"
SERVER_DOMAIN="nzdreamer.com www.nzdreamer.com"

sudo cp /etc/systemd/system/gunicorn.socket /etc/systemd/system/gunicorn.socket.bak
 
SOCKET_CONTENT="[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target"

sudo bash -c "echo '$SOCKET_CONTENT' > /etc/systemd/system/gunicorn.socket"
