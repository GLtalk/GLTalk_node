workerAppMessage = require('./workerAppMessage');
logger = require('../logs/log4jsUtil').logger;
registerController = require('./registerController');

jobsMap = {}
registerWorkerController = () ->
	logger.debug('[worker]-workerAppJobs.registerJobs');
	registerController.registerMasterController(jobsMap);
	process.on('message', (msg)->
		workerAppMessage.recvMsg(msg);
	);   
	return registerController.registerWorkerController();

getJobsMap = () ->
	return jobsMap;
              
exports.registerWorkerController = registerWorkerController;
exports.getJobsMap = getJobsMap;