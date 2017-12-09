#!/bin/bash
#Script de désinstalation de la Recaltoolbox
#by GeekMag.fr
#Version 1.0
#21/11/2017
##########################################################

#Déclaration des variables
GEEK_MENU=/recalbox/scripts/geekmag_menu
TOOLBOX_USER=/recalbox/share/RecaToolBox
SAMBA_CONF=/etc/samba/smb.conf

#Passer le FS est écriture
mount -o remount,rw /

echo "Suppression des variables d'environnements"
cat /dev/null > /recalbox/share/system/.profile
unalias menu

echo "suppresion des fichiers du menu"
rm -rf $GEEK_MENU
echo "suppression des données utilisateur dans toolbox utilisateur"
rm -rf $TOOLBOX_USER

echo "Arrêt du service Samba"
/etc/init.d/S91smb stop

echo "Suppresion des partages réseau de "$HOSTNAME
rm $SAMBA_CONF
mv $SAMBA_CONF.original $SAMBA_CONF

echo "Démarrage du service Samba"
/etc/init.d/S91smb start

echo "Désinstallation effectuée"
echo "Rendez-vous sur geekmag.fr/recalbox si vous souhaitez ré-installer"