#!/bin/bash
#Script permettant de vérifier si la vidéo d'intro de Recalbox
#redirige sur un lien symbolique ou une vidéo
# source geekmag.fr/
#22/12/2017

#passe la partition en écriture
mount -o remount,rw /

#Chemin vers la Toolbox
TOOLBOX_PATH=/recalbox/scripts/geekmag_menu

SPLASH_PATH=/recalbox/system/resources/splash
cd $SPLASH_PATH

INTRO_VIDEO=recalboxintro.mp4
 
if [ -L "$INTRO_VIDEO" ];
then
   echo "La vidéo d'intro redirige actuelement vers le fichier suivant"
   ls -l $SPLASH_PATH/$INTRO_VIDEO
   echo "Suppression du lien actuel"
   rm -f $SPLASH_PATH/$INTRO_VIDEO
else
   echo "Il n'y a actuelement pas de lien symbolique sur la vidéo d'intro"
   ls -l $SPLASH_PATH/$INTRO_VIDEO
   echo "Vérification du fichier recalboxintro.mp4"
   $TOOLBOX_PATH/scripts/EmulationStation/Check_Backup_Video_Intro.sh
fi