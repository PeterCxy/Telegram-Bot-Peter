telegram = require './telegram'
server = require './server'
parser = require './parser'

help = require './conf/help.json'

unrecognized = (msg) ->
	telegram.sendMessage msg.chat.id, 'Unrecognized command, say what?'

handleHelp = (msg) ->
	opt = ""
	options = parser.parse msg.text
	if options.length == 0
		for h in help
			opt += "/#{h.cmd} #{h.arg}\n#{h.des}\n\n"
	else
		for h in help
			if h.cmd == options[0]
				opt += "/#{h.cmd} #{h.arg}\n#{h.des}\n\n"
				break
		opt = 'Helpless' if opt == ''
	telegram.sendMessage msg.chat.id, opt

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
		, parser.time options[0]
	else
		unrecognized()

handleParseTime = (msg) ->
	console.log 'Parse time command ' + msg.message_id
	options = parser.parse msg.text
	if options.length == 1
		telegram.sendMessage msg.chat.id, parser.time options[0]
	else
		unrecognized()

# Secret function: help for the BotFather
handleFather = (msg) ->
	opt = ''
	for h in help
		opt += "#{h.cmd} - #{h.arg} #{h.des}\n"
	telegram.sendMessage msg.chat.id, opt

exports.setupRoutes = () ->
	server.route '/help', handleHelp
	server.route '/hello', handleHello
	server.route '/parse', handleParse
	server.route '/parsetime', handleParseTime
	server.route '/remind', handleRemind
	server.route '/father', handleFather
