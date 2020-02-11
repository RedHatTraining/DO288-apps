var express = require('express');
app = express();

// read in the APP_MSG env var
var msg = 'Hello custom app';

var response;

app.get('/', function (req, res) {

    response = msg + '\n';
    //send the response to the client
    res.send(response);
 });

app.listen(8080, function () {
  console.log('Server listening on port 8080...');
});
