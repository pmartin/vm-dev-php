#!/bin/bash
. `dirname $0`/config.sh

echo "Ce script va installer Dotclear :";
echo "  * Téléchargement et décompression des sources";
echo "  * Création et activation d'un VirtualHost Apache";
echo "  * Création d'une base de données et de son utilisateur";
echo "";
echo "Vous ne jouerez généralement pas ce script sur votre machine de ";
echo "développement (vous n'avez pas besoin d'y installer Dotclear...), ";
echo "mais ce script a pour but de montrer comment y mettre en place";
echo "une nouvelle application avec sources PHP + DB MySQL";
echo "";
echo "Pour pouvoir lancer ce script, commentez l'instruction 'exit' qui ";
echo "figure au début de celui-ci, et paramétrez les quelques variables"
echo "qui peuvent l'être."
exit;



# Le nom d'hôte qui sera utilisé pour accéder à l'application
# TODO : A adapter
export DOTCLEAR_HOST="dotclear.myserver"


# La racine où sera déployé Dotclear
export DOTCLEAR_ROOT="${INSTALL_USERHOME}/www/dotclear"

# L'URL depuis laquelle Dotclear sera téléchargé
export DOTCLEAR_DOWNLOAD_URL="http://download.dotclear.net/latest-2.0.tar.gz"



# Téléchargement et décompression des sources
wget --output-document=/tmp/dotclear.tar.gz ${DOTCLEAR_DOWNLOAD_URL} 

[ ! -d ${DOTCLEAR_ROOT} ] && mkdir -p ${DOTCLEAR_ROOT}
cd `dirname ${DOTCLEAR_ROOT}`
tar -xvf /tmp/dotclear.tar.gz

rm /tmp/dotclear.tar.gz



# Quelques changements de droits, pour que Apache puisse écrire là où Dotclear a besoin :
chmod o+w ${DOTCLEAR_ROOT}/inc
chmod o+w ${DOTCLEAR_ROOT}/cache



# Création d'une DB MySQL, et d'un utilisateur
sudo sh -c "cat | mysql --user=root --password=root --host=localhost" <<EOF
create user dotclear identified by 'dotclear';
GRANT ALL PRIVILEGES ON dotclear.* TO 'dotclear'@'%' identified by 'dotclear';
GRANT ALL PRIVILEGES ON dotclear.* TO 'dotclear'@'localhost' identified by 'dotclear';
create database dotclear;
EOF



# Création et activation du VirtualHost Apache
# On utilisera un nom de domaine spécifique pour accéder à l'application...
# ... et celui-ci devra généralement être ajouté au fichier 'hosts' de la machine physique
sudo sh -c "cat > /etc/apache2/sites-available/001-dotclear" <<EOF
<VirtualHost *:80>
        ServerName ${DOTCLEAR_HOST}
        DocumentRoot ${DOTCLEAR_ROOT}
        <Directory ${DOTCLEAR_ROOT}>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>
        ErrorLog /var/log/apache2/dotclear-error.log
        LogLevel warn
        CustomLog /var/log/apache2/dotclear-access.log combined
</VirtualHost>
EOF

sudo a2ensite 001-dotclear
sudo /etc/init.d/apache2 restart





echo "";
echo "Répertoire contenant Dotclear :";
echo "    ${DOTCLEAR_ROOT}";
echo ""
echo "Informations de connexion MySQL :"
echo "    * Hote: localhost"
echo "    * Nom de la Base de données: dotclear"
echo "    * Utilisateur: dotclear"
echo "    * Mot de passe: dotclear"
echo ""
echo "URL de l'application"
echo "    http://${DOTCLEAR_HOST}"
echo "  => Veillez à mettre à jour le fichier 'hosts' de votre machine physique"
echo ""

