local Enemy = {}
Enemy.__index = Enemy

local enemyTypes = {
    {image = "images/enemy1.png", width = 80, height = 60, speed = 350, score = 100},
    {image = "images/enemy2.png", width = 70, height = 50, speed = 450, score = 300},
}


local function getSpeedMultiplier(score)
    if not score then return 1 end
    return 1 + math.min(score, 3000) / 3500
end

function Enemy.new(entrySide, score)
    local self = setmetatable({}, Enemy)
    local t = math.random(1, #enemyTypes)
    self.type = t
    self.width = enemyTypes[t].width
    self.height = enemyTypes[t].height

    -- Aplica el multiplicador de velocidad según el score
    local speedMultiplier = getSpeedMultiplier(score)
    self.speed = (enemyTypes[t].speed + math.random()*30) * speedMultiplier

    self.score = enemyTypes[t].score
    self.image = love.graphics.newImage(enemyTypes[t].image)
    self.dead = false

    self.y = -self.height

    -- Trayectorias horizontales variadas
    local riverLeft, riverRight = 300, 500
    if entrySide == "left" then
        self.x = riverLeft - self.width
        local mode = math.random(1,3)
        if mode == 1 then -- cruza todo el río
            self.hspeed = (80 + math.random()*40) * speedMultiplier
        elseif mode == 2 then -- solo entra un poco
            self.hspeed = (40 + math.random()*30) * speedMultiplier
        else -- zigzag
            self.hspeed = 60 * speedMultiplier
            self.zigzag = true
            self.zigzag_timer = 0
        end
    elseif entrySide == "right" then
        self.x = riverRight
        local mode = math.random(1,3)
        if mode == 1 then
            self.hspeed = -(80 + math.random()*40) * speedMultiplier
        elseif mode == 2 then
            self.hspeed = -(40 + math.random()*30) * speedMultiplier
        else
            self.hspeed = -60 * speedMultiplier
            self.zigzag = true
            self.zigzag_timer = 0
        end
    end

    return self
end

function Enemy:update(dt)
    self.y = self.y + self.speed * dt
    self.x = self.x + self.hspeed * dt

    -- Zigzag horizontal
    if self.zigzag then
        self.zigzag_timer = (self.zigzag_timer or 0) + dt
        if self.zigzag_timer > 0.5 then
            self.hspeed = -self.hspeed
            self.zigzag_timer = 0
        end
    end

    if self.y > 700 or self.x < 280 - self.width or self.x > 520 then self.dead = true end
end

function Enemy:draw()
    if self.image then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(self.image, self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())
    else
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
    love.graphics.setColor(1,1,1)
end

return Enemy