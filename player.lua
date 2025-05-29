local Player = {}
Player.__index = Player

local SoundManager = require "soundmanager"


function Player.new()
    local self = setmetatable({}, Player)
    self.x = 400
    self.y = 500
    self.speed = 220
    self.width = 32
    self.height = 48
    self.fuel = 100
    self.image = love.graphics.newImage("images/player.png") 
    return self
end

function Player:update(dt)
    if love.keyboard.isDown("left") then self.x = self.x - self.speed * dt end
    if love.keyboard.isDown("right") then self.x = self.x + self.speed * dt end

    -- Limitar movimiento al río
    if self.x < 220 then self.x = 220 end
    if self.x > 548 then self.x = 548 end
    if self.y < 0 then self.y = 0 end
    if self.y > 552 then self.y = 552 end
end

function Player:draw()
    local lowFuel = self.fuel < 30
    local blink = false
    if lowFuel then
        blink = math.floor(love.timer.getTime() * 6) % 2 == 0
        SoundManager.playLoop("alarm")
    else
        SoundManager.stop("alarm")
    end

    if (not lowFuel) or blink then
        if self.image then
            if lowFuel then
                love.graphics.setColor(1, 0.3, 0.3) 
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.draw(self.image, self.x, self.y)
        else
            if lowFuel then
                love.graphics.setColor(1, 0.3, 0.3)
            else
                love.graphics.setColor(0, 1, 0)
            end
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        end
    end
    love.graphics.setColor(1, 1, 1)
end

function Player:shoot()
    local bullet = {
        x = self.x + self.width/2 - 2,
        y = self.y,
        speed = 400,
        dead = false,
        draw = function(self) love.graphics.rectangle("fill", self.x, self.y, 4, 10) end,
        update = function(self, dt)
            self.y = self.y - self.speed * dt
            if self.y < 0 then self.dead = true end
        end
    }
    return bullet
end

return Player
