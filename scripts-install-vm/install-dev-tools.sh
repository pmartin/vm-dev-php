#!/bin/bash

aptitude -y install autoconf build-essential manpages-dev debian-keyring 
aptitude -y install apache2-prefork-dev 

# Pour compilation de PHP et/ou d'extensions
aptitude -y install libxml2-dev libcurl4-gnutls-dev libicu-dev libmcrypt-dev libpng12-dev libxslt1-dev libmysqlclient15-dev libbz2-dev libmhash-dev libltdl-dev libgearman-dev libevent-dev libmagickwand-dev

aptitude clean
