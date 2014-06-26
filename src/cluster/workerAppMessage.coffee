fs = require('fs');
cluster = require('cluster');
workerAppJobs = require('./workerAppJobs');
masterAppMessage = require('./masterAppMessage');
logger = require('../logs/log4jsUtil').logger;

recvMsg = (msg) ->    
	msgObj = JSON.parse(msg);
	pathname = msgObj.pathname;
	jobsMap = workerAppJobs.getJobsMap();
	if jobsMap[pathname]
		jobsMap[pathname].receiveMasterMessage(msgObj.data);

sendMessage = (msg) ->
	if cluster.worker
		process.send(msg)
	else
		logger.warn("this process is not worker, so it doesn't send message.")
        
exports.recvMsg = recvMsg;
exports.send = sendMessage;