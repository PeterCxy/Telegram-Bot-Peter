# Meizhi - Chinese of 'girls'
request = require 'request'
telegram = require './telegram'

unrecognized = (msg) ->
	console.log 'Nothing to do'
	# Should send back a message

randomDate = (startYear, startMonth) ->
	date = new Date
	year = Math.floor(Math.random() * (date.getFullYear() - startYear + 2)) + startYear - 1
	month = Math.floor(Math.random() * (date.getMonth() - startMonth + 2)) + startMonth
	day = Math.floor(Math.random() * (if month == date.getMonth() + 1 then date.getDay() else 31)) + 1
	[year, month, day]

addZero = (num) ->
	if num < 10 then '0' + num else num

gank = (msg) ->
	[year, month, day] = randomDate 2015, 5
	url = "http://gank.io/#{year}/#{addZero month}/#{addZero day}"
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
				
meizitu = (msg) ->
	[year, month, day] = randomDate 2015, 1
	url = "http://pic.meizitu.com/wp-content/uploads/#{year}a/#{addZero month}/#{addZero day}/#{addZero Math.floor(Math.random() * 10) + 1}.jpg"
	console.log url
	stream = request url
	telegram.sendPhoto msg.chat.id, stream if stream

exports.handle = (msg, args) ->
	handler = if args.length == 1
		switch args[0]
			when 'gank' then gank
			when 'meizitu' then meizitu
			else unrecognized
	else gank

	handler msg
