#!/bin/ash

echo 'Starting Open mailrush'

cd /var/www/mailrush

git pull 

echo ' [+] Starting php'
php-fpm7

chown -R nginx:nginx /var/www/

echo ' [+] Starting nginx'

mkdir -p /var/log/nginx/mailrush
touch /var/log/nginx/mailrush/web.access.log
touch /var/log/nginx/mailrush/web.error.log

nginx


echo ' [+] Setting up config.ini'

echo "[GENERAL]" > /var/www/mailrush/config.ini
if [ "$DOMAINS" != "" ]; then
	echo "DOMAINS=$DOMAINS" >> /var/www/mailrush/config.ini
  echo "   [i] Active Domain(s): $DOMAINS"
fi

if [ "$ADMIN" != "" ]; then
	echo "ADMIN=$ADMIN" >> /var/www/mailrush/config.ini
  echo "   [i] Set admin to: $ADMIN"
fi

echo "[MAILSERVER]" >> /var/www/mailrush/config.ini
echo "MAILPORT=25" >> /var/www/mailrush/config.ini

echo "[DATETIME]" >> /var/www/mailrush/config.ini
if [ "$DATEFORMAT" != "" ]; then
	echo "DATEFORMAT=$DATEFORMAT" >> /var/www/mailrush/config.ini
  echo "   [i] Setting up dateformat to: $DATEFORMAT"
else
  echo "DATEFORMAT='D.M.YYYY HH:mm'" >> /var/www/mailrush/config.ini
  echo "   [i] Using default dateformat"
fi


cd /var/www/mailrush/python

echo ' [+] Starting Mailserver'
python mailserver.py
#nohup python /var/www/mailrush/python/mailserver.py &

#tail -n 1 -f /var/log/nginx/*.log
