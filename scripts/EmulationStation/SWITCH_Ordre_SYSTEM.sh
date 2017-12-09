#!/bin/bash
#Script permettant de changer l'ordre d'affichage des systemes dans ES
#Source: Geekmag.fr
#02/12/2017

############################ Declaration des variables ##############################################

#Passer le FS en écriture
mount -o remount,rw /
#Chemin du fichier de paramètre Recalbox
ES_SETTINGS_PATH=/recalbox/share_init/system/.emulationstation

#Emplacement  des fichiers de configuration
FIC_CONF_PATH=$TOOLBOX_PATH


ALPHABETIQUE()
{
 rm $ES_SETTINGS_PATH/es_systems.cfg
 cp $FIC_CONF_PATH/fichiers/conf/es_systems_alphabetique.cfg $ES_SETTINGS_PATH/es_systems.cfg
 echo "L'ordre d'affichage a été modifié pour trier les consoles par ordre alphabétique"
 echo "Faire un arrêt / relance d'Emulation station pour prendre en compte le changement"
}

LOGIQUE()
{
 rm $ES_SETTINGS_PATH/es_systems.cfg
 cp $FIC_CONF_PATH/fichiers/conf/es_systems_trie.cfg $ES_SETTINGS_PATH/es_systems.cfg
 echo "L'ordre d'affichage a été modifié pour regrouper les systèmes par marque"
 echo "Faire un arrêt / relance d'Emulation station pour prendre en compte le changement"
}

AR_ES()
{
 echo "Arrêt / Relance d'Emulation Station en cours"
 /etc/init.d/S31emulationstation restart >/dev/null 2>&1
}

while true
do
  #..........................................................................
  # affichage du menu
  #..........................................................................
  clear
  echo "Dans quel ordre voulez-vous afficher les consoles / systèmes?
ATTENTION: si vous avez ajouté des collections spécifiques, après avoir changé l'ordre d'affichage, il faudra les ré-ajouter


1) Par ordre Alphabétique (par défaut)
2) Grouper par ordre logique (ex: regouper les consoles Nintendo)
3) Faire un arrêt / relance d'Emulationstation

R) Retour au menu principal

 Tapez le chiffre correspondant à votre choix puis appuyer sur Entrée"


  #..........................................................................
  # Fonctions appelées par le menu
  #..........................................................................
  read answer
  clear

  case "$answer" in

    [1]*) ALPHABETIQUE;;
    [2]*) LOGIQUE;;
	[3]*) AR_ES;;

    [Rr]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichee dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done