#!/bin/bash
#Script permettant d'importer les données d'un périphérique USB vers la mémoire interne (ex: sur la SD d'un Raspberry Pi)
# Création : 16/12/2017
#Source GeekMag.fr


#On utilise la version modifée du script natifs de Recalbox
cd $TOOLBOX_PATH/scripts/SYSTEM/

echo "Branchez la clé USB ou le disque dur externe depuis lequel vous voulez importer les données"
echo "A la racine de votre périphérique USB (clé ou disque dur) doit se trouver un dossier nommé recalbox"
echo "ce dernier doti contenier l'arborescence habitudelle: bios, roms, system..."
echo "Assurez-vous d'avoir l'espace dans /recalbox/share avant de continuer la copie"
echo ""
read -p "Appuyez sur une touche pour lancer la copie" GOBACKUP
clear

echo "Liste des périphérique USB"
echo "identifiant UUID | Nom "
./recalbox-sync.sh list
echo ""
echo "Entrez l'UUID correspondant au périphérique USB que vous voulez sauvegarder"
read -p "Coller la valeur de la colonne du milieu: " USB_DEVICE
echo ""
echo "Cette opération de synchronistation USB -> /recalbox/share interne peut prendre du temps..."
./recalbox-sync.sh sync $USB_DEVICE