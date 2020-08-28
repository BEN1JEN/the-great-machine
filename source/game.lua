local game = {}

function game.new()
	return setmetatable({
		font = require("font").new("assets/font.png", 80, 45),
	}, {__index=game})
end

function game:update(delta, input)

end

function game:draw()
	local width, height = love.window.getMode()
	self.font:draw(width, height)
end

return game
