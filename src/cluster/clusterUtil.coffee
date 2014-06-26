###
 * clusterUtil.coffee
###

masterAppMessage = require('./masterAppMessage');
workerAppMessage = require('./workerAppMessage');

#master把消息传递给worker
masterSendToWorker = (pathname, data) ->
	msgObj = {};
	msgObj.data = data;
	msgObj.pathname = pathname;
	msg = JSON.stringify(msgObj);
	masterAppMessage.send(msg);

#worker向master发送消息
workerSendToMaster = (pathname, data) ->
	msgObj = {};
	msgObj.data = data;
	msgObj.pathname = pathname;
	msg = JSON.stringify(msgObj);
	workerAppMessage.send(msg);

exports.masterSendToWorker = masterSendToWorker
exports.workerSendToMaster = workerSendToMaster