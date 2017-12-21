var path = require('path');

module.exports = {
    entry: './RecaNode.js',
    target: 'node',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'RecaNode.js'
    }
};