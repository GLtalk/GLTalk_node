###
 * 工具方法
###

String.prototype.endWith=(str) ->
	if not str
  		return false
	if @substring(@length-str.length)==str
  		return true
	else
  		return false
	return true

String.prototype.startWith=(str) ->
	if not str
 		return false;
	if @substr(0,str.length)==str
    	return true;
	else
  		return false;
	return true;


getRandomNum = (min, max) ->   
    range = max - min;   
    rand = Math.random();   
    return(min + Math.round(rand * range));
  
isRandomIn = (targetRand) ->
    rand = Math.random();
    return rand<targetRand

getIp = (req) ->
	headers = req.headers
	if headers['x-real-ip']
		return headers['x-real-ip'].split(',')[0]
	if headers['x-forwarded-for']
		return headers['x-forwarded-for'].split(',')[0]
	return req.connection.remoteAddress

isExpired = (cookie) ->
	if cookie? and cookie.expire?
		expire = cookie.expire
		date = Date.parse( expire.replace(/-/g,"/") );
		now = new Date();
		if date >= now
			return false
		else
			return true
	else 
		return false
		
compareDateTime = (preDate, blaDate) ->
	preDate = Date.parse( preDate.replace(/-/g,"/") );
	blaDate = Date.parse( blaDate.replace(/-/g,"/") );
	if preDate > blaDate
		return 1
	else if preDate is blaDate
		return 0
	else return -1

compareToNowDate = (date) ->
	preDate = Date.parse( date.replace(/-/g,"/") )
	now = new Date()
	if  preDate > now
		return 1
	else if preDate is now
		return 0
	else return -1

##-1:之前设置的过期时间是max过期时间,不需要重新设置
##-2:没有过期时间	
##return大于0，表示需要重新设置过期时间，返回值就是，过期时间戳		
getMaxExpireDate = (maxDateTime, expireExist) ->
	if !maxDateTime and expireExist < 0
		return -2
	if !maxDateTime and expireExist > 0
		return -1
		
	maxtime = new Date(maxDateTime).getTime()
	if maxDateTime and expireExist < 0
		return maxtime
	
	##之前设置的过期时间
	milliseconds=new Date().getTime()
	expireExist = milliseconds + expireExist
	if expireExist >= maxtime
		return -1 
	return maxtime
	
exports.getRandomNum = getRandomNum
exports.isRandomIn = isRandomIn
exports.getIp = getIp
exports.isExpired = isExpired
exports.compareDateTime = compareDateTime
exports.getMaxExpireDate = getMaxExpireDate
exports.compareToNowDate = compareToNowDate