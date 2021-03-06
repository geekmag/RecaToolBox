#!/bin/bash
##############################
# Ajout d'une collection de jeux
# ROM + THEME + fichier de conf ES
# Geekmag.fr
#Build 09/12/2017


#déclaration des variables
#Chemin du fichier de paramètre Recalbox
ES_SYSTEMS_PATH=/recalbox/share_init/system/.emulationstation
#chemin vers les thèmes
THEME_PATH=/recalbox/share/system/.emulationstation/themes
#chemin vers répertoire téléchargement de la usertoolbox
COLLECTION_PATH=$TOOLBOX_DOWNLOAD_PATH/Collection
COLLECTION_DL=$COLLECTION_PATH/source

#chemin vers les roms
ROM_PATH=/recalbox/share/roms

#Test l'espace libre sur le FS
FREESPACE=$(df -h /recalbox/share | awk '{print $4}' | tail -n 1)

#remonte le FS en lecture écriture
mount -o remount,rw /

############### Début menu téléchargement d'une collection de jeux #################
DL_COLLECTION()
{
#on se place dans le dossier contenant la liste des fichiers txt contenant les info relatives
cd $COLLECTION_DL
#Pour éviter les problèmes de caractères
dos2unix $COLLECTION_DL/*/*

# invite de commande pour choisir l'option du select
PS3="Entrez le numéro correspondant à la collection de jeux que vous voulez ajouter sur l'écran d'acceuil Emulation Station ou tapez 'retour' pour sortir du menu: "

# Permet à l'utilisateur de choisir une collection en générant une liste de tous les fichiers .txt contenant les URL de téléchargement
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
	source  $COLLECTION_DL/$filename
	# On crée le répertoire de téléchargement s'il n'existe pas déjà
	if [[ ! -d $COLLECTION_PATH/$FILE_PATH ]]
	then
	    mkdir $COLLECTION_PATH/$FILE_PATH
	fi
	# On se place dans le répertoire de téléchargement
	cd $COLLECTION_PATH/$FILE_PATH
	# On affiche l'interface utilisateur
	echo "Vous allez télécharger le pack: $COLLECTION_FOLDER" 
	echo "Cette collection est proposée par:" $AUTHOR
	echo "Ce téléchargement va se faire par:" $TYPE_LINK
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
					wget http://$DOWNLOAD_URL_COLLECTION
			elif [ $TYPE_LINK = FTP ]
				then
					echo "Lancement du téléchargement via FTP"
					wget --user=$FTP_LOGIN --password=$FTP_PASSWORD ftp://$DOWNLOAD_URL_COLLECTION
			else
				echo "Le type de lien n'est pas configuré, téléchargement impossible"
			fi
	
	echo "Votre pack a bien été téléchargé"
	echo "Retourner au menu précédent et faire choix 2 pour installer ce pack sur EmulationStation"
    # Il y aura un nouveau choix de proposé sauf si on stop la boucle
    break
done

}
############### Fin menu téléchargement Collection de jeux #################

#################### Menu pour modifier le fichier es_systems.cfg #################
SCAN_COLLECTION()
{
echo "Seul les collection déposées préalablement dans le partage réseau de Recalbox apparaisse ici"
echo "$COLLECTION_PATH"
#On se place dans le dossier contenant les collections de jeux
cd $COLLECTION_DL

#On génère une liste des packs de ROMS qui ont déjà été téléchargés
AVAILABLE_COLLECTIONS=()
for filename in */*.txt
do
    FILE_BASENAME=${filename##*/}
	FILE_PATH=${filename%/*}
    source $COLLECTION_DL/$filename
    # Ici la variable ARCH_ROMS_NAME devrait être complétée avec le nom de l'archive à utiliser
    # Si elle ne l'est pas, on sort
    if [ -z $ARCH_COLLECTION_NAME ]; then
        continue
    fi
    # On teste la présence de l'archive
    if [ -f $COLLECTION/$FILE_PATH/$ARCH_COLLECTION_NAME ]; then
        AVAILABLE_COLLECTIONS+=("$filename")
    fi
done

# invite de commande pour choisir l'option du select
PS3="Entrez le numéro correspondant à la collection de jeux que vous voulez ajouter à EmulationStation ou tapez 'retour' pour sortir du menu: "

# Permet à l'utilisateur de choisir une archive tar en générant une liste de tous les fichiers *.tar
select filename in ${AVAILABLE_COLLECTIONS[@]}
do
    # quitte la boucle si l'utilisater met 'retour'
    if [[ "$REPLY" == retour ]]; then break; fi

    # Affiche un message d'erreur si choix invalide et boucle pour demander à nouveau
    if [[ "$filename" == "" ]]
    then
        echo "'$REPLY' n'est pas un numéro valide"
        continue
    fi
    FILE_BASENAME=${filename##*/}
	FILE_PATH=${filename%/*}
	# On charge les variables du fichier externe
	source  $COLLECTION_DL/$filename
    # maintenant on peut travailler sur le fichier d'archive en utilsiant le fichier de conf
	echo "Décompression de l'archive $ARCH_COLLECTION_NAME"
	ls -lh $COLLECTION_PATH/$FILE_PATH/$ARCH_COLLECTION_NAME
	echo "Description du pack $COLLECTION_FOLDER en cours d'installation dans EmulationStation"
	echo $PACK_DESCRIPTION
	echo "Le pack contient un thème: $THEME_NAME"
	echo "ainsi qu'un fichier $ADD_NEW_ES_SYS qui permet d'ajouter cette collection sur l'écran d'accueil d'EmulationStation"


		tar xvf $COLLECTION_PATH/$FILE_PATH/$ARCH_COLLECTION_NAME -C $COLLECTION_PATH/$FILE_PATH
		echo "Copie du thème "$THEME_NAME" en cours..."
		echo "de "$COLLECTION_PATH/$FILE_PATH/$COLLECTION_FOLDER/$THEME_NAME" vers "$THEME_PATH""
		mv "$COLLECTION_PATH/$FILE_PATH/$COLLECTION_FOLDER/$THEME_NAME" $THEME_PATH
		echo "sauvegarde du fichier de conf ES SYSTEMS initial"
		cp $ES_SYSTEMS_PATH/es_systems.cfg $ES_SYSTEMS_PATH/es_systems.cfg.back
		echo "Modification du $ES_SYSTEMS_PATH/es_systems.cfg en cours"
		cd $COLLECTION_PATH/$FILE_PATH/$COLLECTION_FOLDER
		sed '/<systemList>/r '$ADD_NEW_ES_SYS'' $ES_SYSTEMS_PATH/es_systems.cfg > $COLLECTION_PATH/$FILE_PATH/$COLLECTION_FOLDER/temp_$ADD_NEW_ES_SYS && cp temp_$ADD_NEW_ES_SYS $ES_SYSTEMS_PATH/es_systems.cfg
		echo "Le fichier a bien été modifié"
		ls -l $ES_SYSTEMS_PATH/es_systems.cfg
		rm -f temp_$ADD_NEW_ES_SYS $ADD_NEW_ES_SYS
		echo "Déplacement du pack de ROMS, patientez quelques instants"
		mv $COLLECTION_PATH/$FILE_PATH/$COLLECTION_FOLDER $ROM_PATH
		echo "Allez dans le menu Emulationstation et sélectionnez le thème $THEME_NAME"
		echo "Redémarrez votre recalbox et admirez ;)"

    # Il y aura un nouveau choix de proposé sauf si on stop la boucle
    break
done
}
#################### Fin de la fonction pour installer la collection #################


while true
do
  #..........................................................................
  # affichage
  #..........................................................................
  clear
  echo "Choississez l'option de votre choix pour modifier la vidéo qui s'affiche au démarrage de votre Recalbox


1) Télécharger une collection de jeux
2) Installer la collection sur l'écran d'accueil EmulationStation

R) Retour au menu principal

Tapez le chiffre correspondant à votre choix puis appuyer sur Entrée"

  #..........................................................................
  # Appel des fonctions
  #..........................................................................
  read answer
  clear

  case "$answer" in

    [1]*) DL_COLLECTION;;
    [2]*) SCAN_COLLECTION;;

    [Rr]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichée dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done
