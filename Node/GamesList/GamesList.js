const Config = require('../Config/Config');
const path = require('path');
const fs = require('fs');
const fsp = require('fs-extra');
const xml2js = require('xml2js');
const glob = require('glob');
const Promise = require("bluebird");

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
                        if(output.games.length>0) {
                            // Modify the workbook.
                            let actualLine = 1;
                            const consoleSheet = workbook.addSheet(output.console);
                            //consoleSheet.cell("A1").value("This is neat!");
                            consoleSheet.row(actualLine).cell(1).value("Nom du jeu");
                            consoleSheet.row(actualLine).cell(2).value("Fichier");
                            consoleSheet.row(actualLine).cell(3).value("Parsed");
                            consoleSheet.row(actualLine).cell(4).value("Présent");
                            consoleSheet.row(actualLine).cell(5).value("Description");

                            //actualLine++;
                            for (var i = 0; i < output.games.length; i++) {
                                actualLine++;
                                consoleSheet.row(actualLine).cell(1).value(output.games[i].name);
                                consoleSheet.row(actualLine).cell(2).value(output.games[i].file);
                                consoleSheet.row(actualLine).cell(3).value(output.games[i].parsed);
                                consoleSheet.row(actualLine).cell(4).value(output.games[i].fileFound);
                                consoleSheet.row(actualLine).cell(5).value(output.games[i].desc);

                                //worksheet.addRow([output.games[i].name, output.games[i].desc ]);
                            }
                        }
                       /* for (var j=0; j< output.files.length; j++) {
                            actualLine++;

                        }*/
                    });
                    workbook.deleteSheet("Sheet1");
                    // Write to file.
                    var d = new Date();
                    var now = d.getFullYear()+'-'+d.getMonth()+'-'+d.getDay();
                    return workbook.toFileAsync(path.join(this.config.getPaths().GAME_OUTPUT_PATH ,"ListeJeux" + now + ".xlsx"));
                });
        }
    };

    parseGamelist(consolePath) {
        return new Promise((resolve, reject) => {
            console.log('Debut Parsing de ', consolePath);

            // On récupère les méta données de la console
            let consoleConfig = this.config.getConsoleConfig(consolePath);

            //On liste ensuite toutes les ROMS présentes
            let globOptions = {
                cwd: consoleConfig.fullPath
            }
            let foundFiles = glob.sync(consoleConfig.romsMask, globOptions);
            let parsedFiles = [];

            let consoleFullPath = path.join(this.config.getPaths().ROMS_DIR, consolePath);
            let gamelistPath = path.join(consoleFullPath, 'gamelist.xml');
            let output = {
                console: consoleConfig.fullName,
                games: [],
                files: []
            }
            //console.log('Full path: ', gamelistPath);
            if (fs.existsSync(gamelistPath)) {
                var parser = new xml2js.Parser();
                let data = fs.readFileSync(gamelistPath);
                parser.parseString(data, (err, result) => {
                    if (result && result.gameList && result.gameList.game) {
                        var games = result.gameList.game;

                        games.forEach(game => {

                            let gameShortName = game.path[0].substring(2);
                            // On vérifie s'il fait partie des fichiers précédemment listés
                            let fileIndex = foundFiles.indexOf(gameShortName);

                            let fileFound = (fileIndex != -1);
                            if (fileFound) {
                                parsedFiles.push(gameShortName);
                                foundFiles = foundFiles.splice(fileIndex);
                            } else {
                                console.log("Fichier ",consolePath, "-", gameShortName, " parsé mais non présent");
                            }

                            let myPath = '';
                            if (game.path && game.path[0] && game.path[0].length>2) {
                                myPath=game.path[0].substr(2);
                            }

                            let myDesc='';
                            if (game.desc && game.desc[0]) {
                                myDesc=game.desc[0];
                            }

                            let myName='';
                            if(game.name&&game.name[0]){
                                myName=game.name[0];
                            }

                            var myGame = {
                                name: myName,
                                desc: myDesc,
                                file: myPath,
                                parsed: true,
                                fileFound: fileFound
                            };
                            output.games.push(myGame);
                        });
                    } else {
                        console.log('Aucun jeu trouvé pour ', consolePath);
                    }
                    this.appendNotFoundFiles(output, foundFiles, consolePath);
                    resolve(output);
                });
            } else {
                console.log('Fichier gamelist.xml non trouvé pour ', consolePath);
                this.appendNotFoundFiles(output, foundFiles, consolePath);
                resolve(output);
            }

        });
    }

    appendNotFoundFiles(output, files, consolePath) {
        if (files && files.length>0) {
            console.log(consolePath," - Fichiers présents mais non scrapés:");
            files.forEach(file=>{
                console.log("    ",file);
                var myGame = {
                    name: '',
                    desc: '',
                    file: file,
                    parsed: false,
                    fileFound: true
                };
                output.games.push(myGame);
            });
            //output.files = files;
        }
    }

    parseAllGames() {
        let parsingOutput = [];
        var consolePromesses = [];
        console.log('On lance le parsing des jeux');
        this.config.getConsoles().forEach( console => {
            var consoleParsingPromesse = this.parseGamelist(console);
            consolePromesses.push(consoleParsingPromesse);

            /*let consoleParsing = this.parseGamelist(console);
            if(consoleParsing) {
                parsingOutput.push(consoleParsing);
            }*/
        });

        Promise.all(consolePromesses).then( (data) => {
            console.info('Toutes les consoles ont été parsées avec succès, on génère le fichier Excel');
            this.exportExcel(data);

            /* data.forEach(function (fileJson, index) {
                console.log('Contenu du fichier ' + index);
                console.dir(fileJson);
            }); */
        }).catch(function (err) {
            console.error('Une erreur est survenue lors du parsing des consoles', err);
        });

        // var excelFile = this.exportExcel(parsingOutput)
        // excelFile.then('Excel file has been saved');

    }
}
