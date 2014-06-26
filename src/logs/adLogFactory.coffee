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

logCfg = require(APP_ROOT + '/../config/adLog.json');
Logger = require('./adLogger').Logger

loggerMap = {}

root = logCfg.root
for logger in logCfg.loggers
	loggerMap[logger.name] = new Logger(root, logger)


getLogger = (name) ->
	loggerMap[name]


exports.getLogger  = getLogger
