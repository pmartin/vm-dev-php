#!/bin/bash

sudo apt-get -y install language-pack-fr htop vim debian-keyring 

# En fonction des systèmes de version de sources que vous utilisez ou non,
# vous voudrez peut-être commenter ou dé-commenter certaines de ces lignes
sudo apt-get -y install subversion subversion-tools
sudo apt-get -y install git-svn git-core
#sudo apt-get -y install bzr

# Si vous souhaitez utiliser ant (script de lancement de tâches en JAVA)
#sudo apt-get -y install ant

# Outils réseau, téléchargement, ...
sudo apt-get -y install nmap whois lynx wget curl siege

sudo apt-get clean
