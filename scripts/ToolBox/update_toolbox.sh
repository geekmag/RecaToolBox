#!/bin/bash
#Permet de télécharger automatiquement les mises à jour
#
#Version 1.0
#19/11/2017
##########################################################

echo "Installation en cours..."

#Passer le FS est écriture
mount -o remount,rw /


#Chemin d'installation
GEEK_MENU=/recalbox/scripts/geekmag_menu
#Nom de l'archive a deployer
ARCH_NAME=RecalToolboox_update.tar

#Décompression de l'archive
tar -xf $ARCH_NAME -C $GEEK_MENU

#correction des droits sur les fichiers
dos2unix $GEEK_MENU/scripts/*.sh
chmod +x $GEEK_MENU/scripts/*



#nettoyage des fichiers d'installation
#rm -f $PWD/$ARCH_NAME

clear
more $GEEK_MENU/fichiers/ASCII_Logo.txt
echo ""
echo ""
echo "Votre RecalToolbox a été mise à jour"
echo "Tapez menu pour lancer la configuration"

