telegram = require './telegram'
server = require './server'
parser = require './parser'

unrecognized = (msg) ->
	telegram.sendMessage msg.chat.id, 'Unrecognized command, say what?'

handleHello = (msg) ->
	console.log 'Hello command ' + msg.message_id
	telegram.sendMessage msg.chat.id, 'Hello, world'

handleParse = (msg) ->
	console.log 'Parse command ' + msg.message_id
	options = parser.parse msg.text
	str = ""
	for opt in options
		str += opt + "\n"
	telegram.sendMessage msg.chat.id, str

handleRemind = (msg) ->
	console.log 'Remind command ' + msg.message_id
	options = parser.parse msg.text
	if options.length == 2
		setTimeout =>
			telegram.sendMessage msg.chat.id, options[1]
		, options[0]
	else
		unrecognized()

handleParseTime = (msg) ->
	console.log 'Parse time command ' + msg.message_id
	options = parser.parse msg.text
	if options.length == 1
		telegram.sendMessage msg.chat.id, parser.time options[0]
	else
		unrecognized()

exports.setupRoutes = () ->
	server.route '/hello', handleHello
	server.route '/parse', handleParse
	server.route '/parsetime', handleParseTime
	server.route '/remind', handleRemind
