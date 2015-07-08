telegram = require './telegram'
server = require './server'
parser = require './parser'
store = require './store'

help = require './conf/help.json'

unrecognized = (msg) ->
	telegram.sendMessage msg.chat.id, 'Unrecognized command, say what?'

exports.setupRoutes = ->

	server.route '/help', (msg) ->
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

	server.route '/hello', (msg) ->
		console.log 'Hello command ' + msg.message_id
		telegram.sendMessage msg.chat.id, 'Hello, world'

	server.route '/parse', (msg) ->
		console.log 'Parse command ' + msg.message_id
		options = parser.parse msg.text
		str = ""
		for opt in options
			str += opt + "\n"
		telegram.sendMessage msg.chat.id, str

	server.route '/remind', (msg) ->
		console.log 'Remind command ' + msg.message_id
		options = parser.parse msg.text
		if options.length == 2
			setTimeout =>
				telegram.sendMessage msg.chat.id, options[1]
			, parser.time options[0]
		else
			unrecognized()

	server.route '/parsetime', (msg) ->
		console.log 'Parse time command ' + msg.message_id
		options = parser.parse msg.text
		if options.length == 1
			telegram.sendMessage msg.chat.id, parser.time options[0]
		else
			unrecognized()
	
	server.route '/store-put', (msg) ->
		console.log 'Store put command'
		options = parser.parse msg.text
		if options.length == 1
			store.put 'simple-store', msg.chat.id, options[0], (err) ->
				if err
					telegram.sendMessage msg.chat.id, 'Stored nothing'
				else
					telegram.sendMessage msg.chat.id, 'successful'
		else
			unrecognized()
	
	server.route '/store-get', (msg) ->
		console.log 'Store get command'
		store.get 'simple-store', msg.chat.id, (err, data) ->
			if err or data.trim() == ''
				telegram.sendMessage msg.chat.id, 'Got nothing'
			else
				telegram.sendMessage msg.chat.id, data

	# Secret function: help for the BotFather
	server.route '/father', (msg) ->
		opt = ''
		for h in help
			opt += "#{h.cmd} - #{h.arg} #{h.des}\n"
		telegram.sendMessage msg.chat.id, opt

