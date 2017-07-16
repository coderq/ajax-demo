const fs = require('fs');
const path = require('path');

fs.readdirSync(__dirname)
    .filter((controller) => 'index.js' != controller && /[a-zA-z]\w+\.js$/.test(controller))
    .forEach(file => {
        const name = (file.match(/([^\.]+)\.js/) || [])[1];
        exports[`${name.replace(/^[a-z]/, $ => $.toUpperCase())}Controller`] = require(path.join(__dirname, file));
    });