#所有的contorller都必须继承此类

clusterUtil = require('../../cluster/clusterUtil')
logger = require(APP_ROOT + '/logs/log4jsUtil').logger

class WorkerBaseController extends BaseController

	#worker向master发送消息
	sendToMaster : (data) ->
		logger.debug("sendToMaster is invoke.data is " + data)
		clusterUtil.workerSendToMaster(@pathname, data)

	#worker接受到master的消息
	receiveMasterMessage : (msg) ->
		logger.debug("receiveMasterMessage is invoke.msg is " + msg)
		return

exports.WorkerBaseController = WorkerBaseController