docker-docker-phalcon-lamp
=================

Out-of-the-box LAMP image (PHP+MySQL) with phalcon framework 2.0.10


Usage
-----

To create the image `igorferreira/docker-phalcon-lamp`, execute the following command on the docker-docker-phalcon-lamp folder:

	docker build -t igorferreira/docker-phalcon-lamp .

You can now push your new image to the registry:

	docker push igorferreira/docker-phalcon-lamp

Suggested docker run:

	docker run --name app-backend -v /home/[user]/app-backend:/var/www -v /home/[user]/app-backend-mysql-data:/var/lib/mysql -p 80:80 -p 3306:3306 -e MYSQL_PASS=admin -e MYSQL_ROOT_PASSWORD=admin igorferreira/docker-phalcon-lamp:1.0


Running your LAMP docker image
------------------------------

Start your image binding the external ports 80 and 3306 in all interfaces to your container:

	docker run -d -p 80:80 -p 3306:3306 igorferreira/docker-phalcon-lamp

Test your deployment:

	curl http://localhost/

Hello world!


Config external mysql data
-----------------------------------

Execute docker conteiner with volume configuration:

	 conteiner mysql-data folder: /var/lib/mysql
	 -v [work dir]/mysql-data:/var/lib/mysql

And test it

	docker run --name app-backend -v [work dir]/[root path phalcon app]:/var/www -v [work dir]/mysql-data:/var/lib/mysql -p 80:80 -p 3306:3306 -e MYSQL_PASS=[mysql admin user password] -e MYSQL_ROOT_PASSWORD=[mysql root user password] igorferreira/docker-phalcon-lamp:1.0

Test your deployment:

	curl http://localhost/

That's it!


Connecting to the bundled MySQL server from within the container
----------------------------------------------------------------

The bundled MySQL server has a `root` user with no password for local connections.
Simply connect from your PHP code with this user:

	<?php
	$mysql = new mysqli("localhost", "root");
	echo "MySQL Server info: ".$mysql->host_info;
	?>


Connecting to the bundled MySQL server from outside the container
-----------------------------------------------------------------

The first time that you run your container, a new user `admin` with all privileges
will be created in MySQL with a random password. To get the password, check the logs
of the container by running:

	docker logs $CONTAINER_ID

You will see an output like the following:

	========================================================================
	You can now connect to this MySQL Server using:

	    mysql -uadmin -p47nnf4FweaKu -h<host> -P<port>

	Please remember to change the above password as soon as possible!
	MySQL user 'root' has no password but only allows local connections
	========================================================================

In this case, `47nnf4FweaKu` is the password allocated to the `admin` user.

You can then connect to MySQL:

	 mysql -uadmin -p47nnf4FweaKu

Remember that the `root` user does not allow connections from outside the container -
you should use this `admin` user instead!


Setting a specific password for the MySQL server admin account
--------------------------------------------------------------

If you want to use a preset password instead of a random generated one, you can
set the environment variable `MYSQL_PASS` to your specific password when running the container:

	docker run -d -p 80:80 -p 3306:3306 -e MYSQL_PASS="mypass" igorferreira/docker-phalcon-lamp

You can now test your new admin password:

	mysql -uadmin -p"mypass"


Disabling .htaccess
--------------------

`.htaccess` is enabled by default. To disable `.htaccess`, you can remove the following contents from `Dockerfile`

	# config to enable .htaccess
    ADD apache_default /etc/apache2/sites-available/000-default.conf
    RUN a2enmod rewrite
