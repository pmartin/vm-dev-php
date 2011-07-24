#!/bin/bash

echo "Ce script n'est normalement pas à jouer sur une machine de développement, "
echo "puisqu'il installe un serveur SVN."
echo ""
echo "Si vous avez besoin d'un serveur SVN, vous devriez l'installer sur une"
echo "'vraie' machine, avec des sauvegardes régulières."
echo "";
echo "Cela dit, si vous avez besoin d'un serveur SVN 'de test', dé-commentez";
echo "l'instruction 'exit' en haut de ce script, pour pouvoir l'exécuter, ";
echo "et paramétrez les variables qui peuvent l'être.";
exit;


# Les repositories SVN seront stockés dans ce répertoire
export SVN_HOME="/home/svn"

# Le nom de machine du serveur (qui permet d'y accéder en HTTP) sur le réseau
export SVN_SERVER="svn.myserver"




sudo apt-get -y install subversion subversion-tools

# On passera par Apache = WebDAV pour accèder à SVN
sudo apt-get -y install apache2-mpm-prefork apache2 libapache2-svn

sudo apt-get clean


# Activation des quelques modules Apache dont nous aurons besoin pour accéder au SVN :
sudo a2enmod headers
sudo a2enmod expires
sudo a2enmod ssl
sudo a2enmod dav



sudo mkdir ${SVN_HOME}
sudo chown www-data.www-data ${SVN_HOME}

sudo sh -c 'echo "\n127.0.0.1	svn.myserver\n" >> /etc/hosts'

sudo sh -c "cat > /etc/apache2/sites-available/svn.myserver" <<EOF
<VirtualHost *:443>
    ServerName ${SVN_SERVER}
    UseCanonicalName on
	SSLEngine on
	SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
	SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
    <Location />
        DAV svn
        SVNParentPath ${SVN_HOME}
        AuthzSVNAccessFile /etc/svn-access-file
        <Limit OPTIONS PROPFIND GET REPORT MKACTIVITY PROPPATCH PUT CHECKOUT MKCOL MOVE COPY DELETE LOCK UNLOCK MERGE>
            Require valid-user
            AuthType Basic
            AuthName "Subversion repository"
            AuthUserFile /etc/svn-auth-file
        </Limit>
    </Location>
</VirtualHost>
EOF

sudo a2ensite svn.myserver


# Création d'un repository de test
sudo -u www-data svnadmin create ${SVN_HOME}/test-repository
sudo chmod 700 ${SVN_HOME}/test-repository


# Création de quelques comptes utilisateur + mots de passe par défaut
sudo htpasswd -cmb /etc/svn-auth-file user1 password1
sudo htpasswd -mb /etc/svn-auth-file user2 password2
sudo htpasswd -mb /etc/svn-auth-file anonymous anonymous


# Initialisation du fichier disant quel utilisateur a accès à quel repository, et en quel mode (lecture / écriture)
sudo sh -c "cat > /etc/svn-access-file" <<EOF
[test-repository:/]
user1 = rw
user2 = rw
anonymous = r

EOF


# Et enfin, redémarrage Apache pour prendre en compte le nouveau VirtualHost
sudo /etc/init.d/apache2 restart


echo "Repository URL : https://${SVN_SERVER}/test-repository/"
echo "Accès :"
echo "  user1 / password1 (read-write)"
echo "  user2 / password2 (read-write)"
echo "  anonymous / anonymous (read)"


