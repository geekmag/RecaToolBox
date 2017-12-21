#!/bin/bash
#Script permettant de monter un NAS
#16/12/2017
#Source GeekMag.fr


############################# Fonction montage du NAS dans /recalbox/share ###########################

RECALBOX_SHARE()
{
echo "AVERTISSEMENT: Toutes les données présente dans /recalbox/share sont être copiées sur le réseau"
echo "Patientez pendant le redémarrage cela peut prendre du temps"
echo "Il est conseillé de passer par le réseau filaire si vous avez une carte remplie de beaucoup de ROM ;)"
echo "ATTENTION: après redémarrage, il faudra ré-installer RecaToolBox"
echo ""
#Demande à l'utilisateur de renseigner ses paramètres et passe la réponse en variable
echo "Entrez votre identifiant pour accéder à votre partage réseau (PC ou NAS)"
echo "Ex: Eric"
read -p "Votre login: " LOGIN

echo "Entrez le mot de passe correspondant à l'identifiant précédemment saisi"
read -p "Votre mot de passe: " PASSWORD

echo "Collez le chemin réseau complet de votre partage"
echo " Vous devez spécifier l'adresse IP et non le hostname, exemple:"
echo "//192.168.1.2/nom_du_partage"
echo ""
read -p "Chemin: " NETWORK_PATH

#echo "Si voulez pointer un sous dossier dans le partage"
#read -p "indiquez le ici ou appuyez directement sur Entrée " DISTRIB

echo "sharenetwork_cmd1=mount.cifs -o username="$LOGIN",password="$PASSWORD" "$NETWORK_PATH/$DISTRIB" /recalbox/share"
read -p "Vérifier que le chemin est bon et appuyez sur entrée pour continuer"

#Passer le FS en écriture
mount -o remount,rw /boot

# me fatigue pas je sauvegarde puis j'écrase le fichier
cp /boot/recalbox-boot.conf $TOOLBOX_PATH/fichiers/conf/backup
cat /dev/null > /boot/recalbox-boot.conf
echo "sharedevice=NETWORK" >> /boot/recalbox-boot.conf
echo "sharenetwork_cmd1=mount.cifs -o username="$LOGIN",password="$PASSWORD" "$NETWORK_PATH/$DISTRIB" /recalbox/share" >> /boot/recalbox-boot.conf

echo "La configuration a été modifiée"
echo ""
more /boot/recalbox-boot.conf

echo "Le système a été modifié, il est nécessaire de faire un redémarrage pour prendre en compte le changement"
echo ""
read -p 'Appuyez sur Entrée pour continuer' 

}

############################# Fonction montage du partage NAS dans un FS dédié ###########################

MOUNT_NAS()
{
#Demande à l'utilisateur de renseigner ses paramètres et passe la réponse en variable
echo "Cette option permet de monter un autre FS indépendament du /recalbox/share"
echo "Cette option est utile pour copier directement vos ROMS entre un NAS et Recalbox"
echo "Vous pouvez également utiliser ce point de montage pour lire directement vos fichiers sur le réseau"
echo "
"

echo "Entrez un nom de dossier (sans espace, ni caractères spéciaux)"
echo "exemple: video_games"
read -p "Nom du répertoire: " DIRECTORY

echo "Entrez votre identifiant pour accéder à votre partage réseau (PC ou NAS)"
echo "Exemple: Eric"
read -p "Votre login: " LOGIN

echo "Entrez le mot de passe correspondant à l'identifiant précédemment saisi"
read -p "Votre mot de passe: " PASSWORD

echo "Collez le chemin réseau complet de votre partage"
echo " Vous devez spécifier l'adresse IP et non le hostname, exemple:"
echo "//192.168.1.2/nom_du_partage"
echo ""
read -p "Votre IP + nom partage: " IP_NAS

echo "Si voulez pointer un sous dossier dans le partage"
echo "indiquez le ici ou appuyez directement sur Entrée"
echo "Exemple: img_mount"
read -p "Nom du sous répertoire: " REPERTOIRE_PARTAGE

#passage de la partition en écriture
mount -o remount,rw /
echo "création du dossier qui servira de point de montage"
mkdir /$DIRECTORY
echo "Sauvegarde du FSTAB"
cp /etc/fstab $TOOLBOX_PATH/fichiers/conf/backup
echo "écriture dans le fichier de configuration"
echo ""
echo ""$IP_NAS/$REPERTOIRE_PARTAGE"  "/$DIRECTORY" cifs user="$LOGIN",password="$PASSWORD" ,uid=0,gid=0,rw 0 0" >> /etc/fstab
echo "Montage du FS"
mount -a
df -h |grep $DIRECTORY
read -p 'Appuyez sur Entrée pour continuer' 
}

REBOOT()
{
 echo "Patientez pendant le redémarrage de votre Recalbox ;)"
 $TOOLBOX_PATH/scripts/SYSTEM/Reboot.sh
}

while true
do
  #..........................................................................
  # affichage du Menu
  #..........................................................................
  clear
  echo "	MENU - Montage lecteur réseau


1) Monter votre partage réseau (NAS ou PC) dans /recalbox/share
2) Monter un partage réseau dans un FS dédié
3) Faire un redémarrage de Recalbox

0) Retour au menu principal

 Tapez le chiffre correspondant à votre choix puis appuyer sur Entrée"


  #..........................................................................
  # Appel des fonctions
  #..........................................................................
  read answer
  clear

  case "$answer" in

    [1]*) RECALBOX_SHARE;;
    [2]*) MOUNT_NAS;;
	[3]*) REBOOT;;

    [0]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichee dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done