require "lib"
local enet = require "enet"
local host = enet.host_create("0.0.0.0:3003")

local serialize = require "serialize"
local factory = require("factory").new(host)
local players = {}
local tile = require "tile"
local item = require "item"

local chest = tile.new("chest")
chest.inventory[1].slots[3][2] = {type="wood", amount=5}
factory:setTile(2, 2, chest)

while true do
  local event = host:service(100)
  while event do
    if event.type == "receive" then
      local player = players[event.peer:index()]
      local data = serialize.deserialize(event.data)
      if type(data) == "table" then
        if data.type == "swapMachineItem" then
          local tile = factory:getTile(data.machinePos.x, data.machinePos.y)
          if tile and tile.inventory and tile.inventory[data.machineInventoryId] then
            local inv = tile.inventory[data.machineInventoryId].slots
            if inv and inv[data.machineSlot.x] and inv[data.machineSlot.x][data.machineSlot.y] then
              local tmp = player.handSlot
              player.handSlot = inv[data.machineSlot.x][data.machineSlot.y]
              inv[data.machineSlot.x][data.machineSlot.y] = tmp
              event.peer:send(serialize.serialize{type="setHeldSlot", slot=player.handSlot})
              host:broadcast(serialize.serialize{type="setMachineSlot", machinePos=data.machinePos, machineInventoryId=data.machineInventoryId, machineSlot=data.machineSlot, slot=tmp})
            else
              event.peer:send(serialize.serialize{type="error", error="Invalid slot."})
            end
          else
            event.peer:send(serialize.serialize{type="error", error="Invalid machine."})
          end
        elseif data.type == "swapPlayerItem" then
          local inv = player.inventory.slots
          if inv and inv[data.playerSlot.x] and inv[data.playerSlot.x][data.playerSlot.y] then
            local tmp = player.handSlot
            player.handSlot = inv[data.playerSlot.x][data.playerSlot.y]
            inv[data.playerSlot.x][data.playerSlot.y] = tmp
            event.peer:send(serialize.serialize{type="setHeldSlot", slot=player.handSlot})
            host:broadcast(serialize.serialize{type="setPlayerSlot", playerSlot=data.playerSlot, slot=tmp})
          else
            event.peer:send(serialize.serialize{type="error", error="Invalid slot."})
          end
        elseif data.type == "placeItem" then
          if player.handSlot.amount > 0 then
            local tile = item.items[player.handSlot.type].place
            if tile then
              
            end
          end
        end
        else
          event.peer:send(serialize.serialize{type="error", error="Unknown message type."})
        end
      else
        event.peer:send(serialize.serialize{type="error", error="Invalid message."})
      end
    elseif event.type == "connect" then
      factory:send(event.peer)
      players[event.peer:index()] = require("player").new()
    elseif event.type == "disconnect" then
      print(event.peer, "disconnected.")
    end
    event = host:service()
  end
end
