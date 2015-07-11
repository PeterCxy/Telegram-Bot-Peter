request = require 'request'
auth = require './conf/auth.json'

class Telegram
	constructor: (@auth) ->

	callbackHandler: (error, response, body, callback) =>
		console.log body
		if body
			result = JSON.parse body
			if result.ok
				callback null, result
			else
				error = new Error 'result is not okay'
				callback error, result
		else
			callback error, null
	
	post: (method, data, callback) =>
		opts =
			url: 'https://api.telegram.org/bot' + @auth + '/' + method
			form: data
			method: 'POST'
		console.log opts.url
		request opts, (error, response, body) =>
			@callbackHandler error, response, body, callback
	
	# Multipart
	postUpload: (method, data, callback) =>
		opts =
			url: 'https://api.telegram.org/bot' + @auth + "/" + method
			formData: data
		console.log opts.url
		request.post opts, (error, response, body) =>
			@callbackHandler error, response, body, callback
	
	setWebhook: (url, callback) ->
		opts =
			url: url
		@post 'setWebHook', opts, (error, result) =>
			callback error
	
	sendMessage: (chat, text) ->
		opts =
			chat_id: chat
			text: text
		@post 'sendMessage', opts, (error, result) =>
			console.log "Message sent to #{chat}" if result.ok
	
	sendPhoto: (chat, stream) =>
		opts =
			chat_id: chat
			photo: stream
		@postUpload 'sendPhoto', opts, (error, result) =>
			@sendMessage chat, ':P' if !result.ok

module.exports = new Telegram auth.key
