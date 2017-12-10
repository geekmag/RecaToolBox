#! /bin/sh
##############################
# Menu mise à jour
# Geekmag.fr
#Build 02/12/2017


#déclaration des variables
CLOUD_PATH=http://geekmag78.free.fr/recalbox/recaltoobox/
UPDATE_NAME=toolbox_update.tar
UPDATE_DEPOT=package_update.tar

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
############### Fin menu téléchargement video #################

#################### Menu pour changer la video #################
MAJ_SOURCE_DL()
{
		cd $TOOLBOX_DOWNLOAD_PATH
		wget -N $CLOUD_PATH/$UPDATE_DEPOT

		#Décompression de l'archive
		tar -xf $UPDATE_DEPOT -C $TOOLBOX_DOWNLOAD_PATH
		rm -f $TOOLBOX_DOWNLOAD_PATH/$UPDATE_DEPOT
		echo "La liste des dépots a été mise à jour."

}
#################### Fin de la fonction pour changer la video #################

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