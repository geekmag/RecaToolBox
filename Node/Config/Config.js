var path = require('path');

module.exports = class Config {
    constructor() {
        // DOS encore à gérer, ainnsi que msx/MSX1/MSX2, O2EM, scummvm
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
                GAME_OUTPUT_PATH: '/recalbox/share/roms/'
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
        },{
            fullName: "Game & Watch",
            shortName: "gw",
            romsMask: "+(*.mgw|*.zip)"
        },{
            fullName: "Amstrad CPC",
            shortName: "amstradcpc",
            romsMask: "+(*.dsk|*.zip)"
        },{
            fullName: "Apple II",
            shortName: "apple2",
            romsMask: "+(*.nib|*.do|*.po|*.dsk)"
        },{
            fullName: "Atari 2600",
            shortName: "atari2600",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Atari 7800",
            shortName: "atari7800",
            romsMask: "+(*.a78|*.zip)"
        },{
            fullName: "Atari ST",
            shortName: "atarist",
            romsMask: "+(*.st|*.stx|*.ipf|*.zip)"
        },{
            fullName: "C64",
            shortName: "c64",
            romsMask: "+(*.d64|*.zip)"
        },{
            fullName: "CaveStory",
            shortName: "cavestory",
            romsMask: "+(*.d64|*.zip)"
        },{
            fullName: "ColeCoVision",
            shortName: "colecovision",
            romsMask: "+(*.col|*.zip)"
        },{
            fullName: "DreamCast",
            shortName: "dreamcast",
            romsMask: "+(*.gdi|*.cdi|*.chd)"
        },{
            fullName: "Final Burn Alpha",
            shortName: "fba",
            romsMask: "+(*.zip|*.fba)"
        },{
            fullName: "Final Burn Alpha - Libretro",
            shortName: "fba_libretro",
            romsMask: "+(*.zip|*.fba)"
        },{
            fullName: "FDS",
            shortName: "fds",
            romsMask: "+(*.zip|*.fds)"
        },{
            fullName: "GameGear",
            shortName: "gamegear",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Game Boy",
            shortName: "gb",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Game Boy Advanced",
            shortName: "gba",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Game Boy Color",
            shortName: "gbc",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "LUA - Lutro",
            shortName: "lutro",
            romsMask: "+(*.lua|*.lutro|*.zip)"
        },{
            fullName: "Lynx",
            shortName: "lynx",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Mamee",
            shortName: "mame",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Master System",
            shortName: "mastersystem",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Megadrive",
            shortName: "megadrive",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Neo Geo",
            shortName: "neogeo",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Neo Geo Pocket",
            shortName: "ngp",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Neo Geo Pocket Color",
            shortName: "ngpc",
            romsMask: "+(*.ngc|*.zip)"
        },{
            fullName: "PC Engine",
            shortName: "pcengine",
            romsMask: "+(*.pce|*.zip)"
        },{
            fullName: "PC Engine CD",
            shortName: "pcenginecd",
            romsMask: "+(*.ccd|*.cue)"
        },{
            fullName: "Doom",
            shortName: "prboom",
            romsMask: "+(*.wad)"
        },{
            fullName: "PlayStation Portable",
            shortName: "psp",
            romsMask: "+(*.cso|*.iso|*.zip)"
        },{
            fullName: "PlayStation",
            shortName: "psx",
            romsMask: "+(*.cue|*.zip)"
        },{
            fullName: "Sega 32X",
            shortName: "sega32x",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Sega CD",
            shortName: "segacd",
            romsMask: "+(*.cue|*.zip)"
        },{
            fullName: "SG1000",
            shortName: "sg1000",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "SNES",
            shortName: "snes",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "SuperGrafx",
            shortName: "supergrafx",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "Vectrex",
            shortName: "vectrex",
            romsMask: "+(*.vec|*.zip)"
        },{
            fullName: "Virtualbox",
            shortName: "virtualboy",
            romsMask: "+(*.zip|*.zip)"
        },{
            fullName: "WSWan",
            shortName: "wswan",
            romsMask: "+(*.ws|*.wsc|*.zip)"
        },{
            fullName: "WSWan Color",
            shortName: "wswanc",
            romsMask: "+(*.ws|*.wsc|*.zip)"
        },{
            fullName: "ZX81",
            shortName: "zx81",
            romsMask: "+(*.tzx|*.p|*.zip)"
        },{
            fullName: "ZX Spectrum",
            shortName: "zxspectrum",
            romsMask: "+(*.tzx|*.tap|*.z80|*.rzx|*.scl|*.trd|*.zip)"
        }

        ];

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
