Telegram-Bot-Peter
---
My playground with Telegram's new Bot API

Deployment
---
Create your own bot, create `conf/auth.json`

> {  
>   "key": "your-auth-token",  
>   "name": "username-of-your-bot',  
>   "urlbase": "your-callback-url"  
> }

Note: The real callback url is `urlbase/key`

and `conf/memcached.json`

> {  
>   "server": "address-of-your-memcached-server"  
> }

then run `npm install` and `cake build`. Run `node bot.js` in `out` dir (the out dir must be the work directory) and then set up a reverse proxy to the port 23326.
