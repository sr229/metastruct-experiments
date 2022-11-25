--@name DECTalk
--@author Minori
--@include https://gist.githubusercontent.com/sr229/5e6f3a5b03181704a871207c14706499/raw/2ee5b6cfb3a875a5ad2024a38d0131cfb5278785/url-encode.lua as henke.txt
--@shared
local soundref
require("henke.txt")

if SERVER then
    -- haaugh
    chip():setNoDraw(true)

    hook.add("PlayerSay", "tts_msg", function(ply, txt)
        -- instead of limiting to owner()
        -- we do a little trolling and give it to everyone
        if ply and string.sub(txt, 1, 1) == ";" then
            -- broadcast who sent it
            net.start("aeiou")
            -- send user ID (32-bit)
            net.writeInt(ply:getUserID(), 32)
            -- send user msg (string)
            net.writeString(string.sub(txt, 2))
            net.send()
            -- do not broadcast original msg to client
            -- BUG: only works for owner()
            --return ""
        end
    end)
end

if CLIENT then
    if not hasPermission("bass.loadURL", "https://tts.cyzon.us/tts") then return end
    print("DECTalk loaded on client. Type ;<text> to use it.")

    net.receive("aeiou", function()
        local plyAuthor = player(net.readInt(32))
        local msg = net.readString()

        bass.loadURL("https://tts.cyzon.us/tts?text=" .. urlencode(msg), "3d", function(a, e, n)
            if soundref then
                soundref:destroy()
            end

            soundref = a

            hook.add("Think", "followSound", function()
                soundref:setPos(plyAuthor:getPos())
            end)

            soundref:setVolume(1.3)
            soundref:play()
        end)
    end)
end