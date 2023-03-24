#!/bin/bash


# sudo ufw allow 'Nginx Full'

# sudo apt update
# sudo apt install python3-venv python3-dev libpq-dev postgresql postgresql-contrib nginx curl

# pip install django gunicorn psycopg2-binary

. mymisagoenv/bin/activate

python manage.py collectstatic
python manage.py makemigrations
python manage.py migrate

deactivate

# Restart Gunicorn, after updating your Django application
sudo systemctl restart gunicorn

# reload the daemon and restart the process, if you change Gunicorn socket or service files
# sudo systemctl daemon-reload
# sudo systemctl restart gunicorn.socket gunicorn.service

# restart nginx, If you change the Nginx server block configuration
# sudo nginx -t && sudo systemctl restart nginx
sudo service nginx restart


# Further Troubleshooting:
# Check the Nginx process logs by typing: sudo journalctl -u nginx
# Check the Nginx access logs by typing: sudo less /var/log/nginx/access.log
# Check the Nginx error logs by typing: sudo less /var/log/nginx/error.log
# Check the Gunicorn application logs by typing: sudo journalctl -u gunicorn
# Check the Gunicorn socket logs by typing: sudo journalctl -u gunicorn.socket