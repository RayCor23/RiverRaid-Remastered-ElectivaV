local Player = require "player"
local Enemy = require "enemy"
local Fuel = require "fuel"
local Map = require "map"
local Explosion = require "explosion"
local SoundManager = require "soundmanager"

function love.load()
    love.window.setTitle("River Raid Remastered")
    love.window.setMode(800, 600)
    
    SoundManager.load()
    player = Player.new()
    map = Map.new()
    bullets = {}
    enemies = {}
    fuels = {}
    explosions = {}
    score = 0
    spawnEnemyTimer = 0
    spawnFuelTimer = 0
    gameOver = false

    backgroundMusic = love.audio.newSource("sonidos/music.mp3", "stream")
    backgroundMusic:setLooping(true)
    backgroundMusic:setVolume(0.5) 
    backgroundMusic:play()
end

function getEnemySpawnCount(score)
    if score < 1000 then
        return 2
    elseif score < 2000 then
        return 3
    elseif score < 3000 then
        return 4
    else
        return 5 
    end
end


function love.update(dt)
    if gameOver then return end
    player:update(dt)
    map:update(dt)

    for i=#bullets,1,-1 do
        bullets[i]:update(dt)
        if bullets[i].dead then table.remove(bullets, i) end
    end

    spawnEnemyTimer = spawnEnemyTimer - dt
    if spawnEnemyTimer <= 0 then
        local count = getEnemySpawnCount(score)
        for i=1, count do
            local side = (i % 2 == 0) and "left" or "right"
            table.insert(enemies, Enemy.new(side, score))
        end
        spawnEnemyTimer = 1 + math.random()

    end

    for i=#enemies,1,-1 do
        enemies[i]:update(dt)
        if enemies[i].dead then table.remove(enemies, i) end
    end

    spawnFuelTimer = spawnFuelTimer - dt
    if spawnFuelTimer <= 0 then
        table.insert(fuels, Fuel.new(math.random(320, 440), -40))
        spawnFuelTimer = 2 + math.random() * 4
    end
    for i=#fuels,1,-1 do
        fuels[i]:update(dt)
        if fuels[i].dead then table.remove(fuels, i) end
    end

    for i = #explosions,1,-1 do
        explosions[i]:update(dt)
        if explosions[i].dead then table.remove(explosions, i) end
    end

    for i=#enemies,1,-1 do
        local e = enemies[i]
        for j=#bullets,1,-1 do
            local b = bullets[j]
            if not b.dead and not e.dead and checkCollision(b.x, b.y, 4, 10, e.x, e.y, e.width, e.height) then
                b.dead = true
                e.dead = true
                score = score + e.score
                table.insert(explosions, Explosion.new(e.x + e.width/2, e.y + e.height/2))
                SoundManager.play("explosion")
            end
        end
    end

    for i=#enemies,1,-1 do
        local e = enemies[i]
        if not e.dead and checkCollision(player.x, player.y, player.width, player.height, e.x, e.y, e.width, e.height) then
            gameOver = true
            table.insert(explosions, Explosion.new(player.x+player.width/2, player.y+player.height/2))
            SoundManager.play("explosion")
        end
    end

    for i=#fuels,1,-1 do
        local f = fuels[i]
        if not f.dead and checkCollision(player.x, player.y, player.width, player.height, f.x, f.y, f.size, f.size) then
            f.dead = true
            player.fuel = math.min(player.fuel+40, 100)
            score = score + 50
            SoundManager.play("fuel")
        end
    end

for i = #fuels, 1, -1 do
    local f = fuels[i]
    for j = #bullets, 1, -1 do
        local b = bullets[j]
        if not b.dead and not f.dead and checkCollision(b.x, b.y, 4, 10, f.x, f.y, f.size, f.size) then
            b.dead = true
            f.dead = true
            player.fuel = math.max(player.fuel - 20, 0)
            table.insert(explosions, Explosion.new(f.x + f.size/2, f.y + f.size/2))
            SoundManager.play("explosion")
        end
    end
end

    player.fuel = player.fuel - dt * 5
    if player.fuel <= 0 then
        gameOver = true
        table.insert(explosions, Explosion.new(player.x+player.width/2, player.y+player.height/2))
        SoundManager.play("explosion")
    end
end

function love.draw()
    map:draw()
    for _,f in ipairs(fuels) do f:draw() end
    for _,e in ipairs(enemies) do e:draw() end
    for _,b in ipairs(bullets) do b:draw() end
    for _,ex in ipairs(explosions) do ex:draw() end
    player:draw()
    
 local barX, barY = 10, 70    
local barW, barH = 300, 24     
local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
local barX = (screenW - barW) / 2
local barY = screenH - barH - 5

love.graphics.setColor(0.2, 0.2, 0.2)
love.graphics.rectangle("fill", barX, barY, barW, barH)

local fuelPercent = math.max(0, math.min(player.fuel / 100, 1))
    
if fuelPercent > 0.5 then
    love.graphics.setColor(0, 0.8, 0)
elseif fuelPercent > 0.2 then
    love.graphics.setColor(1, 0.7, 0)
else
    love.graphics.setColor(1, 0, 0)
end
love.graphics.rectangle("fill", barX, barY, barW * fuelPercent, barH)
love.graphics.setColor(1,1,1)
love.graphics.rectangle("line", barX, barY, barW, barH)
    
    love.graphics.setColor(0,0,0)
    love.graphics.print("Puntuacion: "..score, 10, 10)
    
    if gameOver then
        love.graphics.setColor(1,0,0)
        love.graphics.printf("GAME OVER\nPresiona R para reiniciar", 0, 260, 800, "center")
    end

    if gameOver and not gameOverSoundPlayed then
        SoundManager.play("gameover")
        gameOverSoundPlayed = true
    end
end

function love.keypressed(key)
    if gameOver and key == "r" then love.event.quit("restart") end
    if not gameOver and key == "space" then
        table.insert(bullets, player:shoot())
        SoundManager.play("laser")
    end
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function love.quit()
    if backgroundMusic then backgroundMusic:stop() end
end
