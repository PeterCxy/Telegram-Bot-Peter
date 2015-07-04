request = require 'request'

telegram = require './telegram'
auth = require './conf/auth.json'

handleMessage = (msg) ->
	console.log "Handling message " + msg.message_id
	if msg.text.startsWith '/hello'
		telegram.sendMessage msg.chat.id, "Hello, world"

exports.handleRequest = (req, res, next) ->
	console.log req.params if req.params
	handleMessage req.params.message if req.params.update_id
	res.writeHead 200
	res.end()
	next()
