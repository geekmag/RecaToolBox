#!/bin/bash
#Script permettant de créer les arborescences de la RecaToolBox dans le share
#02/12/2017
#Source GeekMag.fr

#Décompression du répertoire RecalToolbox utilisateur
echo "Création du dossier RecaToolBox"
mkdir $TOOLBOX_HOME

tar xf $TOOLBOX_PATH/fichiers/Source/RecaToolBox_user.tar -C $TOOLBOX_HOME







