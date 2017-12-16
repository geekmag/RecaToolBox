#! /bin/sh
##############################
#Récupère la température du Raspberry Pi
#Affiche un code couleur en fonction des seuils
# source: Eric de GeekMag.fr
#15/12/2017

#On récupère le modèle de Raspberry Pi
RPI_VERSION_FIC=$(cat /proc/device-tree/model)
RPI_VERSION=$(echo $RPI_VERSION_FIC| awk '{print $1,$2,$3}')
RPI=$(echo $RPI_VERSION_FIC| awk '{print $1}')

# récupération de la température: il s'agit d'une valeur à 5 chiffres sans virgules
FIC_TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

# Pour obtenir une température lisible à deux chiffres, on divise alors la valeur récupérée par 1000 
TEMPERATURE=$(($FIC_TEMP/1000))


#On test si Recalbox tourne sur un Raspberrry si non pas d'affichage
if [[ "$RPI" == Raspberry ]]
	then
		
		# pour les températures inférieures à 40°C, on affiche les caractères en bleu
		if [ $TEMPERATURE -lt 40 ]; then
			echo -e "Température du $RPI_VERSION: \033[34m${TEMPERATURE}°C\033[0m"
		
		# pour les températures comprises entre +40 et 50°C, on affiche les caractères en vert
		elif [ $TEMPERATURE -ge 40 ] && [ $TEMPERATURE -lt 50 ];then
			echo -e "Température du $RPI_VERSION: \033[32m${TEMPERATURE}°C\033[0m"
		
		# pour les températures comprises entre +50 et 70°C, on affiche les caractères en rouge sur fond jaune
		elif [ $TEMPERATURE -ge 50 ] && [ $TEMPERATURE -lt 70 ];then
			echo -e "\033[31m\033[43mTempérature du $RPI_VERSION: ${TEMPERATURE}°C\033[0m"
		
		# pour les températures comprises entre +70 et 75°C, on affiche les caractères en jaune sur fond rouge + temp en gras
		elif [ $TEMPERATURE -ge 70 ] && [ $TEMPERATURE -lt 75 ];then
			echo -e "\033[33m\033[41mALERTE Température - $RPI_VERSION en surchauffe: \033[1m${TEMPERATURE}°C\033[0m"
		
		# pour les températures dépassant 75°C: on affiche et on éteind le RPi
		elif [ $TEMPERATURE -ge 75 ];then
			echo "Surchauffe extreme du $RPI_VERSION: ${TEMPERATURE}°C"
			shutdown -h now
			
	fi
	
#Si ce n'est pas un Raspberry Pi, on n'affiche rien
else

    exit 0
fi

