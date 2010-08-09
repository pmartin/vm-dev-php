#!/bin/sh

# Pour que le mot de passe 'root' MySQL ne soit pas demandé
# Mais pris depuis ce qui est configuré ici :
echo mysql-server mysql-server/root_password select root | debconf-set-selections
echo mysql-server mysql-server/root_password_again select root | debconf-set-selections

aptitude install -y mysql-server mysql-client
aptitude clean

sed -i -e 's/^bind-address.*=.*127.0.0.1.*$/#bind-address = 127.0.0.1/' /etc/mysql/my.cnf

echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by 'root';" | mysql --user=root --password=root --host=localhost

restart mysql

echo "\nMot de passe de l'utilisateur 'root' MySQL => 'root'\n"

