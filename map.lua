local Map = {}
Map.__index = Map

function Map.new()
    local self = setmetatable({}, Map)
    self.scroll = 0
    self.speed = 200
    self.patternH = 600 -- alto de un "tile" de fondo, puedes ponerle el alto de tu imagen de fondo si tienes
    return self
end

function Map:update(dt, speed)
-- Control de velocidad
if love.keyboard.isDown("up") then
    self.speed = math.min(self.speed + 60*dt, 300) -- máxima velocidad
elseif love.keyboard.isDown("down") then
    self.speed = math.max(self.speed - 60*dt, 60) -- mínima velocidad
end
self.scroll = (self.scroll + self.speed * dt) % self.patternH

  
end

function Map:draw()
    
    love.graphics.setColor(0,0,1) -- azul río
    for i=0,1 do
        love.graphics.rectangle("fill", 200, -self.scroll + i*self.patternH, 600, self.patternH)
    end
    love.graphics.setColor(0,128,0) -- tierra
    for i=0,1 do
        love.graphics.rectangle("fill", 0, -self.scroll + i*self.patternH, 200, self.patternH)
        love.graphics.rectangle("fill", 600, -self.scroll + i*self.patternH, 200, self.patternH)
    end
    love.graphics.setColor(1,1,1)
end

return Map