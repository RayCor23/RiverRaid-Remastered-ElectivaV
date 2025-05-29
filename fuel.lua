local Fuel = {}
Fuel.__index = Fuel

function Fuel.new(x, y)
    local self = setmetatable({}, Fuel)
    self.x = x
    self.y = y
    self.size = 50
    self.speed = 250
    self.dead = false
    self.image = love.graphics.newImage("images/fuel.png")
    return self
end

function Fuel:update(dt)
    self.y = self.y + self.speed * dt
    if self.y > 600 then self.dead = true end
end

function Fuel:draw()
    if self.image then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(self.image, self.x, self.y)
    else
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
        love.graphics.setColor(0,0,1)
        love.graphics.rectangle("fill", self.x+4, self.y+8, self.size-8, self.size-12)
    end
    love.graphics.setColor(1,1,1)
end

return Fuel