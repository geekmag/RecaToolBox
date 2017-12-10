#!/bin/bash
# Script permettant de télécharger des themes
# http://www.geekmag.fr/recatoolbox/ pour la version mise à jour
# 27/11/2017

###########   déclaration des variables ####################

#chemin vers répertoire téléchargement de la usertoolbox
THEME_REP=/recalbox/share/system/.emulationstation/themes
THEME_PATH=/recalbox/share/RecaToolBox/Download/Themes
THEMES_DL=$THEME_PATH/source

#Test l'espace libre sur le FS
FREESPACE=$(df -h /recalbox/share | awk '{print $4}' | tail -n 1)

#récupére l'ensemble du contenu du FTP
#wget -r -l 0 ftp://www.domaine.example/chemin/* --ftp-user=nom_user --ftp-password=password -nH --cut-dirs=1

#récupérer un fichier par FTP
#wget ftp://$FTP_LOGIN:$FTP_PASSWORD@$FTP_ADRESSE/chemin/$ROM_COLLECTION

# Début section téléchargementdes packs de roms

DOWNLOAD_THEMES()
{

#on se place dans le dossier contenant la liste des fichiers txt contenant les info relatives au téléchargement
cd $THEMES_DL
#Pour éviter les problèmes de caractères
dos2unix $THEMES_DL/*.txt

# invite de commande pour choisir l'option du select
PS3="Entrez le numéro correspondant à nom du thème que vous voulez télécharger ou tapez 'retour' pour sortir du menu: "

# Permet à l'utilisateur de choisir un pack de ROMS en générant une liste de tous les fichiers .txt contenant les URL de téléchargement
select filename in *.txt
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
	# On charge les variables du fichier externe
	source  $THEMES_DL/$filename
	# On se place dans le répertoire de téléchargement
	cd $THEME_PATH
	# On affiche l'interface utilisateur
	echo "Vous allez télécharger le thème: $THEME_NAME" 
	echo "Ce thème est proposé par:" $AUTHOR
	echo "Ce téléchargement va se faire par:" $TYPE_LINK
	echo ""
	echo "Voici ce que contient le pack:"
	echo "$THEME_DESCRIPTION"
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
					wget http://$DOWNLOAD_URL_THEME
			elif [ $TYPE_LINK = FTP ]
				then
					echo "Lancement du téléchargement via FTP"
					wget --user=$FTP_LOGIN --password=$FTP_PASSWORD ftp://$DOWNLOAD_URL_THEME
			else
				echo "Le type de lien n'est pas configuré, téléchargement impossible"
			fi
	
	echo "Votre thème a bien été téléchargé"
	echo "Retourner au menu précédent et faire choix 2 pour décompresser le thème"
    # Il y aura un nouveau choix de proposé sauf si on stop la boucle
    break
done

}

# Fin section téléchargementdes packs de roms

# Début section décompression des packs de roms

DEPLOY_THEMES()
{

echo "Seul les thèmes déposés préalablement dans le partage réseau de Recalbox apparaissent ici"
echo "$THEME_PATH"
#On se place dans le dossier contenant les collections de jeux
cd $THEMES_DL

#On génère une liste des thèmes qui ont déjà été téléchargés
AVAILABLE_THEMES=()
for filename in *.txt
do
    source $THEMES_DL/$filename
    # Ici la variable ARCH_THEME_NAME devrait être complétée avec le nom de l'archive à utiliser
    # Si elle ne l'est pas, on sort
    if [ -z $ARCH_THEME_NAME ]; then
        continue
    fi
    # On teste la présence de l'archive
    if [ -f $THEME_PATH/$ARCH_THEME_NAME ]; then
        AVAILABLE_THEMES+=("$filename")
    fi
done

# invite de commande pour choisir l'option du select
PS3="Entrez le numéro correspondant au thème que vous voulez ajouter à EmulationStation ou tapez 'retour' pour sortir du menu: "

# Permet à l'utilisateur de choisir une archive tar en générant une liste de tous les fichiers *.tar
select filename in ${AVAILABLE_THEMES[@]}
do
    # quitte la boucle si l'utilisater met 'retour'
    if [[ "$REPLY" == retour ]]; then break; fi

    # Affiche un message d'erreur si choix invalide et boucle pour demander à nouveau
    if [[ "$filename" == "" ]]
    then
        echo "'$REPLY' n'est pas un numéro valide"
        continue
    fi

	# On charge les variables du fichier externe
	source  $THEMES_DL/$filename
    # maintenant on peut travailler sur le fichier d'archive en utilsiant le fichier de conf
	echo "Décompression de l'archive $ARCH_THEME_NAME"
	ls -lh $THEME_PATH/$ARCH_THEME_NAME
	echo "Description du pack $PACK_NAME en cours de copie"
	echo $THEME_DESCRIPTION

    # Si le répertoire de destination est fourni dans le fichier de configuration, on l'utilise
    # dans le cas contraire, on utlise le path par défaut
    if [ -n "$THEME_FOLDER" ]; then
        tar xvf $THEME_PATH/$ARCH_THEME_NAME -C $THEME_FOLDER
    else
        tar xvf $THEME_PATH/$ARCH_THEME_NAME -C $THEME_REP
    fi
	echo "Le thème a été installé: allez dans l'interface EmulationStation pour le sélectionner"
	
    # Il y aura un nouveau choix de proposé sauf si on stop la boucle
    break
done
}


# Fin section décompression des packs de roms

while true
do
  #..........................................................................
  # affichage du menu téchargement de Thèmes pour ES
  #..........................................................................
  clear
  echo "Téléchargement de Thèmes


 1) Télécharger un thème pour EmulationStation
 2) Décompresser un thème

 R)  Retour au menu principal

 Tapez le chiffre correspondant à votre choix
 puis appuyer sur Entrée"


  #Appel des fonctions

  read answer
  clear

  case "$answer" in

    [1]*) DOWNLOAD_THEMES;;
    [2]*) DEPLOY_THEMES;;

    [Rr]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichée dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done