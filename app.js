const session = require('koa-generic-session');
const convert = require('koa-convert');
const serve = require('koa-static');
const route = require('koa-route');
const views = require('koa-views');
const CSRF = require('koa-csrf');
const Koa = require('koa');
const { 
    HomeController,
    XhrController,
} = require('./controller');

const app = new Koa();
const port = process.argv[2] || '3000';

app.keys = [ 'this', 'is', 'a', 'demo' ];
app.use(serve(__dirname + '/public'));
app.use(convert(session()));
app.use(views('view', {
    root: __dirname + '/view',
    default: 'swig',
    extension: 'swig'
}));
app.use(new CSRF());

app.use(route.post('/xhr/upload', XhrController.upload));

app.use(route.get('/', HomeController.index));
app.use(route.get('/xhr/miss', XhrController.miss));
app.use(route.get('/xhr/success', XhrController.success));
app.use(route.get('/xhr/timeout', XhrController.timeout));
app.use(route.get('/xhr/noresponse', XhrController.noresponse));

app.listen(port, () => console.log(`Listen on port ${port}`));