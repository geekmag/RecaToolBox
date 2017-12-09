#!/bin/bash
#Correction droits
#
#Version 1.0
#21/11/2017
##########################################################

cd $TOOLBOX_PATH/scripts/EmulationStation

chmod +x *.sh
dos2unix *sh

cd $TOOLBOX_PATH/scripts/SYSTEM/

chmod +x *.sh
dos2unix *sh

cd $TOOLBOX_PATH/scripts/ToolBox/

chmod +x *.sh
dos2unix *sh