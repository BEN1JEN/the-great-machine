local game = {}

function game.new()
	return setmetatable({
		font = require("font").new("assets/font.png", 160, 90),
	}, {__index=game})
end

function game:update(delta, input)

end

function game:draw()
	love.graphics.rectangle("fill", 0, 0, 1000, 1000)
	love.graphics.draw(self.font.canvas)
end

return game
