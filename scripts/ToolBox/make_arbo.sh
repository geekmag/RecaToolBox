#!/bin/bash
#Script permettant de créer les arborescences de la RecaToolBox dans le share
#02/12/2017
#Source GeekMag.fr

TOOLBOX_USER=/recalbox/share/RecaToolBox
VIDEO_INTRO_PATH=$TOOLBOX_USER/Download/video_intro

#Décompression du répertoire RecalToolbox utilisateur
echo "Création du dossier RecaToolBox"
mkdir $TOOLBOX_USER

tar xf $TOOLBOX_PATH/fichiers/Source/RecaToolBox_user.tar -C $TOOLBOX_USER







