var DownloadModule = require('./DownloadModule/DownloadModule');



console.log("Config OK");
//var myMagnet="magnet:?xt=urn:btih:e1e9d490fee26857367d4291e813397b78828462&dn=CheckMyTorrentIPAddress+Tracking+Link&tr=http%3A%2F%2Fcheckmytorrentip.upcoil.com%2F";
var myMagnet="magnet:?xt=urn:btih:fcf1178fc7cd636694ba190016f9f86e68f57527&dn=The+Everything+Easy+French+Cookbook+By+Cecile+Delarue+EPUB&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.zer0day.to%3A1337&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337";

var myDownload = new DownloadModule();

myDownload.downloadMagnet(myMagnet,"outputhPath");
//downloadModule.direBonjour();


