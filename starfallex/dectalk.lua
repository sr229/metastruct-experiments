--@name DECTalk
--@author Minori
--@include https://gist.githubusercontent.com/sr229/5e6f3a5b03181704a871207c14706499/raw/2ee5b6cfb3a875a5ad2024a38d0131cfb5278785/url-encode.lua as henke.txt
--@shared
local DEBUG = false
local references = {}
require("henke.txt")

if SERVER then
    if DEBUG then print("sv: DECTalk server hook loaded, ready to listen to other players.") end
    
    hook.add("PlayerSay", "tts_msg", function(ply, txt)
        if ply and string.sub(txt, 1, 1) == ":" then
            local content = string.sub(txt, 2)
            local plySID = ply:getSteamID()

            -- Ignore content that has more than 128 characters
            -- this is to prevent crashes.
            if #content > 128 then
                if DEBUG then
                    print(string.format("WARN: ignoring message from %s, exceeded 128 characters.", tostring(plySID)))
                else
                    return
                end
            elseif #content == 0 then
                if DEBUG then print(string.format("WARN: ignoring message from %s, empty message.", tostring(plySID))) end
                return
            else
                if DEBUG then print(string.format("sv: transmitting message from %s, msg: %s", plySID, content)) end
                net.start("aeiou")
                net.writeString(plySID)
                net.writeString(content)
                net.sendPVS(ply:getPos())
            end
        end
    end)
end

if CLIENT then
    if not hasPermission("bass.loadURL", "https://tts.cyzon.us/tts") then return end
    if DEBUG then print("cl: DECTalk loaded on client.") end
    
    print("DECTalk initialised! Type :<text> to use it. Remember you have a 128-char limit and everyone can use it!")

    net.receive("aeiou", function()
        local ply = net.readString()
        local msg = net.readString()
        local plyAuthor = find.playerBySteamID(ply)

        if DEBUG then print(string.format("cl: recieved msg from %s wordcount: %i", ply, #msg)) end

        bass.loadURL("https://tts.cyzon.us/tts?text=" .. urlencode(msg), "3d noblock", function(a, e, n)
            -- since Starfall has no way to keep track of audio objects
            -- we will have to manage the lifecycle oureselves via a local table
            coroutine.wrap(function() 
                table.insert(references, {
                    ref = a,
                    timestamp = os.time()
                })
            end)()

            hook.add("Tick", "followSound", function()
                a:setPos(plyAuthor:getPos())
                
                if a:isStopped() then
                    if DEBUG then print("cl: sound finished, removing tick hook") end
                    hook.remove("Tick", "followSound")
                end
            end)

            a:setVolume(1.5)
            
            if a:isValid() then
                a:play()
            else
                if DEBUG then print("cl: WARN: attempted to play invalid object (did it disappear!?)") end
            end

            local cogc = coroutine.create(function()
                -- we may have ended up with a unsorted table, let's fix that
                -- sort table by oldest at the top to most recent at the bottom.
                table.sort(references, function(a, b) return a.timestamp < b.timestamp end)

                if #references ~= 0 then
                    -- scan for references that are older than 10 seconds or aren't playing anymore
                    for i, v in ipairs(references) do
                        if v.ref:isStopped() then
                            if DEBUG then print(string.format("cl: Destroying reference, ts: %i sp: %i athr: %s", v.timestamp, i, plyAuthor:getSteamID())) end
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