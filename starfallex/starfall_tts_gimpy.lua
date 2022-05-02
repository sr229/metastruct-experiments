--@name GimpyTTS
--@author Mavain and Minori
--@client

local lang = "en"
local soundref

hook.add("playerchat", "fucke2", function(ply, txt)
    if ply ~= owner() then return end

    bass.loadURL("https://translate.google.com/translate_tts?ie=UTF-8&q=" .. txt .. "&tl=" .. lang .. "&client=tw-ob", "3d",
    function(a, err, name)
        -- we dispose the current reference, then we create a new one
        if soundref then soundref:stop() end
        soundref = a

        hook.add("think", "soundFollow", function() a:setPos(owner():getPos()) end)
        a:play()
    end)
end)