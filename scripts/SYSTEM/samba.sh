#!/bin/bash
#Script permettant de créer les partages réseaux
#06/12/2017
#Source GeekMag.fr

#Déclaration des variables
SAMBA_CONF=/etc/samba/smb.conf
SMB_NEW_SHARE=$TOOLBOX_PATH/fichiers/conf/smb_new_share.conf

echo "On vérifie si les partages ont déjà été déclarés"
PRESENCE=`grep RecaToolBox $SAMBA_CONF | wc -l`
if [ $PRESENCE == "0"  ]; then
    echo "Sauvegarde du fichier de conf Samba"
    cp -p $SAMBA_CONF $SAMBA_CONF.original

    echo "Arrêt du service Samba"
    /etc/init.d/S91smb stop

    echo "Création des nouveaux partages réseau de \\"$HOSTNAME
    more $SMB_NEW_SHARE >> $SAMBA_CONF

    echo "Démarrage du service Samba"
    /etc/init.d/S91smb start
else
    echo "Le paramétrage a déjà été effectué, on sort"
fi
