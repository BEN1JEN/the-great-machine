local config = require("config").input
local input = {}

function input.init()
  input.map = config.buttons
  input.buttons = {}
  local width, height = love.window.getMode()
  for name, triggers in pairs(input.map) do
    for _, trigger in ipairs(triggers) do
      trigger.x, trigger.y = compat.guiSize(trigger.x, trigger.y)
      if trigger.type == "touch" then
        if trigger.align:find("b") then -- Bottom
          trigger.y = height - trigger.y
        end
        if trigger.align:find("r") then -- Right
          trigger.x = width - trigger.x
        end
        if trigger.align:find("v") then -- centered Vertically
          trigger.y = trigger.y + height/2
        end
        if trigger.align:find("h") then -- centered Horizontally
          trigger.x = trigger.x + width/2
        end
        trigger.size2 = trigger.size^2
      end
    end
    input.buttons[name] = {held=false, down=false, up=false, last=false, value=0}
  end
  input.joystick = love.joystick.getJoysticks()[1] -- can be nil
end

function input.globalUpdate()
  for name, triggers in pairs(input.map) do
    local button = input.buttons[name]
    button.last = button.held
    button.held = false
    button.value = 1
    for _, trigger in ipairs(triggers) do
      if trigger.type == "kb" then
        button.held = button.held or love.keyboard.isDown(trigger.key)
      elseif trigger.type == "mouse" then
        button.held = button.held or love.mouse.isDown(trigger.side)
      elseif trigger.type == "axis" then
        if input.joystick then
          button.value = input.joystick:getAxis(trigger.axis)
          button.held = button.held or button.value > config.deadZone
        end
      elseif trigger.type == "hat" then
        if input.joystick then
          button.held = button.held or input.joystick:getHat(trigger.hat):find(trigger.direction) --check string for direction pattern
        end
      elseif trigger.type == "joybutton" then
        if input.joystick then
          button.held = button.held or input.joystick:isDown(trigger.id)
        end
      elseif trigger.type == "touch" then
        if compat.mobile() then
          local touches = love.touch.getTouches()
          for _, touch in ipairs(touches) do
            local x, y = love.touch.getPosition(touch)
            if trigger.shape == "circle" then
              button.held = button.held or (x-trigger.x)^2 + (y-trigger.y)^2 <= trigger.size
            elseif trigger.shape == "square" then
              button.held = button.held or (math.abs(trigger.x-x) < trigger.size and math.abs(trigger.y-y) < trigger.size)
            end
          end
        end
      end
    end
    if not button.held then
      button.value = 0
    end
    button.down = button.held and not button.last
    button.up = button.last and not button.held
  end
end

function input.globalDraw()
  if compat.mobile() then
    local font = love.graphics.getFont()
    for name, triggers in pairs(input.map) do
      for _, trigger in ipairs(triggers) do
        if trigger.type == "touch" then
          if input.buttons[name].held then
            compat.setColour(0.5, 0.5, 0.5, 1)
          else
            compat.setColour(0.5, 0.5, 0.5, 0.2)
          end
          if trigger.shape == "circle" then
            love.graphics.circle("fill", trigger.x, trigger.y, compat.guiSize(trigger.size))
            compat.setColour(1, 1, 1, 1)
            love.graphics.circle("line", trigger.x, trigger.y, compat.guiSize(trigger.size))
          elseif trigger.shape == "square" then
            love.graphics.rectangle("fill", trigger.x-compat.guiSize(trigger.size), trigger.y-compat.guiSize(trigger.size), compat.guiSize(trigger.size*2, trigger.size*2))
            compat.setColour(1, 1, 1, 1)
            love.graphics.rectangle("line", trigger.x-compat.guiSize(trigger.size), trigger.y-compat.guiSize(trigger.size), compat.guiSize(trigger.size*2, trigger.size*2))
          end
          love.graphics.print(trigger.symbol, trigger.x-font:getWidth(trigger.symbol), trigger.y-font:getHeight())
        end
      end
    end
  end
end

function input.get(button)
  return input.buttons[button]
end

input.init()

return setmetatable(input, {__index=input.buttons})
