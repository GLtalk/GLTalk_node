###
 * 创建redis客户端
###
logger = require('../../logs/cookieLogger');
util = require('util');
config = require('../../../config/redis.json');
redis = require("redis");
hashCode = require('hashcode').hashCode;

redisClientMap = {}
for key, value of config.redisList
	redisClientMap[key] = redis.createClient(value.port, value.host, value.option)
	redisClientMap[key].on("error", (err) ->
		if err
			logger.error "Error: " + err
	)


groupRedisCodeMap = {}
groupRedisMap = {}
for key, value of config.groupList
	for group in [value[0] .. value[1]]
		groupRedisMap[group] = redisClientMap[key]
		groupRedisCodeMap[group] = key


#获取redis客户端
getRedisClient = (mick) ->
	if not mick
		return null
	group = getRedisGroup(mick)
	return groupRedisMap[group]


#获取redis实例编号
getRedisCode = (mick) ->
	if not mick
		return null
	group = getRedisGroup(mick)
	return groupRedisCodeMap[group]


#根据mick获取分组号
getRedisGroup = (mick) ->
	group = hashCode().hash(mick) % config.groupNum
	if group < 0
		group = -group
	return group

exports.getRedisClient = getRedisClient
exports.getRedisCode = getRedisCode
exports.getRedisGroup = getRedisGroup

#redis常量
exports.delimiter = ":"
exports.keyPrefix = config.keyPrefix