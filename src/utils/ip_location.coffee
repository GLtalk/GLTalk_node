###
Author: 张弓，李辰，朱建生
Copyright 2005-, Funshion Online Technologies Ltd. All Rights Reserved
版权 2005-，北京风行在线技术有限公司 所有版权保护
This is UNPUBLISHED PROPRIETARY SOURCE CODE of Funshion Online Technologies Ltd.
the contents of this file may not be disclosed to third parties, copied or
duplicated in any form, in whole or in part, without the prior written
permission of Funshion Online Technologies Ltd.
这是北京风行在线技术有限公司未公开的私有源代码。本文件及相关内容未经风行在线技术有
限公司事先书面同意，不允许向任何第三方透露，泄密部分或全部; 也不允许任何形式的私自备份.
###

###
@purpose: 根据IP地址从国内IP库中获取相应的IP地域信息
@param ip IP地址
@returns IpInfo
###
getCNIpInfo = (ip) -> findIp(ipTable, ip)
exports.getCNIpInfo = getCNIpInfo

###
@purpose: 根据IP地址从国外IP库中获取相应的IP地域信息
@param ip IP地址
@returns IpInfo
###
getForeignIpInfo = (ip) -> findIp(ipForeignTable, ip)
exports.getForeignIpInfo = getForeignIpInfo

	
getIPInfo = (ip)->
	info = getCNIpInfo(ip)
	if info == NullIPInfo
		info = getForeignIpInfo(ip)
	info
exports.getIPInfo = getIPInfo

###
@purpose: 加载IP地址库文件至内存中
@param file
@param foreign
@returns Array
###
loadIPData = (file, foreign) ->
	result = []
	fs = require('fs')
	data = fs.readFileSync(file, 'utf8');   # using a blocking call to
												# ensure load data before any
												# request come in
	lines = data.split("\n")
	for line in lines
		if !line
			continue
		fields = line.split(',')
		if !foreign
			result.push(new IpInfo(fields[0], fields[1], fields[2], fields[3], fields[4]))
		else
			result.push(new IpInfo(fields[0], fields[1], fields[3], '', fields[4], fields[2]))

	return result

IpInfo = (ipStart, ipEnd, province, city, isp, country='CN') ->
	@ipStart = if ipStart then func.ip2int(ipStart) else ''
	@ipEnd = if ipEnd then func.ip2int(ipEnd) else ''
	@country = country
	@province = province || ''
	@city = city || ''
	@isp = isp || ''


NullIPInfo = new IpInfo()
exports.NullIPInfo = NullIPInfo

ipTable = []
ipForeignTable = []
path = require('path')
net = require('net')
func = require('./func')
initialized = false

# 如果模块未初始化，执行初始化操作
if !initialized
	# console.time('load ip data')
	
	# 加载国内IP库文件
	localIpFile = path.resolve(process.env['APP_ROOT'], '../config/areaIp/funshion.city.dat')
	ipTable = loadIPData(localIpFile, false)
	
	# 加载国外IP库文件
	ForeignIpFile = path.resolve(process.env['APP_ROOT'], '../config/areaIp/funshion.country.dat')
	ipForeignTable = loadIPData(ForeignIpFile, true)

	initialized = true

	# console.timeEnd('load ip data')
	# console.log(ipTable.length + ' china ip sections loaded')
	# console.log(ipForeignTable.length + ' foreign ip sections loaded')

###
@purpose: 查找IP地址库方法
@param table 所用IP库
@param ip IP地址
@returns obj
###
findIp = (table, ip) ->
	ipInt = func.ip2int(ip)
	high = table.length - 1
	low = 0

	while low <= high
		mid = Math.round(low + (high - low) / 2)
		ipSection = table[mid]
		if ipInt < ipSection.ipStart
			high = mid - 1
		else if ipInt > ipSection.ipEnd
			low = mid + 1
		else
			return ipSection
		
	return NullIPInfo


