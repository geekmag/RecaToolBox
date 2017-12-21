#!/bin/bash
#Script permettant de monter un fichier .img
# Utile pour extraire des ROMS depuis une image préconfigurée trouvée sur le net
#Date de création: 20/10/2017
#Dernière modification: 17/12/2017
#Autheur: Eric de GeekMag.fr

#Variable: pointe vers le fichier contenant les chemins des points de montage des images
MOUNT_CONF=$TOOLBOX_HOME/ToolBox/fichiers/conf/mount_IMG.txt

#passage de la FS en écriture
mount -o remount,rw /

# Si un fichier de conf existe, il est sourcé pour récupérer les variables, si non prompt de l'utilisateur pour lui demander de renseigner les valeurs
# une fois les valeurs récupérées, elle seront inscrite dans le fichier de conf 


if [ -f $MOUNT_CONF ];
	then
		echo "Le fichier de conf existe déjà"
		source $MOUNT_CONF
		echo "Vos fichiers images sont stockés ici:"
		echo $DIR_IMG
		echo ""
		echo "Une fois monté, vous pouvez lire le contenu des images préconfigurées ici:"
		echo $IMG_MOUNT
		echo ""
	
	else

		echo "Veuillez indiquer l'arborescence complète pour accéder au dossier stockant vos fichiers .img"
		echo "Exemple: /video_games/IMG_SYSTEM"
		echo ""
		read -p "Coller le chemin complet: " DIR_IMG
		echo ""
		echo "Veuillez indiquer l'arborescence complète ou le point de montage doit être créé .img"
		echo "Exemple: /img_ready"
		echo ""
		read -p "Coller le chemin complet: " IMG_MOUNT

		echo "DIR_IMG="$DIR_IMG"" >> $MOUNT_CONF
		echo "DIR_IMG="$IMG_MOUNT"" >> $MOUNT_CONF
fi

cd $DIR_IMG
echo "Scan des fichiers ./img disponible"
echo "Patientez cela peut prendre quelques instant"
clear
#on recherche tous les fichiers avec l'extension img, on trie et on supprime les caractère ./ pour un affichage propre
echo "Liste des fichiers images dispo:"
echo
find ./ -name "*.img" |sort -n |cut -c3-

echo ""
read -p "Copiez le nom du fichier .img à monter: " NOM_IMG

FILE_EXT=$(awk -F'.' '{print $NF}' <<< $NOM_IMG)
if [ "img" = "$FILE_EXT" ] 
	then
		echo "Le fichier porte bien l'extension .img"
	else
		echo "L'image n' pas la bonne extension. Décompressez l'image avant de poursuivre"
	exit
fi

fdisk -lu "$DIR_IMG/$NOM_IMG"

#On test que la valeur n'est pas vide et si elle est bien numérique
while [ -z $CYLINDRE ] || [ $CYLINDRE != "$(echo $CYLINDRE | grep "^[ [:digit:] ]*$")" ]

	do
       read -p "Rentrez la valeur de la colonne Start correspondant à la partition à monter: " CYLINDRE
		
	if [ -z $CYLINDRE ] || [ $CYLINDRE != "$(echo $CYLINDRE | grep "^[ [:digit:] ]*$")" ]
	
	then 
		echo
		echo "$CYLINDRE n'est pas une chaîne numérique valide" 
		echo "Vous devez rentrer uniquement des chiffres"
		echo
	else
		echo "block N° $CYLINDRE"
	fi
done

# On fait le calcul
#echo "N° CYLINDRE * taille secteur = $((CYLINDRE * 512))"
OFFSET=$((CYLINDRE * 512))

#On test si le dossier existe et boucle tant que l'utilisateur ne choisit pas un autre nom que celui d'un dossier déjà existant

while  [ -d $IMG_MOUNT/$DOSSIER ];

	do
       read -p "Entrez le nom du dossier à créer pour monter l'image: " DOSSIER

	if [ -d $IMG_MOUNT/$DOSSIER ];
	
	then
		echo "Ce dossier existe déjà! Essayez un autre nom (ou supprimer le avant)";
		echo
	else
		echo "Le dossier $DOSSIER qui va servir de point de montage pour l'image va être créé"
		mkdir $IMG_MOUNT/$DOSSIER
		echo
		echo "Pour l'instant le dossier est vide"
		ls -l $IMG_MOUNT/$DOSSIER
		break
	fi
done

#Cette commande fonctionne sous Debian mais pas BusyBox
mount -o loop,offset="$OFFSET $DIR_IMG/$NOM_IMG" "$IMG_MOUNT"/"$DOSSIER"

echo "L'image a été montée avec succès dans:"
ls -ld $IMG_MOUNT | grep $DOSSIER
echo ""
echo "Pour démonter l'image, tapez:"
echo "umount" $IMG_MOUNT/$DOSSIER