#! /bin/sh
##############################
#Affiche la version de RecaToolBox
# Ainsi que des informations sur Recalbox
#14/12/2017

source $TOOLBOX_PATH/VERSION

#Affiche la version de la distribution
uname -a
echo "Version de la Build de Recalbox: " & more /recalbox/recalbox.version
echo "RecaToolBox - version $TOOLBOX_VERSION"

#Récupère l'adresse IP
$TOOLBOX_PATH/scripts/SYSTEM/show_IP.sh
#Affiche le thème en cours d'utilisation
$TOOLBOX_PATH/scripts/EmulationStation/theme_info.sh