telegram = require './telegram'
server = require './server'

handleHello = (msg) ->
	console.log 'Hello command ' + msg.message_id
	telegram.sendMessage msg.chat.id, 'Hello, world'

exports.setupRoutes = () ->
	server.route '/hello', handleHello
