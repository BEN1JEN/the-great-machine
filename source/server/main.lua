local enet = require "enet"
local host = enet.host_create("0.0.0.0:3003")

local factory = require("factory").new(host)

factory:setTile(2, 2, {type="chest"})

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
