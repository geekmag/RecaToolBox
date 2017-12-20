var path = require('path');

module.exports = class Config {
    constructor() {
        this.configPath={};
        if(process.platform=='win32') {
            this.configPath = {
                RECATOOLBOX_DIR: '/recalbox/share/RecaToolBox',
                ROMS_DIR: 'D:\\Temp\\share\\roms',
                GAME_OUTPUT_PATH: 'D:\\Temp\\share\\Jey'
            };
        } else {
            this.configPath = {
                RECATOOLBOX_DIR: '/recalbox/share/RecaToolBox',
                ROMS_DIR: '/recalbox/share/roms',
                GAME_OUTPUT_PATH: '/recalbox/share/Jey'
            };
        };

        this.consolesConfig =[ {
            fullName: "Nintendo Entertainment System",
            shortName: "nes",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "N64",
            shortName: "n64",
            romsMask: "+(*.n64|*.zip)"
        } ];

        this.consolesConfig.forEach(element => {
            element.fullPath = path.join(this.configPath.ROMS_DIR, element.shortName);
        });

    }

    getConsoleConfig(consoleName) {
        return this.consolesConfig.find(console => {
            return (console.shortName==consoleName)
        });
    }

    getPaths() {
        return this.configPath;
    }

    getConsoles() {
        var result = [];
        this.consolesConfig.forEach(element => {
            result.push(element.shortName);
        });
        return result;
    };



}
