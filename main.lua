local game, input, globalUpdater
function love.load()
	love.filesystem.setRequirePath("?.lua;?/main.lua;source/?.lua")
	require "lib"
	game = require("game").new()
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
