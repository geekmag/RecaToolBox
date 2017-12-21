#!/usr/bin/env bash
ROOT_PATH=`pwd`
echo "Nous sommes dans le répertoire $ROOT_PATH"

echo "Nous allons packager le NodeJs"
cd Node
echo "Nous sommes maintenant dans le répertoire `pwd`"
#npm install
npm run-script build
cd $ROOT_PATH

if [ ! -d ./dist ]; then
    mkdir dist
fi
cd dist
if [ -d ./install ]; then
    rm -R ./install
fi
mkdir install
if [ -d ./update ]; then
    rm -R ./update
fi
mkdir update
mkdir install/sources
mkdir install/sources/ToolBox
mkdir install/sources/Game_Profile
cp -R $ROOT_PATH/scripts install/sources/ToolBox/
dos2unix install/sources/ToolBox/scripts/*.sh
chmod +x install/sources/ToolBox/scripts/*.sh
dos2unix install/sources/ToolBox/scripts/*/*.sh
chmod +x install/sources/ToolBox/scripts/*/*.sh
cp -R $ROOT_PATH/fichiers/Source/Download install/sources
dos2unix $ROOT_PATH/fichiers/Source/Download/Repository/source/*.txt

mkdir install/sources/ToolBox/RecaNode
cp $ROOT_PATH/Node/dist/RecaNode.js install/sources/ToolBox/RecaNode

cp $ROOT_PATH/VERSION install/sources/ToolBox
dos2unix install/sources/ToolBox/VERSION
chmod +x install/sources/ToolBox/VERSION

mkdir install/sources/ToolBox/fichiers
cp -R $ROOT_PATH/fichiers/conf install/sources/ToolBox/fichiers
dos2unix install/sources/ToolBox/fichiers/conf/*.cfg
dos2unix install/sources/ToolBox/fichiers/conf/*.conf

cp $ROOT_PATH/fichiers/ASCII_Logo.txt install/sources/ToolBox/fichiers/
cd install/sources
tar -cvf ../RecaToolBox.tar *
cd $ROOT_PATH/dist/install
cp $ROOT_PATH/install_menu.sh ./
dos2unix ./install_menu.sh
chmod +x ./install_menu.sh
rm -R sources
cp RecaToolBox.tar $ROOT_PATH/dist/update/toolbox_update.tar

