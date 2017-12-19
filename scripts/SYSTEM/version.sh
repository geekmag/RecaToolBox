#! /bin/sh
##############################
#Affiche la version de RecaToolBox
# Ainsi que des informations sur Recalbox
#15/12/2017

#Chargement du fichier ou l'on indique la version
source $TOOLBOX_PATH/VERSION

#Test l'espace libre sur le FS
FREESPACE=$(df -h /recalbox/share | awk '{print $4}' | tail -n 1)

#Check de la version de la build de Recalbox
RECALBOX_VERSION=$(more /recalbox/recalbox.version)

#Affiche la version de la distribution
uname -a
echo "Recalbox build: $RECALBOX_VERSION"
echo "RecaToolBox - version $TOOLBOX_VERSION"
echo ""
#Appel du script remontant la température
$TOOLBOX_PATH/scripts/SYSTEM/temperature.sh
#Récupère la fréquence du CPU
$TOOLBOX_PATH/scripts/SYSTEM/Vitesse_CPU.sh
#Récupère l'adresse IP
$TOOLBOX_PATH/scripts/SYSTEM/show_IP.sh
echo "Vous avez $FREESPACE d'espace libre"
echo ""
#Affiche le thème en cours d'utilisation
$TOOLBOX_PATH/scripts/EmulationStation/theme_info.sh
