#! /bin/sh
##############################
#Menu pour gérer les options system
#Autheur: Eric (GeekMag.fr)
#03/12/2017

#Déclaration des variables
TOOLBOX_PATH=/recalbox/scripts/geekmag_menu

MOUNT_NAS()
{
echo "Version beta: cette option n'est pas encore active"
#$TOOLBOX_PATH/scripts/SYSTEM/montage_NAS.sh
}

LOAD_IMG()
{
echo "Vesion beta: cette fonction n'est pas encore active"
#$TOOLBOX_PATH/scripts/SYSTEM/mount_IMG.sh
}

MOVE_ROMS()
{
 echo "Version beta: cette fonction n'est pas encore active"
}

BACKUP()
{
 echo "Version beta: cette fonction n'est pas encore active"
}

REBOOT()
{
 $TOOLBOX_PATH/scripts/SYSTEM/Reboot.sh
}

SHUTDOWN()
{
 $TOOLBOX_PATH/scripts/SYSTEM/Shutdown.sh
}

while true
do
  #..........................................................................
  # affichage des options du menu
  #..........................................................................
  clear
  echo "Via les options ci-dessous vous allez pouvoir gérer vos unité de stockage: carte SD, USB (disque ou clé), partage réseau (NAS ou PC)


1 )  Monter un partage réseau (NAS ou PC)
2 )  Charger un fichier IMG
3 )  Déplacer les ROMS (USB/SD)
4 )  Faire un backup

5 )  Rebooter Recalbox
6 )  Arrêter le système

r)  Retour au menu principal

Tapez le chiffre correspondant à votre choix puis appuyer sur Entrée"

  #..........................................................................
  # Appel des fonctions
  #..........................................................................
  read answer
  clear

  case "$answer" in

	[1]*) MOUNT_NAS;;
	[2]*) LOAD_IMG;;
	[3]*) MOVE_ROMS;;
	[4]*) BACKUP;;
	[5]*) REBOOT;;
	[6]*) SHUTDOWN;;

    [Rr]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichee dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done