
#!/bin/bash
if [ "$1" = "on" ]; then
    yes | cp -rf /var/local/nginx.autoindex.conf /etc/nginx/sites-available/localhost
	nginx -s reload
    echo "index_ON"
elif [ "$1" = "off" ]; then
    yes | cp -rf /var/local/nginx.no_autoindex.conf /etc/nginx/sites-available/localhost
	nginx -s reload
    echo "index_OFF"
fi
