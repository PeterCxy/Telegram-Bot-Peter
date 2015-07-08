# Variables storage for multi processing
conf = require './conf/memcached.json'
Memcached = require 'memcached'

cache = new Memcached conf.server,
	retries: 10,
	algorithm: 'md5',
	timeout: 1500,
	reconnect: 2000

lifetime = 5 * 60 * 60

key = (type, id) ->
	type + ':' + id

exports.put = (type, id, value, callback) ->
	cache.set (key type, id), value, lifetime, callback

exports.get = (type, id, callback) ->
	cache.get (key type, id), callback

