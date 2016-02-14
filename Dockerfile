FROM ubuntu:trusty
MAINTAINER Igor Ferreira <igorferreirabr@gmail.com>

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -y install supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt vim && \
  echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
#ADD start-phalcon.sh /start-phalcon.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
#ADD supervisord-phalcon.conf /etc/supervisor/conf.d/supervisord-phalcon.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# install phalcon dependences
RUN apt-get -y install git php5-dev libpcre3-dev gcc make php5-mysql

# install phalcon
RUN git clone --depth=1 git://github.com/phalcon/cphalcon.git && cd cphalcon/build && sudo ./install
#RUN sudo service php5-fpm restart
ADD 30-phalcon.ini /etc/php5/apache2/conf.d/30-phalcon.ini
ADD 30-phalcon.ini /etc/php5/cli/conf.d/30-phalcon.ini

# Configure /app folder with sample app
#RUN git clone https://github.com/fermayo/hello-world-lamp.git /app
#RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/app
#RUN chmod 755 /var/www/

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

# Add volumes for MySQL
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

#ADD plataforma.sql /plataforma.sql
#ADD mysql-setup.sh /mysql-setup.sh
#RUN chmod 755 /*.sh

RUN php -m | grep phalcon

EXPOSE 80 3306
CMD ["/run.sh"]
