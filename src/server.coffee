request = require 'request'

telegram = require './telegram'
auth = require './conf/auth.json'

routes = []

exports.route = (command, handler) ->
	r =
		command: command
		handler: handler
	routes.push r

handleMessage = (msg) ->
	console.log "Handling message " + msg.message_id
	handler = (arg) ->
		console.log 'Nothing done for ' + msg.text
	l = 0
	for r in routes
		if (msg.text.startsWith r.command) and (r.command.length >= l)
			handler = r.handler
			l = r.command.length
	handler msg

exports.handleRequest = (req, res, next) ->
	console.log req.params if req.params
	handleMessage req.params.message if req.params.update_id
	res.writeHead 200
	res.end()
	next()

exports.handleHello = (msg) ->
	console.log 'Hello command'
	telegram.sendMessage msg.chat.id, 'Hello, world'
