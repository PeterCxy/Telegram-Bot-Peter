# Meizhi - Chinese of 'girls'
request = require 'request'
telegram = require './telegram'

unrecognized = (msg) ->
	console.log 'Nothing to do'
	# Should send back a message

randomDate = ->
	date = new Date
	year = Math.floor(Math.random() * (date.getFullYear() - 2015)) + 2015
	month = Math.floor(Math.random() * (date.getMonth() - 3)) + 5
	day = Math.floor(Math.random() * (if month == date.getMonth() + 1 then date.getDay() else 31)) + 1
	[year, month, day]

gank = (msg) ->
	[year, month, day] = randomDate()
	url = "http://gank.io/#{year}/#{if month < 10 then '0' + month else  month}/#{if day < 10 then '0' + day else day}"
	console.log url
	request.get url, (error, response, body) =>
		if !error
			regex = ///
				<img[^>]+src="([^">]+)"
			///
			url = (body.match regex)[1]
			if url? and url.startsWith 'http'
				telegram.sendPhoto msg.chat.id, (request url)
			else
				telegram.sendMessage msg.chat.id, ':P'
				

exports.handle = (msg, args) ->
	handler = if args.length == 1
		switch args[0]
			when 'gank' then gank
			else unrecognized
	else gank

	handler msg
