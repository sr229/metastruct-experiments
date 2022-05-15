--@name GimpyTTS
--@author Mavain and Minori
--@client

local lang = "en"
local soundref

hook.add("playerchat", "henkey", function(ply, txt)
    if ply ~= owner() then return end

    if string.sub(txt, 1, 1) ~= ";" then return end
    txt = string.sub(txt, 2)


    bass.loadURL("https://translate.google.com/translate_tts?ie=UTF-8&q=" .. http.urlEncode(txt) .. "&tl=" .. lang .. "&client=tw-ob", "3d",
    function(a, err, name)
        -- we dispose the current reference, then we create a new one
        if soundref then soundref:stop() end
        -- make sure we do not assign nil
        if not a then return end
        soundref = a

        hook.add("think", "soundFollow", function() a:setPos(owner():getPos()) end)
        -- do not make it play anything if its nil
        if not soundref then return end
        soundref:play()
    end)
end)