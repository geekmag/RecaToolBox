var WebTorrent = require('webtorrent')

function DownloadModule() {

    let downloadInterval;
    let client;
    //var process = this;

}

var displayTorrentInfo = function(torrent, firstCall) {
    if(firstCall) {
        console.log('On rentre dans displayTorrent');
        firstCall = false;
    }
    this.downloadInterval = setInterval(displayTorrentProgress, 1000, torrent);
    //if(torrent.progress==1) clearInterval(timeOut);
}

var displayTorrentProgress = function(torrent) {
    console.log("Received bytes: ",torrent.received);
    console.log("Validated bytes: ",torrent.downloaded);
    console.log("Download speed: ",torrent.downloadSpeed);
    console.log("Progress: ", torrent.progress*100);
}

var onTorrentFinished = function(torrent) {
    clearInterval(this.downloadInterval);
    console.log("Téléchargement terminé");
    console.log('Votre fichier se trouve dans: ', torrent.path);
    console.log("On attend encore 5 secondes, et on sort");
    setTimeout(terminateProcess, 5000, torrent.client);
}

var terminateProcess = function(client) {
    debugger;
    client.destroy();
}


DownloadModule.prototype.downloadMagnet = function downloadMagnet(magnetURI, outputPath) {
    console.log("On lance  le téléchargement du magnet ", magnetURI, " dans le répertoire ", outputPath);


    this.client = new WebTorrent();
    this.client.add(magnetURI,
                    null, torrent => {
                        // Got torrent metadata!
                        torrent.on("done",()=>{onTorrentFinished(torrent) });
                        console.log('Client is downloading:');
                        console.log('Torrent OK');
                        displayTorrentInfo(torrent, true);
            //console.log(torrent);

        }


       /* torrent.files.forEach(function (file) {
            // Display the file by appending it to the DOM. Supports video, audio, images, and
            // more. Specify a container element (CSS selector or reference to DOM node).
            file.appendTo('body')
        })*/
    );
}
var direBonjour = function() {
    console.log('Bonjour !');
}

var direByeBye = function() {
    console.log('Bye bye !');
}

module.exports = DownloadModule;
//exports.direByeBye = direByeBye;

//exports.downloadMagnet = downloadMagnet;