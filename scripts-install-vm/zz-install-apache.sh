#!/bin/bash
. `dirname $0`/config.sh


export INSTALL_USERWWW="${INSTALL_USERHOME}/www"


# Installation d'Apache
sudo apt-get -y install apache2-mpm-prefork apache2
sudo apt-get clean

# Activation de modules fréquemment requis
sudo a2enmod expires
sudo a2enmod headers
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo a2enmod userdir


# La racine HTTP sera le répertoire 'www' de l'utilisateur
mkdir -p ${INSTALL_USERWWW}

# Le VirtualHost correspondant
sudo sh -c "cat > /etc/apache2/sites-available/001-default-${INSTALL_USERNAME}" <<EOF
<VirtualHost *:80>
        ServerName devhost
        DocumentRoot ${INSTALL_USERWWW}
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory ${INSTALL_USERWWW}>
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

# Désactivation du VirtualHost par défaut, et activation du notre
sudo a2dissite default
sudo a2ensite 001-default-${INSTALL_USERNAME}


sudo /etc/init.d/apache2 restart


cat > ${INSTALL_USERWWW}/phpinfo.php <<EOF
<?php phpinfo(); ?>
EOF


# Au cas où ce script-ci ait été exécuté par root,
# on donne les droits à notre utilisateur
sudo chown -R ${INSTALL_USERNAME}:${INSTALL_USERGROUP} ${INSTALL_USERWWW}


