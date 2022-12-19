
service nginx start
service mysql start 
service php7.3-fpm start

# Configure a wordpress database

echo "create user 'yuliia'@'localhost' identified by ''" | mysql -u root 
echo "create database wordpress;"| mysql -u root --skip-password
echo "grant all privileges on wordpress.* to 'yuliia'@'localhost' WITH GRANT OPTION;"| mysql -u root --skip-password
echo "flush privileges;"| mysql -u root --skip-password 
echo "update mysql.user set plugin='' where user='yuliia';"| mysql -u root --skip-password

wp core install --allow-root --path=/var/www/html/wordpress --url="https://localhost/wordpress" --title="YdemurA" --admin_name=admin --admin_password=admin --admin_email=demjula@gmail.com

bash

