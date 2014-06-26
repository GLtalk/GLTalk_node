#所有的contorller都必须继承此类

clusterUtil = require('../../cluster/clusterUtil')
logger = require(APP_ROOT + '/logs/log4jsUtil').logger

class BaseController
	constructor : () ->
		@pathname = "/base"

	#外部调用方法
	execute : (req, res) ->
		try
			@main(req, res)
		catch error
			res.statusCode = 500
			logger.error(@pathname + ",Error:" + error)
			res.end(error)
	
	#主方法    
	main : (req, res) ->
		return

	getPath:()->
		return @pathname

exports.BaseController = BaseController