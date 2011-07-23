**Installation d'un serveur de développement PHP sous Linux (Ubuntu 11.04)**

# Objectifs #

* Obtenir un serveur LAMP "light"
* Typiquement utilisé comme machine virtuelle de "runtime" *(Avec l'IDE, les navigateurs, ... qui tournent sur une machine physique)*
* Fonctionnel pour les besoins de projets "standard"
* Intégrant les outils de développement + debug les plus fréquemment utilisés.


# Principe #

* Installation de [Ubuntu Server](http://www.ubuntu.com/download/server/download) -- *11.04 - Natty Narwhal au moment où j'écris ceci*
  * Système de base, avec peu de paquets
* Installation manuelle d'une sélection de paquets fournis par la distribution
  * Apache
  * PHP
  * MySQL
  * Quelques outils de développement
* Installation d'outils de développement supplémentaires, éventuellement non fournis par la distribution
* Configuration


# Installation de Ubuntu Server dans une machine virtuelle #

## Création de la machine virtuelle ##

Au choix, utilisation de [VMWare](http://www.vmware.com/products/player/) ou [VirtualBox](http://www.virtualbox.org/).

Quelques points à noter :

* CPU : moins que sur votre machine physique
  * Sur une machine physique dual-core => machine virtuelle mono-core
  * Sur une machine physique quad-code => machine virtuelle dual-core
* RAM : veiller à en garder assez pour la machine physique
  * Machine physique à 2 GB de RAM => ça va pas être évident...
  * Machine physique à 3 GB de RAM *(Ou 4 GB mais Windows 32 bits)* => Entre 700 MB et 1 GB de RAM pour la VM
  * Machine physique à 4 GB de RAM ou plus => 1 GB de RAM pour la VM ; plus si lancement de grosses applications bien gourmandes.


## Installation Ubuntu Server ##

Je ne détaille pas le processus d'installation *(en gros, c'est "suivant, suivant, suivant" -- prenez juste le temps de lire les écrans, pour mettre les bonnes réponses)*, mais voici quelques notes à propos de points spécifiques, ou correspondant à mes préférences d'installation pour ce type de machine :

* Nom de machine : j'utilise généralement quelque chose du genre `devhost`
* Disques : pour éviter d'avoir à trop réfléchir, et des tailles de partitions qui ne vont pas *(du style partition système trop grosse, partition utilisateur trop petite)*, je fais généralement une seule partition "données", plus une petite partition "swap" ; ce qui signifie :
  * Méthode de partitionnement : assisté - utiliser un disque entier
* Utilisateur : considérant que les VM de développement que je crée sont souvent utilisées par plusieurs personnes, et/ou pour plusieurs projets, je n'indique jamais de "vrai" nom ; en général, je pars sur :
  * Nom complet : `Anon YMOUS`
  * Identifiant : `user`
  * Mot de passe : `password`
* Proxy HTTP pour l'outil de gestion de paquet : si vous en avez un sur votre réseau, indiquez le, vous y gagnerez sur les temps de téléchargement *(si vous ne comprenez pas la question, c'est que vous n'en n'avez pas, et laissez le champ vide)*
* Sélection des logiciels : en général, je n'installe que peu de paquet ici *(et installerai le reste manuellement plus tard)* -- je sélectionne généralement :
  * OpenSSH Server
  * Samba file server

Une fois la machine rebootée, vous pouvez vous connecter avec le compte `user / password` créé lors de l'installation.


Pour connaitre l'adresse IP de la machine *(et vous y connecter ensuite en SSH, via un client qui support le copier-coller, ce qui facilitera notamment les lancements de commandes)*, utilisez la commande suivante :

    ifconfig


# Scripts d'installations #

Maintenant que l'installation de base de la machine est faite, nous allons pouvoir passer aux installations et configurations de logiciels.

Pour cela, vous avez une liste de shell-scripts, installant chacun une série d'outils / logiciels en rapport avec le développement PHP.
<br>Voici quelques notes sur certains d'entre eux - dans l'ordre où vous aurez tendance à les lancer.


## Outils / configuration de base : install-base.sh  ##

C'est le premier script à lancer, et vous voudrez probablement systématiquement l'exécuter.

Actions principales :
* Partage via samba de l'ensemble du répertoire de votre utilisateur *(pourra être monté en tant que lecteur réseau sous windows)*.
* Affichage de l'adresse IP + login/password dès le lancement de la machine virtuelle.
* Quelques améliorations mineures de configuration.


## Utilitaires, SCM : install-utils.sh ##

Ce script installe quelques logiciels *utilitaires*, dont accès à des système de [SCM](http://en.wikipedia.org/wiki/Source_Code_Management) :
* Accès à des gestionnaires de contrôle de source : SVN, Git, ... *(vous voudrez peut-être commenter ou décommenter quelques lignes, en fonction de vos besoins)*
* Quelques outils "système"
* Quelques outils réseau / internet


## Outils de développement "système" : install-dev-tools.sh ##

Ce script installe un ensemble d'outils de développement *(librairies permettant de compiler PHP, notamment)*.

Il vous faudra le lancer : une partie des outils installés par ce script sont nécessaire à l'installation d'extensions PHP *(certaines d'entre elles étant installées en les compilant)*.


## Apache et PHP 5.3 : install-apache-and-php5.3.sh ##

L'étape suivante est l'installation de Apache et PHP 5.3 + extensions + paquets PEAR fréquemment utiles.

Pour installer Apache + PHP et intégrer PHP à Apache, vous lancerer le script :

    install-apache-and-php5.3.sh

Lui-même fera appel à deux sous-scripts, chacun chargés d'installer + configurer un des composants :

* Installation et configuration d'Apache : `zz-install-apache.sh`
* Installation et configuration de PHP + extensions : `zz-install-php5.3.sh`


# MySQL : install-mysql.sh ##

Ce script va :
* Installer le serveur MySQL
  * Le configurer pour autoriser les connexions distantes *(pour que vous puissiez utiliser un client lourd sur votre machine physique, par exemple)*
  * Initialiser le compte administrateur avec les informations de connexion suivantes : `root / root`
* Installer les outils clients en ligne de commande













