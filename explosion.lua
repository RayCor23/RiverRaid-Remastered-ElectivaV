local Explosion = {}
Explosion.__index = Explosion

function Explosion.new(x, y)
    local self = setmetatable({}, Explosion)
    self.x = x
    self.y = y
    self.radius = 10
    self.time = 0
    self.duration = 0.5
    self.dead = false
    return self
end

function Explosion:update(dt)
    self.time = self.time + dt
    self.radius = 10 + 40 * (self.time / self.duration)
    if self.time > self.duration then
        self.dead = true
    end
end

function Explosion:draw()
    love.graphics.setColor(1, 0.6, 0, 1 - self.time/self.duration)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    love.graphics.setColor(1,1,1,1)
end

return Explosion