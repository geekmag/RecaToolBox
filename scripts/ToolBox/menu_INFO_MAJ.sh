#!/bin/bash
##############################
# Menu mise à jour
# Geekmag.fr
#Build 02/12/2017


#déclaration des variables
CLOUD_PATH=http://geekmag78.free.fr/recalbox/recaltoobox/
#CLOUD_PATH=http://recalbox.jey2k.fr/recatoolbox
UPDATE_NAME=toolbox_update.tar

DEPOTS_PATH=$TOOLBOX_DOWNLOAD_PATH/Depots
DEPOTS_DL=$DEPOTS_PATH/source

REPOSITORY_PATH=$TOOLBOX_DOWNLOAD_PATH/Repository
REPOSITORY_DL=$REPOSITORY_PATH/source

REP_SCRIPTS=$TOOLBOX_PATH/scripts

LAST_SYNC_PATH=$REPOSITORY_PATH/lastSync.txt

MAX_UPDATE_OLD=10

#Test l'espace libre sur le FS
FREESPACE=$(df -h /recalbox/share | awk '{print $4}' | tail -n 1)

#remonte le FS en lecture écriture
mount -o remount,rw /

############### Début menu téléchargement MAJ RecalToolBox #################
DL_MAJ_TOOLBOX()
{
read -p "Etes vous sûr de vouloir télécharger la MAJ de la RecaToolBox (O ou N)? " -n 1 -r
echo ""
echo    "Dommage il y avait surement plein de nouvelles fonctions au top ^^"
if [[ $REPLY =~ ^[OoYy]$ ]]
then
    echo "Youpi! C'est parti, il y aura peut être une nouvelle interface web de ouf dans cette MAJ?"
		cd $TOOLBOX_DOWNLOAD_PATH
		wget -N $CLOUD_PATH/$UPDATE_NAME

		#Décompression de l'archive
		tar -xf $UPDATE_NAME -C $TOOLBOX_HOME
		rm -f $TOOLBOX_DOWNLOAD_PATH/$UPDATE_NAME
		echo "La RecaToolbox a été mise à jour."
fi
}
############### Fin menu téléchargement MAJ RecalToolbox #################

