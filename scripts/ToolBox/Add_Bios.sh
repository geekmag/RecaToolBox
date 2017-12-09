#!/bin/bash
#Script permettant de configurer dans Recalbox
#Version beta 0.1
# RDV sur geekmag.fr/recalbox/ pour la version mise à jour
#26/11/2017


#Nom de l'archive à récupérer
BIOS_COLLECTION=all_bios.tar

#Chemin ou va être décompressé l'archive
BIOS_PATH=/recalbox/share/bios

#Chemin ou va être téléchargé l'archive
DOWNLOAD_PATH=/recalbox/share/extractions

echo "Téléchargement du pack contenant tous les BIOS"

#récupérer un fichier par URL HTTP
cd $DOWNLOAD_PATH
wget http://geekmag78.free.fr/recalbox/bios/$BIOS_COLLECTION

#Décompression de l'archive
tar -xvf $BIOS_COLLECTION -C $BIOS_PATH

echo "Téléchargement des rom terminés"
echo "Ouvrez votre navigateur à l'adresse http://recalbox.local/bios"
echo "Tous les bios sont maintenant disponible"