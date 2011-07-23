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








