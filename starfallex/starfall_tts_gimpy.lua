--@name GimpyTTS
--@author Mavain, Minori, Henke, et al.
--@client

local VALID_LANGS = {"en-gb", "en-ca", "en-us", "en-au", "ja", "ph", "so"}
local errorLookup = {[2] = "Invalid language"}

local defaultLang = "en-gb"
local curLang = defaultLang
local soundref

-- Check if client has permission
if not hasPermission("bass.loadURL", "https://translate.google.com/translate_tts") then return end

-- A local function to check if this exists on our valid langs
-- if it doesn't, we throw error
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function RequestTTS(txt, l, callback)
    bass.loadURL("https://translate.google.com/translate_tts?ie=UTF-8&q=" .. txt .. "&tl=" .. l .. "&client=tw-ob", "3d", callback)
end

local function DoTTS(sound)
    -- we dispose the current reference, then we create a new one
    if soundref then soundref:stop() end
    soundref = sound

    --local soundLength = sound:getLength()
    hook.add("think", "soundFollow", function()
        if sound:isValid() then sound:setPos(owner():getPos()) else
           hook.remove("think", "soundFollow")
        end
    end)

    sound:play()
end

hook.add("playerchat", "tts", function(ply, txt)
    if ply ~= owner() then return end

    if string.sub(txt, 1, 1) == ":" then
        local l = string.gsub(txt, ":", "")
        if #l > 1 then
            local lastLang = l

            if has_value(VALID_LANGS, l) then
                curLang = l
            else
                print("Invalid parameter, check source for valid languages.")
                -- Do not error, just reassign back the last language selection
                curLang = lastLang
            end
        end
    end

    if string.sub(txt, 1, 1) ~= ";" then return end

    txt = string.sub(txt,2)
    if #txt < 1 then return end

    txt = http.urlEncode(txt)

    RequestTTS(txt, curLang, function(sound, err, name)

        if not sound then
            print("error: " .. errorLookup[err])

            if err == 2 then
               curLang = defaultLang

                RequestTTS(txt, curLang, function(s, e, n)
                    if not sound then return end

                    DoTTS(sound)
                end)
            end

            return
        end

        DoTTS(sound)
    end)
end)