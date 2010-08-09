#!/bin/bash

aptitude -y install apache2-mpm-prefork apache2

aptitude clean

mkdir -p /home/user/www


a2enmod expires
a2enmod headers
a2enmod proxy
a2enmod proxy_http
a2enmod rewrite
a2enmod userdir

cat > /etc/apache2/sites-available/001-default-user <<EOF
<VirtualHost *:80>
        DocumentRoot /home/user/www
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory /home/user/www/>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>
        ErrorLog /var/log/apache2/error.log
        LogLevel warn
        CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF

a2dissite default
a2ensite 001-default-user


/etc/init.d/apache2 restart



cat > /home/user/www/phpinfo.php <<EOF
<?php phpinfo(); ?>
EOF





chown -R user.user /home/user/www


