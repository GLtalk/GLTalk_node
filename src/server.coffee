process.env['APP_ROOT'] = __dirname;

masterApp = require('./cluster/masterApp');
workerApp = require('./cluster/workerApp');
cluster = require('cluster');
logger = require('./logs/log4jsUtil').logger;
numCPUs = require('os').cpus().length;

process.on 'uncaughtException', (err) ->
	logger.error('uncaughtException:' + err.stack)	

if cluster.isMaster
	logger.debug ("[master] start master...");
	
	for x in [0 .. numCPUs-1] 
		cluster.fork();
		
	masterApp.init();
	
	cluster.on('death',  (worker) -> 
		logger.debug ('[master] death: worker' + worker.id + ',pid:' + worker.process.pid);
		cluster.fork();
	);
	
	cluster.on('listening',  (worker, address) -> 
		logger.debug ('[master] listening: worker' + worker.id + ',pid:' + worker.process.pid + ', Address:' + address.address + ":" + address.port);
	);

else if cluster.isWorker
	workerApp.init();