telegram = require './telegram'
server = require './server'
parser = require './parser'

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

exports.setupRoutes = () ->
	server.route '/hello', handleHello
	server.route '/parse', handleParse
