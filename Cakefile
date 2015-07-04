{exec} = require 'child_process'

task 'build', 'Build Bot', (options) ->
	exec 'coffee -o out -c src', (err, stdout, stderr) =>
		throw err if err
		exec 'cp -r conf out/conf', (err, stdout, stderr) =>
			throw err if err


