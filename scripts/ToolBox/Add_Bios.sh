#!/bin/bash
# Script permettant de télécharger les BIOS
# http://www.geekmag.fr/recatoolbox/ pour la version mise à jour
# 10/12/2017

###########   déclaration des variables ####################

#chemin vers répertoire téléchargement de la usertoolbox
BIOS_REP=/recalbox/share/bios
BIOS_PATH=$TOOLBOX_DOWNLOAD_PATH/Bios
BIOS_DL=$BIOS_PATH/source

#Test l'espace libre sur le FS
FREESPACE=$(df -h /recalbox/share | awk '{print $4}' | tail -n 1)

#récupére l'ensemble du contenu du FTP
#wget -r -l 0 ftp://www.domaine.example/chemin/* --ftp-user=nom_user --ftp-password=password -nH --cut-dirs=1

#récupérer un fichier par FTP
#wget ftp://$FTP_LOGIN:$FTP_PASSWORD@$FTP_ADRESSE/chemin/$ROM_COLLECTION

# Début section téléchargementdes packs de BIOS

DOWNLOAD_BIOS()
{

#on se place dans le dossier contenant la liste des fichiers txt contenant les info relatives au téléchargement
cd $BIOS_DL
#Pour éviter les problèmes de caractères
dos2unix $BIOS_DL/*.txt

# invite de commande pour choisir l'option du select
PS3="Entrez le numéro correspondant à packs de BIOS que vous voulez télécharger ou tapez 'retour' pour sortir du menu: "

# Permet à l'utilisateur de choisir un pack de BIOS en générant une liste de tous les fichiers .txt contenant les URL de téléchargement
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
	source  $BIOS_DL/$filename
	# On se place dans le répertoire de téléchargement
	cd $BIOS_PATH
	# On affiche l'interface utilisateur
	echo "Vous allez télécharger le pack: $BIOS_NAME" 
	echo "Cette collection est proposée par:" $AUTHOR
	echo "cette téléchargement va se faire par:" $TYPE_LINK
	echo ""
	echo "Voici ce que contient le pack:"
	echo "$BIOS_DESCRIPTION"
	echo ""
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
					wget http://$DOWNLOAD_URL_BIOS
			elif [ $TYPE_LINK = FTP ]
				then
					echo "Lancement du téléchargement via FTP"
					wget --user=$FTP_LOGIN --password=$FTP_PASSWORD ftp://$DOWNLOAD_URL_BIOS
			else
				echo "Le type de lien n'est pas configuré, téléchargement impossible"
			fi
	
	echo "Votre pack a bien été téléchargée"
	echo "Retournez au menu précédent et faire choix 2 pour installer ce pack de BIOS"
    # Il y aura un nouveau choix de proposé sauf si on stop la boucle
    break
done

}

# Fin section téléchargementdes packs de BIOS

# Début section décompression des packs de BIOS

DEPLOY_BIOS()
{

echo "Seul les packs de BIOS déposées préalablement dans le partage réseau de Recalbox apparaissent ici"
echo "$BIOS_PATH"
#On se place dans le dossier contenant les collections de jeux
cd $BIOS_DL

# invite de commande pour choisir l'option du select
PS3="Entrez le numéro correspondant au BIOS que vous voulez ajouter à EmulationStation ou tapez 'retour' pour sortir du menu: "

# Permet à l'utilisateur de choisir une archive tar en générant une liste de tous les fichiers *.tar
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

	# On charge les variables du fichier externe
	source  $BIOS_DL/$filename
    # maintenant on peut travailler sur le fichier d'archive en utilsiant le fichier de conf
	echo "Décompression de l'archive $ARCH_BIOS_NAME"
	ls -lh $BIOS_PATH/$ARCH_BIOS_NAME
	echo "Description du pack $BIOS_NAME en cours de copie"
	echo $ROM_DESCRIPTION

	tar xvf $BIOS_PATH/$ARCH_BIOS_NAME -C $BIOS_REP
	echo ""
	echo "Les BIOS ont bien été installés"
	echo "Ouvrez votre navigateur à l'adresse http://recalbox.local/bios"
	echo "Tous les bios doivent maintenant apparaitre"
	
    # Il y aura un nouveau choix de proposé sauf si on stop la boucle
    break
done
}


# Fin section décompression des packs de BIOS

while true
do
  #..........................................................................
  # affichage du menu téchargement de BIOS
  #..........................................................................
  clear
  echo "Téléchargement de BIOS


 1) Télécharger des BIOS
 2) Installer des BIOS

 R)  Retour au menu principal

 Tapez le chiffre correspondant à votre choix
 puis appuyer sur Entrée"


  #Appel des fonctions

  read answer
  clear

  case "$answer" in

    [1]*) DOWNLOAD_BIOS;;
    [2]*) DEPLOY_BIOS;;

    [Rr]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichee dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done
