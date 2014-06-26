thrift = require('thrift');
fs = require('fs');
url = require('url');
workerAppJobs = require('./workerAppJobs');
logger = require('../logs/log4jsUtil').logger;
web = require('../../config/web.json');
Interface = require('../base/worker/thirft/CookieService.js');

exports.init = () ->  
	logger.debug('[worker]-workerApp.init');
	method = workerAppJobs.registerWorkerController();
	server = thrift.createServer(Interface, method, web.thriftOptions);
	server.listen(web.workerPort);