###
Author: 张兵
Copyright 2005-, Funshion Online Technologies Ltd. All Rights Reserved
版权 2005-，北京风行在线技术有限公司 所有版权保护
This is UNPUBLISHED PROPRIETARY SOURCE CODE of Funshion Online Technologies Ltd.
the contents of this file may not be disclosed to third parties, copied or
duplicated in any form, in whole or in part, without the prior written
permission of Funshion Online Technologies Ltd.
这是北京风行在线技术有限公司未公开的私有源代码。本文件及相关内容未经风行在线技术有
限公司事先书面同意，不允许向任何第三方透露，泄密部分或全部; 也不允许任何形式的私自备份.
###

fs = require('fs')
path = require('path')
util = require ('util')

require('../utils/date.js')

Logger = (logRoot, params)->
	@logParam = {
		root           : if logRoot.charAt(-1) == '/' then logRoot.slice(0, -1) else logRoot
		name           : params.name
		logFilePattern : params.logFilePattern
		datePattern    : params.datePattern
		interval       : params.interval * 1000
		disable        : params.disable? and params.disable
		logFD          : null
		expectTime     : 0
		}
	return

# 特殊字符替换列表
# specialChars ={',':'","'}
Logger.prototype.log = (message)->
	if @logParam.disable then return

	@openExpectLogFile()

	# 扩展功能：参数可以为字符串数组，目的是为统一替换特殊字符，自动加换行符
	if Array is message.constructor
		message = message.join(',')+'\n'
	sb = new Buffer(message)
	fs.write(@logParam.logFD, sb, 0, sb.length, null, (err)->
				if err? then throw err
			)
	return

Logger.prototype.openExpectLogFile = ()->
	curTime = getLogTimeStamp(@logParam.interval)
	if curTime isnt @logParam.expectTime
		@logParam.expectTime = curTime
		if !@logParam.logFD
			rotateLogFileSync(@logParam, curTime)
		else
			rotateLogFile(@logParam, curTime)
	return
		
#第一次打开日志文件
rotateLogFileSync = (params, time) ->
	logFile = getLogFilename(params, time)
	logDir = getLogDir(params, time)
	if not fs.existsSync logDir
		try
			fs.mkdirSync logDir, '775'
		catch err
			if err.code isnt "EEXIST"
				throw err
	try
		if params.logFD
			fs.closeSync params.logFD
		params.logFD = fs.openSync logFile, 'a', '664'
	catch err
		throw err
	return

#滚动日志文件
rotateLogFile = (params, time) ->
	logFile = getLogFilename(params, time)
	logDir = getLogDir(params, time)
	#FIXME 应修改为异步
	if not fs.existsSync logDir
		try
			fs.mkdirSync logDir, '775'
		catch err
			if err.code  isnt "EEXIST"
				throw err
	openLogFile logFile, params
	return

openLogFile = (logFile, params)->
	fs.open logFile, 'a', '664', (err, fd)->
		if err?
			throw err
		tmpFD = params.logFD
		params.logFD = fd
		if tmpFD?
			fs.close tmpFD, (err)->
				if err?
					throw err

getLogTimeStamp = (interval, time)->
	theTime = if time? then time else new Date()
	
	localTime = theTime.getTime()
	localTime -= theTime.getTimezoneOffset()*60*1000
	localTime = parseInt(localTime / interval) * interval
	localTime += theTime.getTimezoneOffset()*60*1000
	
	localTime
		
getLogDir = (params, time)->
	logTime = if time? then new Date(time) else new Date()
	path.join(params.root, logTime.format('yyyyMMdd'))

getLogFilename = (params, time)->
	logTime = if time? then new Date(time) else new Date()
	dayString = logTime.format("yyyyMMdd")
	path.join(params.root, dayString, util.format(params.logFilePattern, logTime.format(params.datePattern)))

exports.Logger = Logger
exports.getLogTimeStamp = getLogTimeStamp