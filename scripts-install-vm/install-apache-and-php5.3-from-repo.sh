#/bin/bash

/home/user/scripts-install-vm/install-apache.sh

/home/user/scripts-install-vm/install-php5.3-from-repo.sh

aptitude -y install libapache2-mod-php5

/etc/init.d/apache2 restart

aptitude clean
