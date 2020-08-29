local game, input, globalUpdater
function love.load(args)
	local server = true
	local address = "127.0.0.1:3003"
	if args[1] then
		server = false
		address = args[1] .. ":3003"
	end
	local path = "?.lua;?/main.lua;source/?.lua"
	if server then
		path = path .. ";source/server/?.lua"
	end
	love.filesystem.setRequirePath(path)

	love.thread.newThread("source/server/main.lua"):start()
	love.timer.sleep(0.1)

	require "lib"
	game = require("game").new(address)
	input = require "input"
	globalUpdater = require "globalUpdater"
end

function love.update(delta)
	game:update(delta, input)
	globalUpdater.update(delta)
end

function love.draw()
	game:draw()
	globalUpdater.draw()
end
