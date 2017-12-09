#!/bin/bash
#Script permettant de vérifier si la vidéo d'intro de Recalbox
#a déjà été sauvegardée et le fait si ce n'est pas le cas
# source geekmag.fr/
#22/12/2017

#passe la partition en écriture
mount -o remount,rw /

SPLASH_PATH=/recalbox/system/resources/splash
cd $VIDEO_INTRO_PATH

VIDEO_INTRO_PATH=/recalbox/share/RecaToolBox/Download/video_intro
INTRO_VIDEO=recalboxintro.mp4
BK_INTRO_VIDEO=recalboxintro.mp4.original
 
if [ -f "$BK_INTRO_VIDEO" ];
then
   echo "Il y a déjà une sauvegarde de la vidéo d'intro"
   rm -f $VIDEO_INTRO_PATH/$INTRO_VIDEO
else
   echo "Sauvegarde inexistante, on va donc la faire maintenant"
   echo "Patientez pendant la copie cela prend quelques instant"
   mv $SPLASH_PATH/$INTRO_VIDEO $SVIDEO_INTRO_PATH/$INTRO_VIDEO.original
fi