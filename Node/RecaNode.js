var DownloadModule = require('./DownloadModule/DownloadModule');
var GamesList = require('./GamesList/GamesList');

// print process.argv
/*
process.argv.forEach((val, index) => {
    console.log(`${index}: ${val}`);
});
*/
console.log(`This platform is ${process.platform}`);
if (process.argv.length<=2) {
    console.error("Un paramètre minimum, resprésentant l'action à effectuer");
    process.exit(3);
}

if (process.argv[2]=='testDownload') {
    //var myMagnet="magnet:?xt=urn:btih:e1e9d490fee26857367d4291e813397b78828462&dn=CheckMyTorrentIPAddress+Tracking+Link&tr=http%3A%2F%2Fcheckmytorrentip.upcoil.com%2F";
    //var myMagnet="magnet:?xt=urn:btih:fcf1178fc7cd636694ba190016f9f86e68f57527&dn=The+Everything+Easy+French+Cookbook+By+Cecile+Delarue+EPUB&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.zer0day.to%3A1337&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337";
    //let myMagnet="magnet:?xt=urn:btih:20D8B0EF9ACE2ACF4FE4C201E0AE550E4D09B681"
    //let myMagnet="magnet:?xt=urn:btih:54969D6E66F4DA50EE715C6A4BB47D92DC9B72CF"
    let myMagnet="magnet:?xt=urn:btih:894247BEA4F069E8976CA645617B0FE986FDD3AD"
    var myDownload = new DownloadModule();
    myDownload.downloadMagnet(myMagnet,"outputhPath");
} else if (process.argv[2]=='gamesList') {
    var gamesList = new GamesList();
    gamesList.parseAllGames();
    //console.log('Fonction pas encore implémentée');
} else {
    console.error("Action non reconnue:", process.argv[2]);
}

//console.log("Sortie du programme");

//downloadModule.direBonjour();


