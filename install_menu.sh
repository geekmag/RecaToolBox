#!/bin/bash
#Installation des scripts nécessaire au fonctionnement de la RecaToolBox
# Source : GeekMag.fr
#13/12/2017
##########################################################

echo "Installation en cours..."

#Passer le FS est écriture
mount -o remount,rw /

#Chemin d'installation
export TOOLBOX_HOME=/recalbox/share/RecaToolBox
export TOOLBOX_PATH=$TOOLBOX_HOME/ToolBox
export TOOLBOX_DOWNLOAD_PATH=$TOOLBOX_HOME/Download

#Création du dossier qui stock les scripts
mkdir $TOOLBOX_HOME

################# Déclaration des variables ##############

#Nom de l'archive a deployer
ARCH_NAME=RecaToolBox.tar

#Décompression de l'archive
tar -xf $ARCH_NAME -C $TOOLBOX_HOME

#Création des alias pour lancer le menu et les variables d'environnement
$TOOLBOX_PATH/scripts/SYSTEM/env.sh

source ~/.profile

#Ajout des droits d'execution sur les fichiers
$TOOLBOX_PATH/scripts/SYSTEM/fic_droits.sh

#Modification des partages Samba
$TOOLBOX_PATH/scripts/SYSTEM/samba.sh



#nettoyage des fichiers d'installation
#rm -f $PWD/$ARCH_NAME

clear
$TOOLBOX_PATH/scripts/ToolBox/banner.sh
echo ""
echo ""
echo "Bravo! Vous venez d'installer la RecalToolboox qui va vous aider à configurer Recalbox"
echo "Tapez menu pour lancer la configuration et validez par entrée"
echo ""
echo "Lors de la première utilisation, il est conseillé d'aller dans le menu:"
echo "Informations et Mise à jour puis faire mettre à jour la source des téléchargement"
