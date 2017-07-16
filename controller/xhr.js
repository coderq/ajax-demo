const fs = require('fs');
const path = require('path');
const U = require('../library/util');

exports.miss = async (ctx) => {
    ctx.status = 404;
};

exports.success = async (ctx) => {
    const text = 'abcdefghijklmnopqrstuvwxyz';
    const length = 100000;
    ctx.status = 200;
    ctx.set({
        'Content-Length': new Buffer(text).length * length
    });
    new Array(length).fill(0).forEach((d, i) => {
        ctx.res.write(text);
    });
};

exports.timeout = async (ctx) => {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            ctx.body = 'done';
            resolve();
        }, 2000);
    });
};

exports.upload = async (ctx) => {
    const body = await U.body(ctx.req);
    return new Promise((resolve, reject) => {
        const file = path.join(__dirname, '../public', body.files.file.name);
        const readStream = fs.createReadStream(body.files.file.path);
        const writeStream = fs.createWriteStream(file);
        readStream.pipe(writeStream);
        readStream.on('end', () => {
            ctx.status = 200;
            ctx.body = {
                redirect: `/${body.files.file.name}`
            };
            resolve();
        });
    });
};