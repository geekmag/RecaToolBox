#! /bin/sh
##############################
#Menu pour gérer les options system
#Autheur: Eric (GeekMag.fr)
# Créé le: 03/12/2017
# Dernière MAJ: 18/12/2017

MOUNT_NAS()
{
$TOOLBOX_PATH/scripts/SYSTEM/montage_NAS.sh
}

LOAD_IMG()
{
echo "Vesion beta: cette fonction n'est pas encore active"
#$TOOLBOX_PATH/scripts/SYSTEM/mount_IMG.sh
}

RESTORE()
{
$TOOLBOX_PATH/scripts/SYSTEM/USB_to_SD.sh
}

BACKUP()
{
$TOOLBOX_PATH/scripts/SYSTEM/SD_to_USB_backup.sh
}

REBOOT()
{
 $TOOLBOX_PATH/scripts/SYSTEM/Reboot.sh
}

SHUTDOWN()
{
 $TOOLBOX_PATH/scripts/SYSTEM/Shutdown.sh
}

UNINSTALL()
{
 $TOOLBOX_PATH/scripts/uninstall.sh
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
3 )  Faire une sauvegarde (SD -> USB)
4 )  Restaurer une sauvegarde (USB -> SD)
5 )  Désinstaller RecaToolBox

6 )  Rebooter Recalbox
7 )  Arrêter le système

0)  Retour au menu principal

Tapez le chiffre correspondant à votre choix puis appuyer sur Entrée"

  #..........................................................................
  # Appel des fonctions
  #..........................................................................
  read answer
  clear

  case "$answer" in

	[1]*) MOUNT_NAS;;
	[2]*) LOAD_IMG;;
	[3]*) BACKUP;;
	[4]*) RESTORE;;
	[5]*) UNINSTALL;;
	[6]*) REBOOT;;
	[7]*) SHUTDOWN;;

    [0]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichee dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done
