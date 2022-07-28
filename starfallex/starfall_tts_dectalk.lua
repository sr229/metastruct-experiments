--@name DECTalk
--@author Minori
--@include https://gist.githubusercontent.com/sr229/5e6f3a5b03181704a871207c14706499/raw/2ee5b6cfb3a875a5ad2024a38d0131cfb5278785/url-encode.lua as henke.txt
--@client

local soundref
require("henke.txt")

-- Check if client has permission
if not hasPermission("bass.loadURL", "https://tts.cyzon.us/tts") then return end

hook.add("playerchat", "aeiou", function(ply, txt)
    if ply ~= owner() then return end
    if string.sub(txt, 1, 1) ~= ";" then return end

    txt = string.sub(txt, 2)
    if #txt < 1 then return end

    txt = urlencode(txt)

    bass.loadURL("https://tts.cyzon.us/tts?text=" .. txt, "3d", function(a, err, name)
        -- we dispose the current reference, then we create a new one
        if soundref then soundref:stop() end
        soundref = a

        hook.add("think", "soundFollow", function() a:setPos(owner():getPos()) end)
        soundref:play()
    end)
end)