local serialize = require "serialize"
local factory = {}

function factory.new(host)
	return setmetatable({
		host = host,
		grid = {tiles={}, width=20, height=20},
	}, {__index=factory})
end

function factory:setTile(x, y, tile)
	if not self.grid.tiles[x] then
		self.grid.tiles[x] = {}
	end
	self.grid.tiles[x][y] = tile
	self.host:broadcast(serialize.serialize{type="setTile", x=x, y=y, tile=tile})
end

function factory:send(peer)
	peer:send(serialize.serialize{type="factoryGrid", grid=self.grid})
end

return factory
