#! /bin/sh
##############################
# Menu pour générer une liste des jeux
# Autheur: Eric (GeekMag.fr)
# Création 20/12/2017

DATE=$(date "+%Y-%m-%d")
ROM_PATH=/recalbox/share/roms/
LIST_FICHIER="$TOOLBOX_HOME/liste_jeux_"$DATE".html"


i=0

echo "<html>
    <head>
        <meta charset="utf-8" />
        <title>Liste de jeux - RecaToolBox by Geekmag.fr</title>
    </head>

    <body>
 <h4>Liste de jeux</h4>
  <ul>
	<a href="https://github.com/geekmag/RecaToolBox/">Générée avec RecaToolBox</a> by <a href="https://www.geekmag.fr">GeekMag.fr</a>
  </ul>

 " > $LIST_FICHIER

echo "<UL>" >> $LIST_FICHIER
for filepath in `find "$ROM_PATH" -maxdepth 1 -mindepth 1 -type d| sort`; do
  path=`basename "$filepath"`
  echo "  <h4><LI>$path</LI></h4>" >> $LIST_FICHIER
  echo "  <UL>" >> $LIST_FICHIER
  for i in `find "$filepath" -maxdepth 1 -mindepth 1 -type f| sort`; do
    file=`basename "$i"`
    echo "    <LI><a href=\"/recalbox/share/roms/$path/$file\">$file</a></LI>" >> $LIST_FICHIER
  done
  echo "  </UL>" >> $LIST_FICHIER
done
echo "</UL>" >> $LIST_FICHIER

    
echo "</body>
</html>"  >> $LIST_FICHIER