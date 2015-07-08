telegram = require './telegram'
server = require './server'
parser = require './parser'
store = require './store'

help = require './conf/help.json'

exports.setupRoutes = ->

	server.route 'help', -1, (msg, args) ->
		opt = ""
		if args.length == 0
			for h in help
				opt += "/#{h.cmd} #{h.arg}\n#{h.des}\n\n"
		else
			for h in help
				if h.cmd == args[0]
					opt += "/#{h.cmd} #{h.arg}\n#{h.des}\n\n"
					break
			opt = 'Helpless' if opt == ''
		telegram.sendMessage msg.chat.id, opt

	server.route 'hello', 0, (msg) ->
		telegram.sendMessage msg.chat.id, 'Hello, world'

	server.route 'parse', -1, (msg, args) ->
		str = ""
		for opt in args
			str += opt + "\n"
		telegram.sendMessage msg.chat.id, str

	server.route 'remind', 2, (msg, args) ->
		setTimeout =>
			telegram.sendMessage msg.chat.id, args[1]
		, parser.time args[0]

	server.route 'parsetime', 1, (msg, args) ->
		telegram.sendMessage msg.chat.id, parser.time args[0]
	
	server.route 'store-put', 1, (msg, args) ->
		store.put 'simple-store', msg.chat.id, args[0], (err) ->
			if err
				telegram.sendMessage msg.chat.id, 'Stored nothing'
			else
				telegram.sendMessage msg.chat.id, 'successful'
	
	server.route 'store-get', 0, (msg) ->
		store.get 'simple-store', msg.chat.id, (err, data) ->
			if err or data.trim() == ''
				telegram.sendMessage msg.chat.id, 'Got nothing'
			else
				telegram.sendMessage msg.chat.id, data

	# Secret function: help for the BotFather
	server.route 'father', 0, (msg) ->
		opt = ''
		for h in help
			opt += "#{h.cmd} - #{h.arg} #{h.des}\n"
		telegram.sendMessage msg.chat.id, opt

