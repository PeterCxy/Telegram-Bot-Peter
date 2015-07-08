exports.parse = (cmd) ->
	options = []
	arr = cmd.split(" ")
	opt = ""
	concat = no
	for str, i in arr
		continue if str == ""

		if str.startsWith '"'
			concat = yes
			str = str[1..]
		else if str.endsWith '"'
			concat = no
			options.push opt + str[0..-2]
			opt = ""
			continue

		if !concat
			options.push str
		else
			opt += str + " "
	options

exports.time = (time) ->
	t = 0
	str = ''
	for s in time
		switch s
			when 's'
				t += str * 1000
				str = ''
			when 'm'
				t += str * 60 * 1000
				str = ''
			when 'h'
				t += str * 60 * 60 * 1000
				str = ''
			when 'd'
				t += str * 24 * 60 * 60 * 1000
				str = ''
			else
				str += s
	t