UPDATE_REPOSITORY() {

    echo "Debut du traitement du repository $REPO_NAME"

    if [ -z $REPO_PREFIX ]; then
        echo "Le préfixe est obligatoire, merci de corriger le fichier desciptif du repository ($filename)"
        return 3
    fi

    #On supprime les metadonnées sauvegardées du repo
    if [ -d $REPOSITORY_PATH/$REPO_PREFIX ]; then
        rm -R $REPOSITORY_PATH/$REPO_PREFIX
    fi

    #On recrée le répertoire
    mkdir $REPOSITORY_PATH/$REPO_PREFIX
    mkdir $REPOSITORY_PATH/$REPO_PREFIX/working
    cd $REPOSITORY_PATH/$REPO_PREFIX

    echo "On récupère le catalogue à l'url suivante: $REPO_BASE_URL/$REPO_CATALOG_URL"
    wget $REPO_BASE_URL/$REPO_CATALOG_URL

    # On vérifie la bonne exécution via la présence du fichier. On sort si erreur
    if [ ! -f $REPOSITORY_PATH/$REPO_PREFIX/$REPO_CATALOG_URL ]; then
        echo "Le fichier $REPO_CATALOG_URL n'a pas pu être téléchargé correctement."
        return 3
    fi
    #On parcourt ensuite le fichier de catalog pour avoir toutes les URLS
    dos2unix $REPOSITORY_PATH/$REPO_PREFIX/$REPO_CATALOG_URL
    while read ligne
    do
        set $(echo $ligne)
        ENTRY_TYPE=$(eval echo $1)
        ENTRY_URL=$(eval echo $2)
        echo "Nouvel élément du catalogue disponible à l url: $ENTRY_URL / Type: $ENTRY_TYPE"
        cd $REPOSITORY_PATH/$REPO_PREFIX/working
        wget $ENTRY_URL
        WGET_RESULT=$?
        #echo "Wget est sorti avec le code $WGET_RESULT"
        if [[ $WGET_RESULT != 0 ]]
        then
            echo "Téléchargement en erreur, on passe au fichier suivant"
            continue
        fi;

        OUTPUT_PATH=""
        #echo "Juste avant le test, ENTRY_TYPE vaut $ENTRY_TYPE"
        if [[ "$ENTRY_TYPE" == "ROMS" ]]
        then
            OUTPUT_PATH=$TOOLBOX_DOWNLOAD_PATH/Roms/source/$REPO_PREFIX
        elif [[ "$ENTRY_TYPE" == "THEMES" ]]
        then
            OUTPUT_PATH=$TOOLBOX_DOWNLOAD_PATH/Themes/source/$REPO_PREFIX
        elif [[ "$ENTRY_TYPE" == "VIDEOS" ]]
        then
            OUTPUT_PATH=$TOOLBOX_DOWNLOAD_PATH/video_intro/source/$REPO_PREFIX
        elif [[ "$ENTRY_TYPE" == "BIOS" ]]
        then
            OUTPUT_PATH=$TOOLBOX_DOWNLOAD_PATH/Bios/source/$REPO_PREFIX
        elif [[ "$ENTRY_TYPE" == "COLLECTION" ]]
        then
            OUTPUT_PATH=$TOOLBOX_DOWNLOAD_PATH/Collection/source/$REPO_PREFIX
        else
            echo "Type de fichier non géré"
            rm $REPOSITORY_PATH/$REPO_PREFIX/working/*
            continue
        fi
        for catalogEntryTar in *.tar
        do
            echo "Fichier tar à traiter: $catalogEntryTar"
            #echo "OutputPath: $OUTPUT_PATH"
            if [[ ! -d $OUTPUT_PATH ]]; then
                mkdir $OUTPUT_PATH
            fi
            tar xvf $catalogEntryTar -C $OUTPUT_PATH
            rm $catalogEntryTar
        done

#        for catalogEntryTxt in *.txt
#        do
#            echo "Fichier tar à traiter: $catalogEntryTxt"
#        done
    done < $REPOSITORY_PATH/$REPO_PREFIX/$REPO_CATALOG_URL

    if [[ -d $REPOSITORY_PATH/$REPO_PREFIX/working ]];
    then
        rm -R $REPOSITORY_PATH/$REPO_PREFIX/working
    fi

    echo "Fin du traitement du repository $REPO_NAME"

}


############### Menu pour télécharger de nouvelles sources #################
# Le téléchargement se fait en regardant les dépots disponible dans le fichier repository.txt
MAJ_SOURCE_DL()
{

#on se place dans le dossier contenant la liste des repositories
cd $REPOSITORY_DL
#Pour éviter les problèmes de caractères
dos2unix $REPOSITORY_DL/*.txt

for filename in *.txt
do
    # echo "Traitement du fichier $filename"
    # On charge la configuration du repository
    source $REPOSITORY_DL/$filename

    echo "Repository $REPO_NAME identifié"

    #echo "On attaque son traitement"
    UPDATE_REPOSITORY

done
date +%s > $LAST_SYNC_PATH
echo "La liste des dépots a été mise à jour."
return 0

}
#################### Fin de la fonction téléchargement de nouvelles sources #################


ABOUT()
{
    clear
    $TOOLBOX_PATH/scripts/ToolBox/banner.sh
	echo
	echo -e "RecaToolBox a été initialement créé par Eric de \033[32mGeekMag.fr\033[0m"
	echo -e "L'outil a ensuite été très largement amélioré par Jérémy alias \033[32mjey2k.fr\033[0m"
 	echo
	read -p "Appuyez sur une touche pour revenir à l'écran précédent"
}

CHECK_AND_UPDATE()
{
 if [ ! -f $LAST_SYNC_PATH ]; then
     while true
        clear
        $TOOLBOX_PATH/scripts/ToolBox/banner.sh
        do
        echo "Nous n'avons pas retrouvé trace de la dernière synchronisation.
Voulez-vous mettre à jour les sources de téléchargement maintenant? (o/n)"
        read answer
        clear
        case "$answer" in
        [oO]*) MAJ_SOURCE_DL;exit 0;;
        [nN]*) exit 0;;
        *) echo "Choisissez Oui ou Non" ;
      esac
    #  echo ""
    #  echo "Appuyez sur Entrée pour retourner au menu"
    #  read dummy
    done
 else
    MY_DATE=`cat $LAST_SYNC_PATH`
    echo "Trouvé dans le fichier:"
    echo "$MY_DATE"
    #echo "Date de dernière synchro:"
    #echo `date --date="$MY_DATE" +%s`
    ACTUAL_DATE=`date +%s`
    echo "Actual Date:"
    echo "$ACTUAL_DATE"
    echo "Age de la synchro:"
    AGE_SYNCHRO=$(( ($ACTUAL_DATE - $MY_DATE )/(60*60*24) ))
    if [ $AGE_SYNCHRO -gt $MAX_UPDATE_OLD ]; then
        clear
        $TOOLBOX_PATH/scripts/ToolBox/banner.sh
        while true
        do
            echo "Vous n'avez à priori pas mis à jour les sources de téléchargement depuis $AGE_SYNCHRO jours
Voulez-vous mettre à jour maintenant? (o/n)"
            read answer
            clear
            case "$answer" in
                [oO]*) MAJ_SOURCE_DL;exit 0;;
                [nN]*) exit 0;;
                *) echo "Choisissez Oui ou Non" ;
            esac
        done
    fi
 fi
}

DISPLAY_MENU()
{
    while true
    do
      #..........................................................................
      # affichage Info + recherche MAJ
      #..........................................................................
      clear
      $TOOLBOX_PATH/scripts/SYSTEM/version.sh
      echo "


    1) Mettre à jour la RecalToolBox
    2) Mettre à jour la sources de téléchargement (Roms / Themes...)
    
    3) A propos de RecalToolBox

    0) Retour au menu principal

    Tapez le chiffre correspondant à votre choix puis appuyer sur Entrée"

      #..........................................................................
      # Appel des fonctions
      #..........................................................................
      read answer
      clear

      case "$answer" in

        [1]*) DL_MAJ_TOOLBOX;;
        [2]*) MAJ_SOURCE_DL;;
        [3]*) ABOUT;;

        [0]*)  echo "Retour au menu précédent" ; exit 0 ;;
        *)      echo "Choisissez une option affichée dans le menu:" ;;
      esac
    #  echo ""
    #  echo "Appuyez sur Entrée pour retourner au menu"
    #  read dummy
    done
}
[ $# -eq 0 ] && DISPLAY_MENU
[ "$1" == "checkAndUpdate" ] && CHECK_AND_UPDATE
