#!/bin/bash

aptitude -y install subversion subversion-tools

# On passera par Apache = WebDAV pour accèder à SVN
aptitude -y install apache2-mpm-prefork apache2 libapache2-svn

aptitude clean


a2enmod headers
a2enmod expires
a2enmod ssl
a2enmod dav


mkdir /home/svn
chown www-data.www-data /home/svn

echo "\n127.0.0.1	svn.myserver\n" >> /etc/hosts

cat > /etc/apache2/sites-available/svn.myserver <<EOF
<VirtualHost *:443>
    ServerName svn.myserver
    UseCanonicalName on
	SSLEngine on
	SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
	SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
    <Location />
        DAV svn
        SVNParentPath /home/svn
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

a2ensite svn.myserver

sudo -u www-data svnadmin create /home/svn/test-repository
chmod 700 /home/svn/test-repository


sudo htpasswd -cmb /etc/svn-auth-file user1 password1
sudo htpasswd -mb /etc/svn-auth-file user2 password2
sudo htpasswd -mb /etc/svn-auth-file anonymous anonymous

cat > /etc/svn-access-file <<EOF
[test-repository:/]
user1 = rw
user2 = rw
anonymous = r

EOF

/etc/init.d/apache2 restart


echo "Repository URL : https://svn.myserver/test-repository/"
echo "Accès :"
echo "  user1 / password1 (read-write)"
echo "  user2 / password2 (read-write)"
echo "  anonymous / anonymous (read)"


