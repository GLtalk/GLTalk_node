#所有的contorller都必须继承此类

clusterUtil = require('../../cluster/clusterUtil')
logger = require(APP_ROOT + '/logs/log4jsUtil').logger

class MasterBaseController extends BaseController

	#master把消息传递给worker
	sendToWorker : (data) ->
		logger.debug("sendToWorker is invoke.data is " + data)
		clusterUtil.masterSendToWorker(@pathname, data)

	#master接收到worker的消息
	receiveWorkerMessage : (msg) ->
		logger.debug("receiveWorkerMessage is invoke.msg is " + msg)
		return

exports.MasterBaseController = MasterBaseController