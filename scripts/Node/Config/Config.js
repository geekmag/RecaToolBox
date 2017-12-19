if(process.platform=='win32') {
    module.exports = {
        RECATOOLBOX_DIR: '/recalbox/share/RecaToolBox',
        ROMS_DIR: 'D:\\Temp\\share\\roms',
        GAME_OUTPUT_PATH: 'D:\\Temp\\share\\Jey'
    };
} else {
    module.exports = {
        RECATOOLBOX_DIR: '/recalbox/share/RecaToolBox',
        ROMS_DIR: '/recalbox/share/roms',
        GAME_OUTPUT_PATH: '/recalbox/share/Jey'
    };
};