#!/bin/bash
#Script permettant d'afficher l'adresse IP
#
#Version 1.0
#22/11/2017
##########################################################

IP_ADRESS=$(ifconfig | awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}')

echo "Votre adresse IP:" $IP_ADRESS

