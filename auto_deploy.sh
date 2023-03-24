#!/bin/bash

# variables
MY_PROJECT_DIR="mymisago"
MY_PROJECT_ENV_DIR="mymisagoenv"
DJANGO_PROJECT_DIR="myproject"
NGINX_SITE_NAME="my_misago"
USER_NAME="lucifer"
SERVER_DOMAINS=("nzdreamer.com" "www.nzdreamer.com")


mkdir ~/$MY_PROJECT_DIR
cd ~/$MY_PROJECT_DIR

# copy the whole project
cp -r $DJANGO_PROJECT_DIR/ .

# virtual env
python3 -m venv $MY_PROJECT_ENV_DIR
source $MY_PROJECT_ENV_DIR/bin/activate
pip install django gunicorn psycopg2-binary


# database ??
~/$MY_PROJECT_DIR/manage.py makemigrations
~/$MY_PROJECT_DIR/manage.py migrate
~/$MY_PROJECT_DIR/manage.py createsuperuser
~/$MY_PROJECT_DIR/manage.py collectstatic

deactivate

# guinicorn

# gunicorn.socket
sudo cp /etc/systemd/system/gunicorn.socket /etc/systemd/system/gunicorn.socket.bak

SOCKET_CONTENT="[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target"

sudo bash -c "echo '$SOCKET_CONTENT' > /etc/systemd/system/gunicorn.socket"

# gunicorn.service
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

sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket

# nginx
sudo cp /etc/nginx/sites-available/${NGINX_SITE_NAME} /etc/nginx/sites-available/${NGINX_SITE_NAME}.bak

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

sudo bash -c "echo '$NGINX_CONTENT' > /etc/nginx/sites-available/$NGINX_SITE_NAME"


sudo ln -s /etc/nginx/sites-available/$NGINX_SITE_NAME /etc/nginx/sites-enabled
sudo systemctl restart nginx
sudo ufw delete allow 8000
sudo ufw allow 'Nginx Full'

# Secure Nginx with Let's Encrypt
sudo snap install core; sudo snap refresh core
sudo apt remove certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
# Obtaining an SSL Certificate
sudo certbot --nginx -d ${SERVER_DOMAINS[0]} -d ${SERVER_DOMAINS[1]}

