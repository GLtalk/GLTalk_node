###
 * BaseMongo.coffee
###
mongoose = require('mongoose');
config = require(APP_ROOT + '/../config/mongo.json');
logger = require('../../logs/cookieLogger');

mongodbMap = {}
for key, value of config.mongoList
	mongoUri = "mongodb://" + value.user + ":" + value.pass + "@" + value.host + "/" + value.db;
	mongodbMap[key] = mongoose.createConnection(mongoUri);
	mongodbMap[key].on("error", (err) ->
		if err
			logger.error "Error: " + err
	)


redisMongoMap = {}
for key, value of config.groupList
	for redisCode in value
		redisMongoMap[redisCode] = mongodbMap[key]


getMongodb = (redisCode) ->
	if not redisCode
		return null
	return redisMongoMap[redisCode]


exports.getMongodb = getMongodb
exports.cookieTableNamePrefix = config.cookieTableNamePrefix