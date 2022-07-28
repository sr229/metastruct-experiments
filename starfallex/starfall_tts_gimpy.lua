--@name Starfall-TTS
--@author Minori, Henke, Empy, et al.
--@include https://gist.githubusercontent.com/sr229/5e6f3a5b03181704a871207c14706499/raw/2ee5b6cfb3a875a5ad2024a38d0131cfb5278785/url-encode.lua as henke.txt
--@client

local remoteLanguageIndex = "https://raw.githubusercontent.com/sr229/metastruct-experiments/master/starfall_metadata/allowed_google_voices.json"
local languageIndex = {}
local errorLookup = { [2] = "Invalid language" }

local DEFAULT_LANGUAGE = "en-gb"
local currentLang = DEFAULT_LANGUAGE
require("henke.txt")

-- Check if client has permission
if not hasPermission("bass.loadURL", "https://translate.google.com/translate_tts") then return end

local function getRemoteLanguageIndex()
    if not hasPermission("http.get", remoteLanguageIndex) then return end

    print("Building language index. Please be patient...")
    http.get(remoteLanguageIndex, function(body, len, hdrs, code)
        if len > 0 then
            local rawData = json.decode(body)

            if rawData then
                for i, v in pairs(rawData.voices) do
                    table.insert(languageIndex, i, v)
                end
            else
                print("Error: Could not decode JSON")
            end

            print("TTS is now ready! Available voices are: ")
            printTable(languageIndex)
            print("Type ':<lang>' to switch to that language.\nType ';<text>' to use the TTS!")
            print("Have fun :)")
        end
    end)
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

-- check if the value exists in a table
local function hasval(tab, val)
    for _, v in pairs(tab) do
        if v == val then
            return true
        end
    end
    return false
end


getRemoteLanguageIndex()

hook.add("playerchat", "tts", function(ply, txt)
    if ply ~= owner() then return end

    if string.sub(txt, 1, 1) == ":" then
        local l = string.gsub(txt, ":", "")
        if #l > 1 then
            local lastLang = currentLang

            if hasval(languageIndex, string.lower(l)) then
                currentLang = l
                print("Language set to " .. l)
            else
                print("Language " .. l .. " not found. Check available languages for valid ones.")
                currentLang = lastLang
            end
        end
    end

    if string.sub(txt, 1, 1) ~= ";" then return end

    txt = string.sub(txt, 2)
    if #txt < 1 then return end

    txt = urlencode(txt)

    RequestTTS(txt, currentLang, function(snd, err, name)
        if not snd then
            print("error: " .. errorLookup[err])

            if err == 2 then
                -- reset everything!!
                currentLang = DEFAULT_LANGUAGE

                RequestTTS(txt, currentLang, function(s, e, n)
                    if not snd then return end

                    DoTTS(snd)
                end)
            end

            return
        end

        DoTTS(snd)
    end)
end)