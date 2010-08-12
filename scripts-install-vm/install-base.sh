#!/bin/bash

cat >> /etc/samba/smb.conf <<EOF
[home-user]
    comment = Home user
    read only = no
    path = /home/user/
    guest ok = yes
    writable = yes
    public = yes
    create mode = 0775		# Un peu beaucoup permissif, mais pour développer, ça simplifiera des choses
    force user = user
    force group = user
EOF
service smbd restart


sed -i -e 's/^PermitRootLogin yes$/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e 's/^#Banner \/etc\/issue.net$/Banner \/etc\/issue.net/' /etc/ssh/sshd_config
/etc/init.d/ssh restart

# Message qui sera affiché avant le login
# (Si on utilise putty comme client, sera affiché seulement après la saisie du login ; depuis un client sous Linux, sera affiché avant la saisie du login)
cat > /etc/issue.net <<EOF
Bienvenue sur votre VM de dev.
Pour toute question, contacter Pascal MARTIN

Login / password par défaut : user / password
EOF

sed -i -e 's/^#force_color_prompt=yes$/force_color_prompt=yes/' /home/user/.bashrc
sed -i -e "s/^alias ll='ls -alF'\$/alias ll='ls -lF'/" /home/user/.bashrc
echo "export PS1='\[\e]0;\u@\h: \w\a\]\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\] \n\$ '" >> /home/user/.bashrc
#. /home/user/.bashrc


# Script qui renvoit l'adresse IP courante de la machine
cat > /usr/local/bin/get-ip-address <<EOF
#!/bin/bash
/sbin/ifconfig | grep "inet addr" | grep -v "127.0.0.1" | awk '{ print \$2 }' | awk -F: '{ print \$2 }'
EOF
chmod +x /usr/local/bin/get-ip-address

# Fichier d'issue "par défaut"
cat > /etc/issue-standard <<EOF
Bienvenue sur votre VM de dev.
Pour toute question, contacter Pascal MARTIN

Login / password par défaut : user / password
EOF


# Script qui sera lancé automatiquement lorsqu'une interface est activée
# => Peut re-définir l'issue affichée quand on demande un login, en mettant dedans l'IP courante
cat > /etc/network/if-up.d/override-issue-with-IP <<EOF
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
chmod +x /etc/network/if-up.d/override-issue-with-IP


