#!/bin/bash
source /etc/apache2/envvars
exec php5-fpm restart
