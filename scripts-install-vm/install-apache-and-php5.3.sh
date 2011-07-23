#/bin/bash

. `dirname $0`/zz-install-apache.sh

. `dirname $0`/zz-install-php5.3.sh

sudo apt-get -y install libapache2-mod-php5

sudo /etc/init.d/apache2 restart

sudo apt-get clean
