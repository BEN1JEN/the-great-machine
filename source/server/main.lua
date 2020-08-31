local enet = require "enet"
local host = enet.host_create("0.0.0.0:3003")

local factory = require("factory").new(host)
local tile = require "tile"
local item = require "item"

local chest = tile.new("chest")
chest.inventory[1].slots[3][2] = {type="wood", amount=5}
factory:setTile(2, 2, chest)

while true do
  local event = host:service(100)
  while event do
    if event.type == "receive" then
      print("Got message: ", event.data, event.peer)
      event.peer:send("pong")
    elseif event.type == "connect" then
      factory:send(event.peer)
    elseif event.type == "disconnect" then
      print(event.peer, "disconnected.")
    end
    event = host:service()
  end
end
