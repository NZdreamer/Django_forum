#!/bin/sh

MY_PROJECT_DIR="mymisago"
MY_PROJECT_ENV_DIR="mymisagoenv"
DJANGO_PROJECT_DIR="myproject"
USER_NAME="lucifer"
SERVER_DOMAIN="nzdreamer.com www.nzdreamer.com"

sudo cp /etc/systemd/system/gunicorn.service /etc/systemd/system/gunicorn.service.bak
SERVICE_CONTENT="[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=$USER_NAME
Group=www-data
WorkingDirectory=/home/$USER_NAME/$MY_PROJECT_DIR
ExecStart=/home/$USER_NAME/$MY_PROJECT_DIR/$MY_PROJECT_ENV_DIR/bin/gunicorn \\ 
          --access-logfile - \\
          --workers 3 \\
          --bind unix:/run/gunicorn.sock \\
          $DJANGO_PROJECT_DIR.wsgi:application 

[Install]
WantedBy=multi-user.target" 

sudo bash -c "echo '$SERVICE_CONTENT' > /etc/systemd/system/gunicorn.service"
sudo systemctl daemon-reload

cat /etc/systemd/system/gunicorn.service

# [Unit]
# Description=gunicorn daemon
# Requires=gunicorn.socket
# After=network.target

# [Service]
# User=lucifer
# Group=www-data
# WorkingDirectory=/home/lucifer/mymisago
# ExecStart=/home/lucifer/mymisago/mymisagoenv/bin/gunicorn \
#           --access-logfile - \
#           --workers 3 \
#           --bind unix:/run/gunicorn.sock \
#           myproject.wsgi:application

# [Install]
# WantedBy=multi-user.target