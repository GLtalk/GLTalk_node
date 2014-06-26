###
 * 解析web.json文件
###
web = require('../../config/web.json');
fs = require('fs');
path = require('path');
logger = require('../logs/log4jsUtil').logger;
workerController = require('../base/worker/controller/WorkerController').workerController;

getAppRoot = () ->
	return process.env['APP_ROOT'];

registerMasterController = (jobsMap) ->
	jobsRoot = getAppRoot() + web.masterPackage;
	filenames = fs.readdirSync(jobsRoot);
	if filenames.length > 0
		for filename in filenames
			if filename.match("^[A-Za-z0-9_]*Controller.(coffee|js)$")
				MyController = require(path.join(jobsRoot, filename)).MyController;
				myController = new MyController();
				jobsMap[myController.getPath()] = myController;
	else
		logger.debug("No controller.");

registerWorkerController = () ->
	return workerController;

exports.registerMasterController = registerMasterController;
exports.registerWorkerController = registerWorkerController;