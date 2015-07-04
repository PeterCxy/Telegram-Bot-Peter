Telegram-Bot-Peter
---
My playground with Telegram's new Bot API

Deployment
---
Create your own bot, create `conf/auth.json`

> {
>   "key": "your-auth-token",
>   "urlbase": "your-callback-url"
> }

then run `npm install` and `cake build`. Run `node bot.js` in `out` dir and then set up a reverse proxy to the port 23326.
