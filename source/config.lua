local config = require "assets.config"

function config.init()
  if config.guiScale == 0 then
    local width, height = love.window.getMode()
    config.guiScale = 0.5
    if width <= 640 or height <= 360 then -- 360p
      config.guiScale = 0.5
    elseif width < 1280 or height < 720 then -- 720p
      config.guiScale = 1
    elseif width < 1920 or height < 1080 then -- 1080p
      config.guiScale = 2
    elseif width < 1440 or height < 1440 then -- 1440p
      config.guiScale = 3
    elseif width < 3840 or height < 2160 then -- 2160p
      config.guiScale = 4
    else -- > 2160p
      config.guiScale = math.min(width/3840*4, height/2160*4)
    end
  end
  compat.sizeTo(config.guiScale)
end
config.init()

function config.namespace(namespace)
  return setmetatable(require("assets.config." .. namespace), {__index=config})
end

function config.get(namespace, prop)
  return config.namespace(namespace)[prop]
end

return setmetatable(config, {__index=function(_, ns)return config.namespace(ns)end})
