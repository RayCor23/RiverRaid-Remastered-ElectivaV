local jugador
local balas = {}
local enemigos = {}
local tiempoEnemigos = 0
local velocidadBala = 500
local velocidadEnemigo = 200
local puntuacion = 0
local gameOver = false

function love.load()
    love.window.setTitle("River Raid Remastered")
    love.window.setMode(800, 600)

    
    jugador = love.graphics.newImage("images/jugador.png")
    balaImg = love.graphics.newImage("images/bala.png")
    enemigoImg = love.graphics.newImage("images/enemigo.png")
    combustibleImg = love.graphics.newImage("images/combustible.png")

    sonidoDisparo = love.audio.newSource("sonidos/disparo.mp3", "static")
    sonidoExplosion = love.audio.newSource("sonidos/explosion.mp3", "static")

    jugadorX = 370
    jugadorY = 500

    love.graphics.setBackgroundColor(0, 128, 0)
end

function love.update(dt)
    if not gameOver then
        -- Movimiento del jugador
        if love.keyboard.isDown("left") then
            jugadorX = jugadorX - 200 * dt
        elseif love.keyboard.isDown("right") then
            jugadorX = jugadorX + 200 * dt
        end

        jugadorX = math.max(0, math.min(love.graphics.getWidth() - jugador:getWidth(), jugadorX))

        for i = #balas, 1, -1 do
            local bala = balas[i]
            bala.y = bala.y - velocidadBala * dt

            if bala.y < 0 then
                table.remove(balas, i)
            end
        end

        tiempoEnemigos = tiempoEnemigos + dt
        if tiempoEnemigos > 1 then
            generarEnemigo()
            tiempoEnemigos = 0
        end

        for i = #enemigos, 1, -1 do
            local enemigo = enemigos[i]
            enemigo.y = enemigo.y + velocidadEnemigo * dt 

            if colision(jugadorX, jugadorY, jugador:getWidth(), jugador:getHeight(), enemigo.x, enemigo.y, enemigoImg:getWidth(), enemigoImg:getHeight()) then
                gameOver = true
            end

            if enemigo.y > love.graphics.getHeight() then
                table.remove(enemigos, i)
            end
        end

        for i = #balas, 1, -1 do
            local bala = balas[i]
            for j = #enemigos, 1, -1 do
                local enemigo = enemigos[j]
                if colision(bala.x, bala.y, balaImg:getWidth(), balaImg:getHeight(), enemigo.x, enemigo.y, enemigoImg:getWidth(), enemigoImg:getHeight()) then
                    table.remove(balas, i)
                    table.remove(enemigos, j)
                    puntuacion = puntuacion + 100 

                    love.audio.play(sonidoExplosion)

                    break
                end
            end
        end
    end
end

function love.draw()
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", 200, 0, 400, 700)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(jugador, jugadorX, jugadorY)

    for _, bala in ipairs(balas) do
        love.graphics.draw(balaImg, bala.x, bala.y)
    end

    for _, enemigo in ipairs(enemigos) do
        love.graphics.draw(enemigoImg, enemigo.x, enemigo.y)
    end

    love.graphics.setColor(0, 0, 0) 
    love.graphics.print("Puntuación: " .. puntuacion, 10, 10)

    if gameOver then
        love.graphics.setColor(1, 0, 0) 

        love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 2 - 20, love.graphics.getWidth(), "center")
        love.graphics.printf("Presiona R para reiniciar", 0, love.graphics.getHeight() / 2 + 20, love.graphics.getWidth(), "center")
    end
    
    
    love.graphics.setColor(1, 1, 1)
end

function love.keypressed(key)
    if key == "space" and not gameOver then
        dispararBala()
    elseif key == "r" and gameOver then
        reiniciarJuego()
    end
end

function dispararBala()
    local nuevaBala = 
    { x = jugadorX + jugador:getWidth() / 2 - balaImg:getWidth() / 2, 
    y = jugadorY }
    table.insert(balas, nuevaBala)

    love.audio.play(sonidoDisparo)

end

function generarEnemigo()
    local nuevoEnemigo = { 
        x = math.random(0, love.graphics.getWidth() - enemigoImg:getWidth()), 
        y = -32 }
    table.insert(enemigos, nuevoEnemigo)
end

function colision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x1 + w1 > x2 and y1 < y2 + h2 and y1 + h1 > y2
end

function reiniciarJuego()
    balas = {}
    enemigos = {}
    tiempoEnemigos = 0
    puntuacion = 0
    gameOver = false
end
