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







