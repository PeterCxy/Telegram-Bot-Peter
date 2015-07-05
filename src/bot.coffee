restify = require 'restify'

telegram = require './telegram'
serv = require './server'
auth = require './conf/auth.json'

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

server.post "/" + auth.key, serv.handleRequest

serv.route '/hello', serv.handleHello

telegram.setWebhook auth.urlbase + "/" + auth.key, (error) =>
	if !error
		console.log 'Server registered.'

server.listen 23326, ->
	console.log 'Server up.'

