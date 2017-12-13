#!/bin/bash
# Source: GeekMag.fr
#Version 1.0
#19/11/2017
#à lancer . ./env.sh
#######################

echo "Création des alias..."

if [ ! -f ~/.profile ]; then
    echo "Le fichier de profil n'existe pas, on le crée"
    touch ~/.profile
    chmod +x ~/.profile
fi



#Création des variables d'environnement
PRESENCE=`grep TOOLBOX ~/.profile | wc -l`
if [ $PRESENCE == "0"  ]; then
    echo "export TOOLBOX_HOME='$TOOLBOX_HOME'" >> ~/.profile
    echo "export TOOLBOX_PATH='$TOOLBOX_PATH'" >> ~/.profile

    #Création des alias
    echo "alias menu=$TOOLBOX_PATH/scripts/menu.sh" >> ~/.profile
    echo "alias ll='ls -lrt'" >> ~/.profile
    echo "alias toolbox='cd /recalbox/share/RecaToolBox'" >> ~/.profile
else
    echo "Les variables sont déjà définies"
fi
#Rechargement variables environnement
source ~/.profile