local game = {}

function game.new()
	return setmetatable({
		
	}, {__index=game})
end

function game:update(delta, input)

end

function game:draw()

end

return game
