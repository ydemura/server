#install OS:
FROM debian:buster

# Update software packages in debian
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget

# create directory
WORKDIR /var/www/html/

#Install Nginx Web server
RUN apt-get -y install nginx

#Install MySQL
RUN apt-get -y install mariadb-server

# Install PhpMyAdmin
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

# Permissions
RUN chown -R www-data:www-data /var/www/*; 
RUN chmod -R 755 /var/www/*

# Nginx soft link on localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/;

# PhpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.4-english.tar.gz && rm -rf phpMyAdmin-5.0.4-english.tar.gz
RUN mv phpMyAdmin-5.0.4-english phpmyadmin

# WordPress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz

# SSL sertificate
RUN apt-get -y install libnss3-tools
RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
RUN chmod 777 ./mkcert-v1.4.3-linux-amd64
RUN ./mkcert-v1.4.3-linux-amd64 localhost
RUN mv ./localhost.pem /etc/nginx
RUN mv ./localhost-key.pem /etc/nginx
RUN rm -rf /mkcert-v1.4.3-linux-amd64

# wp-cli
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod 777 wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./srcs/config.inc.php phpmyadmin
COPY ./srcs/wp-config.php /var/www/html

COPY ./srcs/nginx.autoindex.conf /etc/nginx/sites-available/localhost

# Switcher
COPY ./srcs/nginx.autoindex.conf /var/local/nginx.autoindex.conf
COPY ./srcs/nginx.no_autoindex.conf /var/local/nginx.no_autoindex.conf
COPY ./srcs/autoindex_switcher.sh /var/local/autoindex_switcher.sh

COPY ./srcs/run_servises.sh /var/local/run_servises.sh

CMD bash /var/local/run_servises.sh

EXPOSE 80 443
