#!/bin/bash
##############################
# Configuration de moonlight
# Geekmag.fr
#Build 02/12/2017


#déclaration des variables
VIDEO_INTRO_PATH=$TOOLBOX_DOWNLOAD_PATH/video_intro
VIDEO_INTRO_DL=$VIDEO_INTRO_PATH/source
SPLASH_PATH=/recalbox/system/resources/splash

#Test l'espace libre sur le FS
FREESPACE=$(df -h /recalbox/share | awk '{print $4}' | tail -n 1)

#remonte le FS en lecture écriture
mount -o remount,rw /

############### Début menu téléchargement video #################
DL_VIDEO()
{
#on se place dans le dossier contenant la liste des fichiers txt contenant les info relatives
cd $VIDEO_INTRO_DL
#Pour éviter les problèmes de caractères
dos2unix $VIDEO_INTRO_DL/*/*.txt

# invite de commande pour choisir l'option du select
PS3="Entrez le numéro correspondant à la vidéo que vous voulez télécharger au démarrage de Recalbox ou tapez 'retour' pour sortir du menu: "

# Permet à l'utilisateur de choisir une video en générant une liste de tous les fichiers .txt contenant les URL de téléchargement
select filename in */*.txt
do
    # quitte la boucle si l'utilisater met 'retour'
    if [[ "$REPLY" == retour ]]; then break; fi

    # Affiche un message d'erreur si choix invalide et boucle pour demander à nouveau
    if [[ "$filename" == "" ]]
    then
        echo "'$REPLY' n'est pas un numéro valide"
        continue
    fi

    # maintenant on peut travailler sur le fichier txt sélectionné contenant les info sur l'archive à télécharger
	# le nom de fichier est récupéré en variable
	FILE_BASENAME=${filename##*/}
	FILE_PATH=${filename%/*}
	# On charge les variables du fichier externe
	source  $VIDEO_INTRO_DL/$filename
	# On crée le répertoire de téléchargement s'il n'existe pas déjà
	if [[ ! -d $VIDEO_INTRO_PATH/$FILE_PATH ]]
	then
	    mkdir $VIDEO_INTRO_PATH/$FILE_PATH
	fi
	# On se place dans le répertoire de téléchargement
	cd $VIDEO_INTRO_PATH/$FILE_PATH
	# On affiche l'interface utilisateur
	echo "Vous allez télécharger la vidéo: $VIDEO_TITLE" 
	echo "Cette video est proposée par:" $AUTHOR
	echo "Cette video va se faire par:" $TYPE_LINK
	echo ""
	echo "Voici ce que contient le pack:"
	echo "$PACK_DESCRIPTION"
	if [ -n "$YOUTUBE" ]; then
        echo "Présentation dispo sur Youtube à l'URL suivante:"
        echo "$YOUTUBE"
    fi
	echo "Le fichier nécessite $ARCH_SIZE d'espace disque"
	echo "Il vous reste actuelement $FREESPACE d'espace libre"
	#On affiche un choix pour demander confirmation du téléchargement
			echo -n "Voulez-vous lancer le téléchargement (o/n)? "
			read CONFIRMATION

			case "$CONFIRMATION" in
			o|O)
			echo "Vérification du lien de téléchargement";;
			n|N)
			echo "Abandon du téléchargement"
			exit 1;;
			esac
	#On test si le téléchargement se fait en http ou via une connexion FTP
			if [ $TYPE_LINK = HTTP ]
				then
					echo "Lancement du téléchargement via HTTP"
					wget http://$DOWNLOAD_URL_VIDEO
			elif [ $TYPE_LINK = FTP ]
				then
					echo "Lancement du téléchargement via FTP"
					wget --user=$FTP_LOGIN --password=$FTP_PASSWORD ftp://$DOWNLOAD_URL_VIDEO
			else
				echo "Le type de lien n'est pas configuré, téléchargement impossible"
			fi
	
	echo "Votre vidéo a bien été téléchargée"
	echo "Retourner au menu précédent et faire choix 2 pour configurer cette vidéo en tant qu'intro de démarrage"
    # Il y aura un nouveau choix de proposé sauf si on stop la boucle
    break
done

}
############### Fin menu téléchargement video #################

#################### Menu pour changer la video #################
SCAN_VIDEO()
{
echo "Seul les vidéos déposées préalablement dans le partage réseau de Recalbox apparaisse ici"
echo "$VIDEO_INTRO_PATH"
#On se place dans le dossier contenant les vidéos
cd $VIDEO_INTRO_PATH

# invite de commande pour choisir l'option du select
PS3="Entrez le numéro correspondant à la vidéo que vous voulez diffuser au démarrage de Recalbox ou tapez 'retour' pour sortir du menu: "

# Permet à l'utilisateur de choisir une video en générant une liste de tous les fichiers .mp4
select filename in */*.mp4
do
    # quitte la boucle si l'utilisater met 'retour'
    if [[ "$REPLY" == retour ]]; then break; fi

    # Affiche un message d'erreur si choix invalide et boucle pour demander à nouveau
    if [[ "$filename" == "" ]]
    then
        echo "'$REPLY' n'est pas un numéro valide"
        continue
    fi

    # maintenant on peut travailler sur la vidéo sélectionnée et utiliser le nom passé en variable
	echo "$filename va être utilisée comme vidéo d'intro"

		ls -l $VIDEO_INTRO_PATH/$filename
		
		############ Sauvegarde de la vidéo d'intro #####################
	
		echo "Vérification de la vidéo d'intro actuelement utilisée"
		$TOOLBOX_PATH/scripts/EmulationStation/Check_SYMLINK_Intro_Video.sh
		echo "Remplacement de la vidéo en cours"
		echo "Patientez. La durée de copie varie en fonction de la taille de votre vidéo"
		cp $VIDEO_INTRO_PATH/$filename $SPLASH_PATH/recalboxintro.mp4
		echo "Votre nouvelle vidéo d'intro a bien été mise en place :)"
		ls -l $SPLASH_PATH |grep *.mp4
		echo "Redémarrez pour l'admirer ;)"

    # Il y aura un nouveau choix de proposé sauf si on stop la boucle
    break
done
}
#################### Fin de la fonction pour changer la video #################

#################### Début modif durée vidéo ##################################
VIDEO_TIME()
{
 echo "ATTENTION: il s'agit d'une bidouille"
 echo "Si vous souhaitez que cette fonction soit correctement implémentée"
 echo "Il faut solliciter les dev et faire une requête sur le GitHub de RecalBox"
 echo ""
 echo "La valeur actuelle correspondant au nombre à la fin de la ligne ci-dessous"
 more /etc/init.d/S02splash |grep "emulationstation.ready" |head -n 1
 read -p "Veuillez entrer la valeur que vous voyez dans la ligne ci-dessus (200 par défaut): " VIDEO_LENGHT_ORIGINAL
 echo ""
 echo "Si vous voulez doubler la durée de la vidéo de démarrage, tapez par exemple: 400"
 read -p "Veuillez entrer la valeur souhaitée: " VIDEO_LENGHT
 sed -i 's/'$VIDEO_LENGHT_ORIGINAL'/'$VIDEO_LENGHT'/g' /etc/init.d/S02splash
 echo ""
 echo "La valeur a été modifiée"
 more /etc/init.d/S02splash |grep $VIDEO_LENGHT
 echo ""
 echo "Tu peux redémarrer pour voir ta vidéo ;)"

}

while true
do
  #..........................................................................
  # affichage
  #..........................................................................
  clear
  echo "Choisissez l'option de votre choix pour modifier la vidéo qui s'affiche au démarrage de votre Recalbox


1) Télécharger une vidéo d'intro
2) Choisir directement une vidéo déposée dans le partage Recalbox
3) Modifier la durée de la vidéo d'intro

R) Retour au menu principal

Tapez le chiffre correspondant à votre choix puis appuyer sur Entrée"

  #..........................................................................
  # Appel des fonctions
  #..........................................................................
  read answer
  clear

  case "$answer" in

    [1]*) DL_VIDEO;;
    [2]*) SCAN_VIDEO;;
	[3]*) VIDEO_TIME;;

    [Rr]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichée dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done