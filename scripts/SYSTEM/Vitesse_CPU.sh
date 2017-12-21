#!/bin/bash
# Autheur Eric78 / GeekMag.fr

# Lecture des fréquences CPU dans les fichiers
FIC_CPU_VitAct=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
FIC_CPU_VitMin=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq)
FIC_CPU_VitMax=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq)

# On calcul pour avoir un affichage lisible
CPU_VitAct=$(($FIC_CPU_VitAct/1000))
CPU_VitMin=$(($FIC_CPU_VitMin/1000))
CPU_VitMax=$(($FIC_CPU_VitMax/1000))

#On récupère le modèle de Raspberry Pi
RPI_VERSION_FIC=$(cat /proc/device-tree/model)
RPI_VERSION=$(echo $RPI_VERSION_FIC| awk '{print $1,$2,$3}')
RPI=$(echo $RPI_VERSION_FIC| awk '{print $1}')

#On test si Recalbox tourne sur un Raspberrry si non pas d'affichage
if [[ "$RPI" == Raspberry ]]
	then
		
		# pour les vitesse de CPU entre 600Mhz et 900Mhz, on affiche les caractères en bleu
		if [ $CPU_VitAct -ge 600 ] && [ $CPU_VitAct -lt 900 ];then
			echo -e "Cadence CPU actuelle: \033[34m${CPU_VitAct} MHz\033[0m"
		
		# pour les vitesse de CPU entre 900Mhz et 1200Mhz, on affiche les caractères en vert
		elif [ $CPU_VitAct -ge 900 ] && [ $CPU_VitAct -lt 1200 ];then
			echo -e "Cadence CPU actuelle: \033[32m${CPU_VitAct} MHz\033[0m"
		
		# pour les vitesse de CPU entre 1200Mhz et plus... on affiche les caractères en rouge sur fond jaune
		elif [ $CPU_VitAct -ge 1200 ] && [ $CPU_VitAct -lt 2000 ];then
			echo -e "\033[31m\033[43mFréquence du CPU  overclockée: ${CPU_VitAct} MHz\033[0m"
			echo "Pensez à surveiller l'évolution de la température"
	
				
	fi
		echo Vitesse minimum: $CPU_VitMin MHz / Vitesse maximum: $CPU_VitMax MHz	
		
#Si ce n'est pas un Raspberry Pi, on n'affiche rien
else

    exit 0
fi