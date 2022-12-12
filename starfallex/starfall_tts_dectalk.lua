--@name DECTalk
--@author Minori
--@include https://gist.githubusercontent.com/sr229/5e6f3a5b03181704a871207c14706499/raw/2ee5b6cfb3a875a5ad2024a38d0131cfb5278785/url-encode.lua as henke.txt
--@shared
local references = {}
local DEBUG = true
require("henke.txt")

if SERVER then
    -- haaugh
    --chip():setNoDraw(true)
    hook.add("PlayerSay", "tts_msg", function(ply, txt)
        -- instead of limiting to owner()
        -- we do a little trolling and give it to everyone
        if ply and string.sub(txt, 1, 1) == ";" then
            local plyAuthor = ply:getUserID()
            local cleanedMsg = string.sub(txt, 2)

            if #cleanedMsg > 1024 then
                -- Ignore message more than 1024 characters
                if DEBUG then
                    print(string.format("SERVER: Ignoring message from %s, msglen %i is greater than limit (1024)", ply:getName(), #cleanedMsg))
                end
            else
                net.start("aeiou")
                net.writeInt(plyAuthor, 32)
                net.writeString(cleanedMsg)
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

        if DEBUG then
            print(string.format("CLIENT: Playing sound from %s (%i), msg len: %i", plyAuthor:getName(), plyAuthor:getUserID(), #msg))
        end

        bass.loadURL("https://tts.cyzon.us/tts?text=" .. urlencode(msg), "3d noblock", function(a, e, n)
            -- since Starfall has no way to keep track of objects
            -- we will have to manage the lifecycle oureselves via a local table
            table.insert(references, {
                ref = a,
                timestamp = os.time()
            })

            -- we may have ended up with a unsorted table, let's fix that
            -- sort table by oldest at the top to most recent at the bottom.
            table.sort(references, function(entryA, entryB) return entryA.timestamp < entryB.timestamp end)

            hook.add("Think", "followSound", function()
                a:setPos(plyAuthor:getPos())
            end)

            a:setVolume(1.5)
            a:play()

            -- let's dispose the oldest ref
            -- but make sure we keep two references alive
            -- so we don't end up disposing too early :(
            if #references ~= 0 and #references > 2 then
                if DEBUG then
                    print(string.format("Destroying oldest reference, ts: %i", references[1].timestamp))
                end

                references[1].ref:destroy()
                table.remove(references, 1)
            end
        end)
    end)
end