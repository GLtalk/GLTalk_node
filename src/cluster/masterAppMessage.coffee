connect = require ('connect');
fs = require('fs');
url = require('url');
cluster = require('cluster');
workerAppMessage = require('./workerAppMessage');
masterAppJobs = require('./masterAppJobs');
logger = require('../logs/log4jsUtil').logger;

sendMessage = (msg) -> 
	for id of cluster.workers
		cluster.workers[id].send(msg);
        
recvMsg = (msg) ->    
	msgObj = JSON.parse(msg);
	pathname = msgObj.pathname;
	jobsMap = masterAppJobs.getJobsMap();
	if jobsMap[pathname] != null
		jobsMap[pathname].receiveWorkerMessage(msgObj.data);
	
registerOnMessage = () ->
	logger.debug('[master]-masterAppJobs.registerOnMessage');
	Object.keys(cluster.workers).forEach((id)-> 
		cluster.workers[id].on('message', recvMsg)
		logger.debug("master registerOnMessage");
	);


exports.registerOnMessage = registerOnMessage;
exports.send = sendMessage;
exports.recvMsg = recvMsg;