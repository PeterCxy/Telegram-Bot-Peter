restify = require 'restify'
cluster = require 'cluster'

telegram = require './telegram'
serv = require './server'
functions = require './functions'
auth = require './conf/auth.json'

exports = module.exports = launch: ->

	if cluster.isMaster
		cluster.fork() for i in [1...8]

	server = restify.createServer
		name: 'telegram-bot-peter'
		version: '1.0.0'

	server.use restify.acceptParser server.acceptable
	server.use restify.queryParser()
	server.use restify.bodyParser()

	server.pre (req, res, next) =>
		console.log "---- Incoming Request ----"
		res.write "This is Peter's Telegram bot @PeterCxyBot"
		res.writeHead 404
		next()
		res.end()

	server.post "/" + auth.key, serv.handleRequest

	functions.setupRoutes()

	if cluster.isMaster
		telegram.setWebhook auth.urlbase + "/" + auth.key, (error) =>
			if !error
				console.log 'Server registered.'
	else
		server.listen 23326, ->
			console.log 'Server up.'

