var express = require('express'),
    app     = express(),
    os = require('os'),
    hostname = os.hostname();

var port = process.env.PORT || process.env.OPENSHIFT_NODEJS_PORT || 8080,
    ip   = process.env.IP   || process.env.OPENSHIFT_NODEJS_IP || '0.0.0.0';

var route = express.Router();

app.use('/', route);

route.get('/', function(req, res) {
    res.send('Hello! This is version 1 the app.\n');
});

app.listen(port, ip);
console.log('nodejs server running on http://%s:%s', ip, port);
console.log('Date is -> '+new Date().toUTCString());
console.log('The hostname is -> '+hostname);
module.exports = app;
