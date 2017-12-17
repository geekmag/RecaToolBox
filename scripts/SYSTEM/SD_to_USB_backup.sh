#!/bin/bash
#Script permettant de sauvegarder les données de la SD vers un périphérique USB
# Création : 16/12/2017
#Source GeekMag.fr

#Test l'espace utilisé
USED_SPACE=$(df -h /recalbox/share | awk '{print $3}' | tail -n 1)

#On utilise le script natifs de Recalbox
cd /recalbox/scripts/

echo "Branchez une clé USB ou un disque dur externe"
echo "Assurez-vous d'avoir l'espace nécessaire pour la sauvegarde"
echo "Vous devez disposez de $USED_SPACE sur votre périphérique USB"
echo ""
echo "Cette option n'efface pas votre périphérique"
echo "Un dossier recalbox sera créé un dossier à la racine"
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
echo "Cette opération de synchronistation SD -> USB peut prendre du temps..."
./recalbox-sync.sh sync $USB_DEVICE