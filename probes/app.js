var express = require('express'),
  app = express();

var port = process.env.PORT || process.env.OPENSHIFT_NODEJS_PORT || 8080,
  ip = process.env.IP || process.env.OPENSHIFT_NODEJS_IP || '0.0.0.0',
  healthy = true,
  ready = true;

var route = express.Router();

app.use('/', route);

// A route that says hello
route.get('/', function (req, res) {
  res.send('Hello! This is the index page for the app.\n');
});

// A route that returns readiness status
route.get('/ready', function (req, res) {
  var now = Math.floor(Date.now() / 1000);
  var lapsed = now - started;
  if (ready && (lapsed > 30)) {
    console.log('ping /ready => pong [ready]');
    res.send('Ready for service requests...\n');
  }
  else {
    console.log('ping /ready => pong [notready]');
    res.status(503);
    res.send('Error! Service not ready for requests...\n');
  }
});

// A route that returns health status
route.get('/healthz', function (req, res) {
  if (healthy) {
    console.log('ping /healthz => pong [healthy]');
    res.send('OK\n');
  }
  else {
    console.log('ping /healthz => pong [unhealthy]');
    res.status(503);
    res.send('Error! App not healthy!\n');
  }
});

// This route handles switching the state of the app
route.route('/flip').get(function (req, res) {
  var flag = req.query.op;
  if (flag === 'kill-health') {
    console.log('Received kill request for health probe.');
    healthy = false;
    res.send('Switched app state to unhealthy...\n');
  } else if (flag === "awaken-health") {
    console.log('Received awaken request for health probe.');
    healthy = true;
    res.send('Switched app state to healthy...\n');
  } else if (flag === 'kill-ready') {
    console.log('Received kill request for readiness probe.');
    ready = false;
    res.send('Switched app state to not ready...\n');
  } else if (flag === 'awaken-ready') {
    console.log('Received awaken request for readiness probe.');
    ready = true;
    res.send('Switched app state to ready...\n');
  } else {
    res.send('Error! unknown flag...\n');
  }
});

app.listen(port, ip);
console.log('nodejs server running on http://%s:%s', ip, port);
var started = Math.floor(Date.now() / 1000);

module.exports = app;
