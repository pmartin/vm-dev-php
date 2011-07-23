#!/bin/bash
. `dirname $0`/config.sh


sudo sh -c "cat >> /etc/samba/smb.conf" <<EOF
[home-user]
    comment = Home ${INSTALL_USERNAME}
    read only = no
    path = ${INSTALL_USERHOME}/
    guest ok = yes
    writable = yes
    public = yes
    create mode = 0775		# Un peu beaucoup permissif, mais pour développer, ça simplifiera des choses
    force user = ${INSTALL_USERNAME}
    force group = ${INSTALL_USERGROUP}
EOF
sudo service smbd restart


# On ne veut pas que root puisse se connecter en SSH
sudo sed -i -e 's/^PermitRootLogin yes$/PermitRootLogin no/' /etc/ssh/sshd_config

# On veut qu'une banner soit affichée lors de la connexion SSH, avant demande du login/password
sudo sed -i -e 's/^#Banner \/etc\/issue.net$/Banner \/etc\/issue.net/' /etc/ssh/sshd_config

sudo restart ssh


# Message qui sera affiché avant le login
# (Si on utilise putty comme client, sera affiché seulement après la saisie du login ; depuis un client sous Linux, sera affiché avant la saisie du login)
sudo sh -c "cat > /etc/issue.net" <<EOF
Bienvenue sur votre VM de developpement.
Scripts d'installation utilises : https://github.com/pmartin/vm-dev-php

Login / password par defaut : user / password
EOF


# Coloration du prompt
#sed -i -e 's/^#force_color_prompt=yes$/force_color_prompt=yes/' ${INSTALL_USERHOME}/.bashrc

# Quelques aliases utiles
sed -i -e "s/^alias ll='ls -alF'\$/alias ll='ls -lF'/" ${INSTALL_USERHOME}/.bashrc

# Et un prompt un peu plus sympa / utile
echo "export PS1='\\u@\\h: \\w\\\n\\$ '" >> ${INSTALL_USERHOME}/.bashrc


# Script qui écrit dans un fichier l'adresse IP courante de la machine
sudo sh -c "cat > /usr/local/bin/get-ip-address" <<EOF
#!/bin/bash
/sbin/ifconfig | grep "inet addr" | grep -v "127.0.0.1" | awk '{ print \$2 }' | awk -F: '{ print \$2 }'
EOF
sudo chmod +x /usr/local/bin/get-ip-address


# Fichier d'issue "par défaut" -- copie du fichier utilisé pour SSH
sudo cp /etc/issue.net /etc/issue-standard


# Script qui sera lancé automatiquement lorsqu'une interface est activée
# => Peut re-définir l'issue affichée quand on demande un login, en mettant dedans l'IP courante
#   (celle-ci étant obtennue via le script créé plus haut)
sudo sh -c "cat > /etc/network/if-up.d/override-issue-with-IP" <<EOF
#!/bin/bash
if [ "\$METHOD" = loopback ]; then
    exit 0
fi

# Only run from ifup.
if [ "\$MODE" != start ]; then
    exit 0
fi

cp /etc/issue-standard /etc/issue
echo -n "Adresse IP : " >> /etc/issue
/usr/local/bin/get-ip-address >> /etc/issue
echo "" >> /etc/issue
EOF
sudo chmod +x /etc/network/if-up.d/override-issue-with-IP


