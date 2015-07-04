request = require 'request'
auth = require './conf/auth.json'

class Telegram
	constructor: (@auth) ->
	
	post: (method, data, callback) ->
		opts =
			url: 'https://api.telegram.org/bot' + @auth + '/' + method
			form: data
			method: 'POST'
		console.log opts.url
		request opts, (error, response, body) ->
			console.log body
			if body
				result = JSON.parse body
				if result.ok
					callback null, result
				else
					error = new Error description
					callback error, result
			else
				callback error, null
	
	setWebhook: (url, callback) ->
		opts =
			url: url
		this.post 'setWebHook', opts, (error, result) =>
			callback error
	
	sendMessage: (chat, text) ->
		opts =
			chat_id: chat
			text: text
		this.post 'sendMessage', opts, (error, result) =>
			console.log "Message" + result.message_id + " sent" if result.message_id

module.exports = new Telegram auth.key
