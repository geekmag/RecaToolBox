#!/bin/bash
#Affiche un beau logo coloré :)

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PINK='\033[1;35m'
NC='\033[0m'

read -r -d '' Banner <<EOF
${BLUE}########  ######## ${YELLOW} ######     ###    ##       ${RED}########  #######  ##     ##
${BLUE}##     ## ##       ${YELLOW}##    ##   ## ##   ##       ${RED}##     ## ##     ##  ##   ##
${BLUE}##     ## ##       ${YELLOW}##        ##   ##  ##       ${RED}##     ## ##     ##   ## ##
${BLUE}########  ######   ${YELLOW}##       ##     ## ##       ${RED}########  ##     ##    ###
${BLUE}##   ##   ##       ${YELLOW}##       ######### ##       ${RED}##     ## ##     ##   ## ##
${BLUE}##    ##  ##       ${YELLOW}##    ## ##     ## ##       ${RED}##     ## ##     ##  ##   ##
${BLUE}##     ## ######## ${YELLOW} ######  ##     ## ######## ${RED}########   #######  ##     ##${NC}
EOF

echo -e "$Banner"
echo

echo -e "							${PINK}Reca${RED}Toolbox ${GREEN}by ${YELLOW}GeekMag${BLUE}.fr"