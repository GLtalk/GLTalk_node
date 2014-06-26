/**
 * @purpose: 提供一些常用的方法
 */

var fs = require('fs');
var http = require('http');
var net = require('net');
var gets = null;
var cookies = null;
var req = null;
var params = null;
var res =null;

var colored = function(msg, colorCode){
    return "\x1B[;" + colorCode + "m" + msg + "\x1B[0m";
};

// red
var errorColor = function(msg){
    return colored(msg, 31);
};

// yellow
var noticeColor = function(msg){
    return colored(msg, 33)
};

exports.errorColor = errorColor;
exports.noticeColor = noticeColor;

/**
 * @purpose: 删除字符串左侧空格
 * @return str
 */
var ltrim = function(str,char) {
	var i;
	var target = char ? char : ' ';
	for (i = 0; i < str.length; i++) {
		if (str.charAt(i) != target) {
			break;
		}
	}
	str = str.substring(i, str.length);
	return str;
};

/**
 * @purpose: 删除字符串右侧空格
 * @return str
 */
var rtrim = function(str,char) {
	var target = char ? char : ' ';
	var i;
	for (i = str.length - 1; i >= 0; i--) {
		if (str.charAt(i) != target) {
			break;
		}
	}
	str = str.substring(0, i + 1);
	return str;
};

/**
 * @purpose: 删除字符串两侧空格
 * @return str
 */
var trim = function(str,char) {
	str = ltrim(str,char);
	str = rtrim(str,char);
	return str;
};

/**
 *
 * @purpose: 判断字符串是否为undefined/null/空字串
 *
 */
var isBlank = function(str) {
	if (typeof str !== "undefined" && str !== null) { 
		var tstr = trim(str);
		if(tstr != null && tstr.length != 0){
			return false;
		}
	}
	return true;
}

/**
 * @purpose: 检查一个数组中某个键值是否存在
 * @return bool
 */
var isset = function(array, index) {
	return (typeof array[index] != 'undefined');
};

/**
 * @purpose: 检查一个数组中某个元素是否存在
 * @return bool
 */
var inArray = function(value, array) {
	for ( var i in array) {
		if (array[i] == value) {
			return true;
		}
	}

	return false;
};

/**
 * @purpose: get items number in an array or object
 * @return int
 */
var containerSize = function(obj) {
	var size = 0;
	for ( var i in obj) {
		size++;
	}
	return size;
};

//JSON.stringify只能转移中文字符，客户端获取后解码时可能发生错误，因此将其封转，以便进行替换
var json = {
	toString:function (jsonObj) {
		return JSON.stringify(jsonObj);
	},
	toObj:function (jsonStr) {
		return eval('(' + jsonStr + ')'); //TODO, FIXME: too dangers, use connect json module to replace this
	},
	loadFile:function(file) {
		return json.toObj(fs.readFileSync(file,'utf8'));
	}
};

/**
 * @purpose: IP地址转换成整数方法
 * @return int
 */
var ip2int = function(ip) {
	if(!ip||!net.isIP(ip)) {
		return -1;
	}
	var ipArr = ip.split('.');
	return (parseInt(ipArr[0]) * 16777216) + (parseInt(ipArr[1]) << 16) + (parseInt(ipArr[2]) << 8) + parseInt(ipArr[3]);
}

/**
 * @purpose: 返回JSON 数据格式
 * @return : json string
 */

var retJSON = function (jsonStr) {
	var jsonObj = JSON.parse(jsonStr);
	var json = '[';
	var count = 0;
	for (var name in jsonObj) {
		json += '[';
		var rm1 = true;
		for (var item in jsonObj[name]) {
			if (rm1) {
				json += '"' + jsonObj[name][item] + '",';
			} else {
				json += '"' + jsonObj[name][item] + '"';
			}
			rm1 = false;
		}
		// remove ","
		count++;
		if (count < jsonObj.length) {
			json += '],';
		} else {
			json += ']';
		}		
	}
	json += ']';

	return json;
}

/**
 * @purpose: 返回Html 数据格式
 * @return : html string
 */
var retHtml = function (jsonStr) {
	var jsonObj = JSON.parse(jsonStr);
	var tdNum = 8;
	var count = 0;
	var html = '<table valign="top" >';

	for (var name in jsonObj) {			
		if (count % tdNum === 0) {
			html += '<tr height="24">';
		}		
		for (var item in jsonObj[name]) {
			html += '<td>' + jsonObj[name][item] +'</td>'; 
			count++;
		}
		if (count % tdNum === 0) {
			html += '</tr>';
		}			
	}
	html += '</table>';
	return html;
}

var escapeHtml = function(text) {
	if(text==null) return null

	if ( typeof(text) != "string" )
		text = text.toString() ;

		text = text.replace(
			/&/g, "&amp;").replace(
			/"/g, "&quot;").replace(
			/</g, "&lt;").replace(
			/>/g, "&gt;");

    return text;
}

var formatVal = function(param, def){
	if(param == null || typeof(param) == undefined)
		return def
	else
		return param
}

var getDayEndExpires = function(){
	expires = new Date();
	expires.setHours(23, 59, 59)
	return expires;
}

exports.ltrim = ltrim;
exports.isset = isset;
exports.rtrim = rtrim;
exports.trim = trim;
exports.isBlank = isBlank;
exports.inArray = inArray;
exports.json = json;
exports.ip2int = ip2int;
exports.containerSize = containerSize;
exports.retJSON = retJSON;
exports.retHtml = retHtml;
exports.escapeHtml = escapeHtml
exports.formatVal = formatVal
exports.getDayEndExpires = getDayEndExpires