#!/usr/bin/env node
/**
 * Module dependencies.
 */

var express = require('express')
    , routes = require('./routes')
    , http = require('http')
    , path = require('path')
    , socket_io = require('socket.io')
    , io
;

var app = express();

var browserify = require('browserify');
var bundle = browserify(__dirname + '/client/index.coffee');

app.configure(function(){
    app.set('port', process.env.PORT || 7001);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.use(express.favicon());
    // app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser('your secret here'));
    app.use(express.session());
    app.use(app.router);
    app.use(express['static'](path.join(__dirname, 'public')));
    app.use(bundle);
});

app.configure('development', function(){
    app.use(express.errorHandler());
});

app.get('/', routes.index);
app.post('/api/v1/log', routes.log);

//--------------------------------------------------------------------

var server = http.createServer(app).listen(app.get('port'), function(){
    console.log("LogMyErrors server listening on port " + app.get('port'));
});

//--------------------------------------------------------------------

io = socket_io.listen(server);

io.enable('browser client minification');
io.enable('browser client etag'        );
io.enable('browser client gzip'        );
io.set   ('log level', 0               );

io.sockets.on('connection', function (client) {
    client.join('logs');
});

app.set('io', io);