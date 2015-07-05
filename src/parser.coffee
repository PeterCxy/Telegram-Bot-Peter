exports.parse = (cmd) ->
	options = []
	arr = cmd.split(" ")
	opt = ""
	concat = no
	for str, i in arr
		continue if i == 0 || str == ""

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
