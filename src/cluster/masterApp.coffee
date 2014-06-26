connect = require ('connect');
fs = require('fs');
url = require('url');
cluster = require('cluster');
masterAppJobs = require('./masterAppJobs');
logger = require('../logs/log4jsUtil').logger;
web = require('../../config/web.json');

exports.init = () ->
	logger.debug('[master]-masterApp.init');   
	masterAppJobs.registerMasterController();
	app = connect();
	app.use(connect.cookieParser());
	app.use(connect.query());  
	app.use(connect.compress());  
	app.use(connect.bodyParser());
	app.use(masterAppJobs.doHttp);   
	app.listen(web.masterPort);