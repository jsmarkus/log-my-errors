
/*
 * GET home page.
 */

exports.index = function(req, res) {
    res.render('index', { title: 'LogMyErrors' });
};

exports.log = function(req, res) {
    var data = {
        type      : req.param('type')
        , message : req.param('message')
        , code    : req.param('code')
        , errtype : req.param('errtype')
        , file    : req.param('file')
        , line    : req.param('line')
        , trace   : req.param('trace')
        , context : req.param('context')
    };
    res.json(true, 200);
    var io = req.app.get('io');
    io.sockets.in('logs').emit('log', data);
};