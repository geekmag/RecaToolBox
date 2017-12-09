#!/bin/bash
#Installation des scripts permettant de personnaliser Recalbox
# Source : GeekMag.fr
#Version 1.0
#19/11/2017
##########################################################

echo "Installation en cours..."

#Passer le FS est écriture
mount -o remount,rw /

#Chemin d'installation
GEEK_MENU=/recalbox/scripts/geekmag_menu

#Création du dossier qui stock les scripts
mkdir $GEEK_MENU

################# Déclaration des variables ##############

#Nom de l'archive a deployer
ARCH_NAME=RecaToolBox.tar

#Décompression de l'archive
tar -xf $ARCH_NAME -C $GEEK_MENU

#Ajout des droits d'execution sur les fichiers
$GEEK_MENU/scripts/SYSTEM/fic_droits.sh

#Création de l'arborescence utilisateur
$GEEK_MENU/scripts/ToolBox/make_arbo.sh

#Modification des partages Samba
$GEEK_MENU/scripts/SYSTEM/samba.sh

#Création des alias pour lancer le menu
$GEEK_MENU/scripts/SYSTEM/env.sh

source ~/.profile

#nettoyage des fichiers d'installation
#rm -f $PWD/$ARCH_NAME

clear
more $GEEK_MENU/fichiers/ASCII_Logo.txt
echo ""
echo ""
echo "Bravo! Vous venez d'installer la RecalToolboox qui va vous aider à configurer Recalbox"
echo "Tapez menu pour lancer la configuration et validez par entrée"

