local game, input, globalUpdater
function love.load()
	love.filesystem.setRequirePath("?.lua;?/main.lua;source/?.lua")
	require "lib"
	game = require("game").new()
	input = require "input"
	globalUpdater = require "globalUpdater"
	local str = ""
	for i = 0, 255 do
		str = str .. string.char(i)
		if i % 16 == 15 then
			str = str .. "\n"
		end
	end
	game.font:render(str, 10, 10)
	game.font:render(("-"):rep(80), 0, 0)
	game.font:render(("-"):rep(80), 0, 44)
end

function love.update(delta)
	game:update(delta, input)
	globalUpdater.update(delta)
end

function love.draw()
	game:draw()
	globalUpdater.draw()
end
