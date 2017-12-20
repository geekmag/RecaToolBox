const Config = require('../Config/Config');
const path = require('path');
const fs = require('fs');
const xml2js = require('xml2js');

module.exports = class GamesList{
    constructor() {
        this.config = new Config();
    }

    exportExcel(parsingList) {
        if(parsingList) {
            const XlsxPopulate = require('xlsx-populate');
            XlsxPopulate.fromBlankAsync()
                .then(workbook => {

                    parsingList.forEach(output => {
                        // Modify the workbook.
                        const consoleSheet = workbook.addSheet(output.console);
                        consoleSheet.cell("A1").value("This is neat!");


                        for (var i = 0; i < output.games.length ; i++) {
                            consoleSheet.row(i+2).cell(1).value(output.games[i].name);
                            consoleSheet.row(i+2).cell(2).value(output.games[i].desc);
                            //worksheet.addRow([output.games[i].name, output.games[i].desc ]);
                        }
                    });

                    // Write to file.
                    return workbook.toFileAsync(path.join(this.config.getPaths().GAME_OUTPUT_PATH ,"out.xlsx"));
                });
        }
    };

    parseGamelist(consolePath) {
        console.log('Parsing de ', consolePath);

        let consoleConfig=this.config.getConsoleConfig(consolePath);

        let consoleFullPath = path.join(this.config.getPaths().ROMS_DIR,consolePath);
        let gamelistPath = path.join(consoleFullPath,'gamelist.xml');
        let output = {
            console: consoleConfig.fullName,
            games: []
        }
        //console.log('Full path: ', gamelistPath);
        if(fs.existsSync(gamelistPath)) {
            var parser = new xml2js.Parser();
            fs.readFile(gamelistPath, (err, data) => {
                parser.parseString(data, (err, result) => {
                    //console.dir(result);
                    //console.log(result);
                    //console.log('Done');
                    if(result && result.gameList && result.gameList.game) {
                        var games = result.gameList.game;

                        games.forEach(function(game) {
                            var myGame = {
                                name: game.name[0],
                                desc: game.desc[0]
                            };
                            output.games.push(myGame);
                            //console.log('Jeu trouvé: ', game.name[0]);
                            //console.log('Description: ', game.desc[0]);
                        });
                        /*var json2xls = require('json2xls');
                        var xls = json2xls(output);
                        var outputFile = path.join(config.GAME_OUTPUT_PATH  ,consolePath + '.xlsx');
                        console.log('On extraie le fichier dans ', outputFile);
                        fs.writeFileSync(outputFile, xls, 'binary');*/
                        /* var excelbuilder = require('msexcel-builder');
                         var workbook = excelbuilder.createWorkbook(config.GAME_OUTPUT_PATH +"/", consolePath + '.xlsx');
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
                                 console.log('congratulations, your workbook created in ',config.GAME_OUTPUT_PATH ," with name: ", consolePath+".xlsx");
                         });
         */
                        /* eSSAI AVEC EXCELJS

                                        var Excel = require('exceljs');
                                        //var workbook = createAndFillWorkbook();
                                        var workbook = new Excel.Workbook();
                                        workbook.creator = 'RecaToolBox';
                                        var worksheet = workbook.addWorksheet(consolePath);

                                        worksheet.addRow([3, 'Sam', new Date()]);
                                        for (var i = 0; i < output.games.length ; i++) {
                                            worksheet.addRow([output.games[i].name, output.games[i].desc ]);
                                        }

                                        workbook.xlsx.writeFile(path.join(config.GAME_OUTPUT_PATH, (consolePath + '.xlsx') ))
                                            .then(function() {
                                                console.log ("Fichier ecrit");
                                            });
                        */

                    } else {
                        console.log('Aucun jeu trouvé pour ', consolePath);
                    }
                });
            });
        } else {
            console.log('Fichier gamelist.xml non trouvé');
        }

        return output;
    }

    parseAllGames() {
        let parsingOutput = [];
        console.log('On lance le parsing des jeux');
        this.config.getConsoles().forEach( console => {
            let consoleParsing = this.parseGamelist(console);
            if(consoleParsing) {
                parsingOutput.push(consoleParsing);
            }
        });

        this.exportExcel(parsingOutput);


    }
}
