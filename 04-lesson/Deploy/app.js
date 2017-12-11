var express 	= require('express');
var app 		= express();

var port = process.env.PORT || 8080;
var color = process.env.COLOR || 'no color assigned yet';
var router = express.Router();

router.get('/', function(req, res){
	res.json({ 'color': color});
});

app.use('/', router);

app.listen(port);
console.log('Server Started at ' + port + '  ' +  'color :' + color);


