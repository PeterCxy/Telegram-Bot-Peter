# Meizhi - Chinese of 'girls'
request = require 'request'
telegram = require './telegram'

unrecognized = (msg) ->
	console.log 'Nothing to do'
	# Should send back a message

gank = (msg) ->
	# Shouls use random url
	request.get 'http://gank.io/2015/07/09', (error, response, body) =>
		if !error
			console.log body
			regex = ///
				<img[^>]+src="([^">]+)"
			///
			url = (body.match regex)[1]
			telegram.sendPhoto msg.chat.id, (request url) if url
				

exports.handle = (msg, args) ->
	handler = if args.length == 1
		switch args[0]
			when 'gank' then gank
			else unrecognized
	else gank

	handler msg
