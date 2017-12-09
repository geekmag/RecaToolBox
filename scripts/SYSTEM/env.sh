#!/bin/bash
# Source: GeekMag.fr
#Version 1.0
#19/11/2017
#à lancer . ./env.sh
#######################

echo "Création des alias..."

#Création des variables d'environnement
echo "export TOOLBOX_PATH='$TOOLBOX_PATH'" >> ~/.profile

#Création des alias
echo "alias menu=$TOOLBOX_PATH/scripts/menu.sh" >> ~/.profile
echo "alias ll='ls -lrt'" >> ~/.profile
echo "alias toolbox='cd /recalbox/share/RecaToolBox'" >> ~/.profile

#Rechargement variables environnement
source ~/.profile