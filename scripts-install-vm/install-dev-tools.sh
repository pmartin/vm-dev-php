#!/bin/bash

sudo apt-get -y install autoconf build-essential manpages-dev 
sudo apt-get -y install apache2-prefork-dev 

# Pour compilation de PHP et/ou d'extensions
sudo apt-get -y install libxml2-dev libcurl4-gnutls-dev libicu-dev libmcrypt-dev libpng12-dev libxslt1-dev libmysqlclient15-dev libbz2-dev libmhash-dev libltdl-dev libgearman-dev libevent-dev libmagickwand-dev

sudo apt-get clean
