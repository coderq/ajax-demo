const formidable = require('formidable');

exports.body = async (req) => {
    return new Promise((resolve, reject) => {
        const form = new formidable.IncomingForm();
        form.parse(req, async (err, fields, files) => {
        	if(err) return reject(err);
        	resolve({
                fields: fields,
                files: files
            });
    	});
    });
}