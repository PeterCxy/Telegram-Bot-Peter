request = require 'request'

telegram = require './telegram'
parser = require './parser'
auth = require './conf/auth.json'

routes = []

exports.route = (cmd, args, handler) ->
	r =
		command: cmd,
		numArgs: args,
		handler: handler
	routes.push r

isCommand = (arg, cmd) ->
	if (arg.indexOf '@') > 0
		[command, username] = arg.split '@'
		command == cmd and username == auth.name
	else
		arg == cmd

handleMessage = (msg) ->
	console.log "Handling message " + msg.message_id
	options = parser.parse msg.text
	cmd = if options[0].startsWith '/' then options[0][1...] else ''
	console.log 'Command: ' + cmd
	handled = no
	for r in routes
		if isCommand cmd, r.command
			if r.numArgs == options.length - 1 or r.numArgs < 0
				r.handler msg, options[1...]
			else
				console.log 'Wrong usage of ' + cmd
				telegram.sendMessage msg.chat.id, "Wrong usage. Consult the /help command for help."
			handled = yes
			break
	if !handled
		console.log 'Nothing done for ' + cmd

exports.handleRequest = (req, res, next) ->
	console.log req.params if req.params
	handleMessage req.params.message if req.params.update_id
	res.writeHead 200
	res.end()
	next()

exports.handleHello = (msg) ->
	console.log 'Hello command'
	telegram.sendMessage msg.chat.id, 'Hello, world'
