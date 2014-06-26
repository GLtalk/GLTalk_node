###
 * log4jsUtil.coffee
###
log4js = require('log4js')
logCfg = require(APP_ROOT + '/../config/log4js.json')

log4js.configure(logCfg)
logger = log4js.getLogger('console')
logger.setLevel('Debug')

exports.logger = logger