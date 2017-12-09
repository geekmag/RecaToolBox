#! /bin/sh
##############################
# Configuration de moonlight
# Geekmag.fr
#Build 02/12/2017

#positionnement dans le répertoire
cd /recalbox/scripts/moonlight

CONF_MOONLIGHT()
{
echo "Vous allez maintenant configuer le streaming de jeux PC sur Recalbox"
echo "Vérifier que votre firewall laisse passer les connexions"
echo "Vérifier que vos driver Nvidia et GeForce Experience sont à jour"
read -p "Appuyez sur Entrer pour lancer l'assitant de configuration un code à copier sur votre PC va apparaitre:"


./Moonlight.sh pair

echo "Votre Recalbox est maintenant configurée pour diffuser les jeux PC / Steam"
echo "Nous allons maintenant lancer le scan de votre liste de jeux"
echo "Tous les jeux présent dans GeForce Experience vont ensuite apparaitre sur Recalbox"
read -p "Appuyez sur Entrer pour lancer le scan de vos jeux PC puis patientez "

./Moonlight.sh init

echo "Fais un petit arrêt / relance d'Emulationstation pour prendre l'ajout ;)"
}

SCAN_GAME()
{
echo "Scan des nouveaux jeux ajoutés, patientez quelques instants"
./Moonlight.sh init
echo "Fais un petit arrêt / relance d'Emulationstation pour prendre l'ajout ;)"
}

AR_ES()
{
 echo "Arrêt / Relance d'Emulation Station en cours"
 /etc/init.d/S31emulationstation restart >/dev/null 2>&1
}

while true
do
  #..........................................................................
  # affichage
  #..........................................................................
  clear
  echo "Moonlight vous permer de Steamer tous vos jeux PC directement sur Recalbox
Vous verrez apparaitre un nouveau menu une fois sur Emulationstation une fois configuré
ATTENTION: cette option ne fonctionne que si votre PC est doté d'une carte graphique Nvidia


1) Lancer la configuration initiale de Moonlight
2) Mettre à jour la liste des jeux PC dans Emulationstation
3) Faire un arrêt relance d emulationstation

R) Retour au menu principal

Tapez le chiffre correspondant à votre choix puis appuyer sur Entrée"

  #..........................................................................
  # Menu de configuration de moonlight
  #..........................................................................
  read answer
  clear

  case "$answer" in

    [1]*) CONF_MOONLIGHT;;
    [2]*) SCAN_GAME;;
	[3]*) AR_ES;;

    [Rr]*)  echo "Retour au menu précédent" ; exit 0 ;;
    *)      echo "Choisissez une option affichee dans le menu:" ;;
  esac
  echo ""
  echo "Appuyez sur Entrée pour retourner au menu"
  read dummy
done