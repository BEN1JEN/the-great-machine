local globalUpdater = {}

function globalUpdater.update(delta)
  for _, p in pairs(package.loaded) do
    if type(p) == "table" and type(rawget(p, "globalUpdate")) == "function" then
      p.globalUpdate(delta)
    end
  end
end

function globalUpdater.draw()
  for _, p in pairs(package.loaded) do
    if type(p) == "table" and type(rawget(p, "globalDraw")) == "function" then
      p.globalDraw()
    end
  end
end

return globalUpdater
