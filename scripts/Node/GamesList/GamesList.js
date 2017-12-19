var config = require('../Config/Config.js');
var path = require('path');
var fs = require('fs'),
    xml2js = require('xml2js');

function GamesList() {


}

var parseConsole = function(consolePath) {
    var consoleFullPath = path.join(config.ROMS_DIR,consolePath);
    var gamelistPath = path.join(consoleFullPath,'gamelist.xml');

    console.log('Full path: ', gamelistPath);

    var parser = new xml2js.Parser();
    fs.readFile(gamelistPath, function(err, data) {
        parser.parseString(data, function (err, result) {
            //console.dir(result);
            console.log(result);
            console.log('Done');
            if(result && result.gameList && result.gameList.game) {
                var games = result.gameList.game;
                var output = {
                    console: consolePath,
                    games: []
                }
                games.forEach(function(game) {
                    var myGame = {
                        name: game.name[0],
                        desc: game.desc[0]
                    };
                    output.games.push(myGame);
                    console.log('Jeu trouvé: ', game.name[0]);
                    console.log('Description: ', game.desc[0]);
                });
                /*var json2xls = require('json2xls');
                var xls = json2xls(output);
                var outputFile = path.join(config.GAME_OUTPUT_PATH  ,consolePath + '.xlsx');
                console.log('On extraie le fichier dans ', outputFile);
                fs.writeFileSync(outputFile, xls, 'binary');*/
                var excelbuilder = require('msexcel-builder');
                var workbook = excelbuilder.createWorkbook(config.GAME_OUTPUT_PATH, consolePath + '.xlsx');
                // Create a new worksheet with 10 columns and 12 rows
                var sheet1 = workbook.createSheet(consolePath, 2, output.games.length+2);
                sheet1.set(1, 1, 'Console: ');
                sheet1.set(2, 1, consolePath);
                for (var i = 0; i < output.games.length ; i++) {
                    sheet1.set(1, i + 2, output.games[i].name);
                    sheet1.set(2, i + 2, output.games[i].desc);
                }
                workbook.save(function(ok){
                    if (!ok)
                        workbook.cancel();
                    else
                        console.log('congratulations, your workbook created');
                });
            } else {
                console.log('Aucun jeu trouvé pour ', consolePath);
            }
        });
    });

}


GamesList.prototype.parseGames = function parseGames() {
    console.log('On lance le parsing des jeux');
    parseConsole('nes');
}

module.exports = GamesList;