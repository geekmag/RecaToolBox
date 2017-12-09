#!/bin/bash
# Source: GeekMag.fr
#Version 1.0
#19/11/2017
#à lancer . ./env.sh
#######################

echo "Création des alias..."


#Création des alias
echo "alias menu=/recalbox/scripts/geekmag_menu/scripts/menu.sh" >> /recalbox/share/system/.profile
echo "alias ll='ls -lrt'" >> /recalbox/share/system/.profile
echo "alias toolbox='cd /recalbox/share/RecaToolBox'" >> /recalbox/share/system/.profile

#Rechargement variable environnement
. /recalbox/share/system/.profile