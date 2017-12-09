#!/bin/bash
#Correction droits
#
#Version 1.0
#21/11/2017
##########################################################

#Chemin d'installation
GEEK_MENU=/recalbox/scripts/geekmag_menu

cd $GEEK_MENU/scripts/EmulationStation

chmod +x *.sh
dos2unix *sh

cd $GEEK_MENU/scripts/SYSTEM/

chmod +x *.sh
dos2unix *sh

cd $GEEK_MENU/scripts/ToolBox/

chmod +x *.sh
dos2unix *sh