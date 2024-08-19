--@name DECTalk
--@author Minori
--@include https://gist.githubusercontent.com/sr229/5e6f3a5b03181704a871207c14706499/raw/2ee5b6cfb3a875a5ad2024a38d0131cfb5278785/url-encode.lua as henke.txt
--@shared
local DEBUG = true
local references = {}
require("henke.txt")

if SERVER then
    -- haaugh
    --chip():setNoDraw(true)
    hook.add("PlayerSay", "tts_msg", function(ply, txt)
        -- instead of limiting to owner()
        -- we do a little trolling and give it to everyone
        if ply and string.sub(txt, 1, 1) == ";" then
            local content = string.sub(txt, 2)
            local plyID = ply:getUserID()
            local plySID = ply:getSteamID()

            -- Ignore content that has more than 128 characters
            -- this is to prevent crashes.
            if #content > 128 then
                if DEBUG then
                    print(string.format("WARN: ignoring message from %s, exceeded 128 characters.", tostring(plySID)))
                else
                    return
                end
            else
                net.start("aeiou")
                net.writeInt(plyID, 32)
                net.writeString(content)
                net.send()
            end
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

        if DEBUG then print(string.format("Playing msg, wordcount: %i", #msg)) end

        bass.loadURL("https://tts.cyzon.us/tts?text=" .. urlencode(msg), "3d noblock", function(a, e, n)
            -- since Starfall has no way to keep track of audio objects
            -- we will have to manage the lifecycle oureselves via a local table
            table.insert(references, {
                ref = a,
                timestamp = os.time()
            })

            -- we may have ended up with a unsorted table, let's fix that
            -- sort table by oldest at the top to most recent at the bottom.
            table.sort(references, function(a, b) return a.timestamp < b.timestamp end)

            hook.add("Think", "followSound", function()
                a:setPos(plyAuthor:getPos())
            end)

            a:setVolume(1.5)
            a:play()

            local cogc = coroutine.create(function()
                if #references ~= 0 or #references > 18 then
                    -- scan for references that are older than 10 seconds
                    for i, v in ipairs(references) do
                        if os.time() - v.timestamp > 10 and not v.ref:isPlaying() then
                            if DEBUG then print(string.format("Destroying reference, ts: %i", v.timestamp)) end
                            v.ref:destroy()
                            table.remove(references, i)
                        end
                    end
                    coroutine.yield()
                end
            end)
            coroutine.resume(cogc)
        end)
    end)
end
