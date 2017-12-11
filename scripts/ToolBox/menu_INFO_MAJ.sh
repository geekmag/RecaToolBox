#! /bin/sh
##############################
# Menu mise à jour
# Geekmag.fr
#Build 02/12/2017


#déclaration des variables
CLOUD_PATH=http://geekmag78.free.fr/recalbox/recaltoobox/
UPDATE_NAME=toolbox_update.tar

DEPOTS_PATH=$TOOLBOX_DOWNLOAD_PATH/Depots
DEPOTS_DL=$DEPOTS_PATH/source

#Test l'espace libre sur le FS
FREESPACE=$(df -h /recalbox/share | awk '{print $4}' | tail -n 1)

#remonte le FS en lecture écriture
mount -o remount,rw /

############### Début menu téléchargement MAJ RecalToolBox #################
DL_MAJ_TOOLBOX()
{
read -p "Etes vous sur de vouloir télécharger la MAJ de la RecalToolBox (O ou N)? " -n 1 -r
echo ""
echo    "Dommage il y avait surement plein de nouvelles fonctions au top ^^"
if [[ $REPLY =~ ^[OoYy]$ ]]
then
    echo "Youpi! C'est parti, y aura peut être une nouvelle interface web de ouf dans cette MAJ?"
		cd $TOOLBOX_DOWNLOAD_PATH
		wget -N $CLOUD_PATH/$UPDATE_NAME

		#Décompression de l'archive
		tar -xf $UPDATE_NAME -C $TOOLBOX_PATH
		rm -f $TOOLBOX_DOWNLOAD_PATH/$UPDATE_NAME
		echo "La Recalttobox a été mise à jour."
fi
}
############### Fin menu téléchargement MAJ RecalToolbox #################

############### Menu pour télécharger de nouvelles sources #################
# Le téléchargement se fait en regardant les dépots disponible dans le fichier repository.txt

MAJ_SOURCE_DL()
{
	cd $DEPOTS_PATH

	while read ligne
	do
	set $(echo $ligne)
	DEPOT_NAME=$(eval echo $1)
	URL_SOURCE=$(eval echo $2)
	ARCH_NAME=$(eval echo $3)

echo "Téléchargement de nouvelles sources depuis le dépot de $DEPOT_NAME"
wget -N $URL_SOURCE/$ARCH_NAME

echo "Extraction des nouveaux fichiers sources en cours"
	tar xvf $ARCH_NAME -C $TOOLBOX_DOWNLOAD_PATH

done < $DEPOTS_DL/repository.txt

		echo "La liste des dépots a été mise à jour."		

}
#################### Fin de la fonction téléchargement de nouvelels sources #################

#################### Début modif durée vidéo ##################################
LIST_GAMES()
{
 echo "Une liste de tous les jeux installés est en cours de création"
 ls -R /recalbox/share/roms > $TOOLBOX_HOME/liste_Jeux.txt
 clear
 echo "La liste a été créée dans le partage réseau ;) "
 ls -lh $TOOLBOX_HOME/liste_Jeux.txt
 
 read -p "Appuyez sur une touche pour continuer"
}

while true
do
  #..........................................................................
  # affichage
  #..........................................................................
  clear
  echo "


1) Mettre à jour la RecalToolBox
2) Mettre à jour la sources de téléchargement (Roms / Themes...)
3) Générer une liste des jeux installés

R) Retour au menu principal

Tapez le chiffre correspondant à votre choix puis appuyer sur Entrée"

  #..........................................................................
  # Appel des fonctions
  #..........................................................................
  read answer
  clear

  case "$answer" in

    [1]*) DL_MAJ_TOOLBOX;;
    [2]*) MAJ_SOURCE_DL;;
	[3]*) LIST_GAMES;;

    [Rr]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichee dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done
