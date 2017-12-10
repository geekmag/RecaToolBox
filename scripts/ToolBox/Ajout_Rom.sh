#!/bin/bash
# Script permettant de télécharger des jeux
# http://www.geekmag.fr/recatoolbox/ pour la version mise à jour
# 27/11/2017

###########   déclaration des variables ####################

#chemin vers répertoire téléchargement de la usertoolbox
ROMS_REP=/recalbox/share/roms
ROMS_PATH=$TOOLBOX_DOWNLOAD_PATH/Roms
ROMS_DL=$ROMS_PATH/source

#Test l'espace libre sur le FS
FREESPACE=$(df -h /recalbox/share | awk '{print $4}' | tail -n 1)

#récupére l'ensemble du contenu du FTP
#wget -r -l 0 ftp://www.domaine.example/chemin/* --ftp-user=nom_user --ftp-password=password -nH --cut-dirs=1

#récupérer un fichier par FTP
#wget ftp://$FTP_LOGIN:$FTP_PASSWORD@$FTP_ADRESSE/chemin/$ROM_COLLECTION

# Début section téléchargementdes packs de roms

DOWNLOAD_ROMS()
{

#on se place dans le dossier contenant la liste des fichiers txt contenant les info relatives au téléchargement
cd $ROMS_DL
#Pour éviter les problèmes de caractères
dos2unix $ROMS_DL/*.txt

# invite de commande pour choisir l'option du select
PS3="Entrez le numéro correspondant à packs de ROMS que vous voulez télécharger ou tapez 'retour' pour sortir du menu: "

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
	source  $ROMS_DL/$filename
	# On se place dans le répertoire de téléchargement
	cd $ROMS_PATH
	# On affiche l'interface utilisateur
	echo "Vous allez télécharger le pack: $COLLECTION_FOLDER" 
	echo "Cette collection est proposée par:" $AUTHOR
	echo "Ce téléchargement va se faire par:" $TYPE_LINK
	echo ""
	echo "Voici ce que contient le pack:"
	echo "$ROM_DESCRIPTION"
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
	echo "Retourner au menu précédent et faire choix 2 pour décompresser ce pack de ROMS"
    # Il y aura un nouveau choix de proposé sauf si on stop la boucle
    break
done

}

# Fin section téléchargementdes packs de roms

# Début section décompression des packs de roms

DEPLOY_ROMS()
{

echo "Seul les packs de ROMS déposées préalablement dans le partage réseau de Recalbox apparaissent ici"
echo "$ROMS_PATH"
#On se place dans le dossier contenant les collections de jeux
cd $ROMS_DL

#On génère une liste des packs de ROMS qui ont déjà été téléchargés
AVAILABLE_ROMS=()
for filename in *.txt
do
    source $ROMS_DL/$filename
    # Ici la variable ARCH_ROMS_NAME devrait être complétée avec le nom de l'archive à utiliser
    # Si elle ne l'est pas, on sort
    if [ -z $ARCH_ROMS_NAME ]; then
        continue
    fi
    # On teste la présence de l'archive
    if [ -f $ROMS_PATH/$ARCH_ROMS_NAME ]; then
        AVAILABLE_ROMS+=("$filename")
    fi
done


# invite de commande pour choisir l'option du select
PS3="Entrez le numéro correspondant à la collection de jeux que vous voulez ajouter à EmulationStation ou tapez 'retour' pour sortir du menu: "

# Permet à l'utilisateur de choisir une archive tar en générant une liste de tous les fichiers *.tar
select filename in ${AVAILABLE_ROMS[@]}
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
	source  $ROMS_DL/$filename
    # maintenant on peut travailler sur le fichier d'archive en utilsiant le fichier de conf
	echo "Décompression de l'archive $ARCH_ROMS_NAME"
	ls -lh $ROMS_PATH/$ARCH_ROMS_NAME
	echo "Description du pack $ROM_NAME en cours de copie"
	echo $ROM_DESCRIPTION

	tar xvf $ROMS_PATH/$ARCH_ROMS_NAME -C $ROMS_REP
	echo "Les ROMS ont été copiées dans leur répertoire respectif"
	
    # Il y aura un nouveau choix de proposé sauf si on stop la boucle
    break
done
}


# Fin section décompression des packs de roms

while true
do
  #..........................................................................
  # affichage du menu téchargement de ROMS
  #..........................................................................
  clear
  echo "Téléchargement de Jeux


 1) Télécharger un pack de jeux
 2) Décompresser un pack de jeux

 R)  Retour au menu principal

 Tapez le chiffre correspondant à votre choix
 puis appuyez sur Entrée"


  #Appel des fonctions

  read answer
  clear

  case "$answer" in

    [1]*) DOWNLOAD_ROMS;;
    [2]*) DEPLOY_ROMS;;

    [Rr]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichée dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done