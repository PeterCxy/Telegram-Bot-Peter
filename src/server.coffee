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
	for r in routes
		r.handler msg if msg.text.startsWith r.command

exports.handleRequest = (req, res, next) ->
	console.log req.params if req.params
	handleMessage req.params.message if req.params.update_id
	res.writeHead 200
	res.end()
	next()

exports.handleHello = (msg) ->
	console.log 'Hello command'
	telegram.sendMessage msg.chat.id, 'Hello, world'
