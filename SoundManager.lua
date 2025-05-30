local SoundManager = {}

function SoundManager.load()
    SoundManager.sounds = {
        explosion = love.audio.newSource("sonidos/explosion.mp3", "static"),
        laser = love.audio.newSource("sonidos/laser.mp3", "static"),
        fuel = love.audio.newSource("sonidos/fuel.mp3", "static"),
        alarm = love.audio.newSource("sonidos/alarm.mp3", "static"),
        gameover = love.audio.newSource("sonidos/gameover.mp3", "static"),
    }
end

function SoundManager.play(name)
    if SoundManager.sounds and SoundManager.sounds[name] then
        SoundManager.sounds[name]:stop()
        SoundManager.sounds[name]:play()
    end

    if SoundManager.sounds and SoundManager.sounds[name] then
        local snd = SoundManager.sounds[name]
        if not snd:isPlaying() then
            snd:setLooping(true)
            snd:play()
        end
    end

    if SoundManager.sounds and SoundManager.sounds[name] then
        SoundManager.sounds[name]:stop() -- Asegúrate de que se reinicie si se reproduce varias veces
        SoundManager.sounds[name]:play()
    end
    
end


function SoundManager.playLoop(name)
    if SoundManager.sounds and SoundManager.sounds[name] then
        local snd = SoundManager.sounds[name]
        if not snd:isPlaying() then
            snd:setLooping(true)
            snd:play()
        end
    end
end

function SoundManager.stop(name)
    if SoundManager.sounds and SoundManager.sounds[name] then
        SoundManager.sounds[name]:stop()
    end
end

return SoundManager