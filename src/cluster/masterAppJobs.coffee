connect = require ('connect');
fs = require('fs');
path = require('path');  
url = require('url');
cluster = require('cluster');
registerController = require('./registerController');
masterAppMessage = require('./masterAppMessage');
logger = require('../logs/log4jsUtil').logger;

jobsMap = {}
registerMasterController = () ->
	logger.debug('[master]-masterAppJobs.registerController');
	registerController.registerMasterController(jobsMap);
	masterAppMessage.registerOnMessage();

doHttp = (req, res) ->
	pathname = url.parse(req.url).pathname;
	if jobsMap[pathname]
		res.statusCode = 200;
		res.setHeader('Content-Type','text/html');
		jobsMap[pathname].execute(req, res);
	else
		res.statusCode = 404;
		res.write("This request URL " + pathname + " was not found on this server.");
		res.end();

getJobsMap = () ->
	return jobsMap;

exports.registerMasterController = registerMasterController;
exports.doHttp = doHttp;
exports.getJobsMap = getJobsMap;