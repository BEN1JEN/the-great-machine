local serialize = require "serialize"
local factory = {}

function factory.new(host)
	return setmetatable({
		host = host,
		grid = {},
	}, {__index=factory})
end

function factory:setTile(x, y, tile)
	if grid[x] then
		grid[x] = {}
	end
	grid[x][y] = tile
	host:broadcast(serialize.deserialize{type="setTile", x=x, y=y, tile=tile})
end

function factory:send(peer)
	peer:send(serialize.serialize{type="sendFactory", grid=self.grid})
end

return factory
