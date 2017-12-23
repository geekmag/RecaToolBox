#!/bin/bash
#Script permettant de tester le thème utilisé
#Version 1.0
#19/11/2017

#Chemin du fichier de paramètre Recalbox
ES_SETTINGS_PATH=/recalbox/share/system/.emulationstation/es_settings.cfg

#Recherche dans le fichier le theme utilise
variable_theme=$(sed -rn '/ThemeSet/s/.*value="([^"]+)".*/\1/p' $ES_SETTINGS_PATH)
#Passage du résultat en variable
NOM_THEME="$variable_theme"
#Affiche le nom du theme utilisé
echo "Vous utilisez le thème:" $NOM_THEME