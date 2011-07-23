#!/bin/bash

# Pour que le mot de passe 'root' MySQL ne soit pas demandé
# Mais pris depuis ce qui est configuré ici :
sudo sh -c "echo mysql-server mysql-server/root_password select root | debconf-set-selections"
sudo sh -c "echo mysql-server mysql-server/root_password_again select root | debconf-set-selections"

sudo apt-get install -y mysql-server mysql-client
sudo apt-get clean

# Active l'écoute autre qu'en local
# => Le serveur MySQL sera accessible via le réseau (depuis la machine physique, par exemple, pour s'y connecter avec un client lourd)
sudo sed -i -e 's/^bind-address.*=.*127.0.0.1.*$/#bind-address = 127.0.0.1/' /etc/mysql/my.cnf


echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by 'root';" | mysql --user=root --password=root --host=localhost

sudo restart mysql

echo "\nMot de passe de l'utilisateur 'root' MySQL => 'root'\n"

