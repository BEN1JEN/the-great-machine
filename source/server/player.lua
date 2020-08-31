local player = {}

function player.new()
	return setmetatable({
		inventory = require("inventory").new(12, 6),
		handSlot = {amount=0},
	}, {__index=player})
end

return player
