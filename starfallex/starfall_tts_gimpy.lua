--@name Starfall-TTS
--@author Minori, Henke, Empy, et al.
--@include https://gist.githubusercontent.com/sr229/5e6f3a5b03181704a871207c14706499/raw/2ee5b6cfb3a875a5ad2024a38d0131cfb5278785/url-encode.lua as henke.txt
--@shared
local remoteLanguageIndex = "https://raw.githubusercontent.com/sr229/metastruct-experiments/master/starfall_metadata/allowed_google_voices.json"
local languageIndex = {}

local errorLookup = {
    [2] = "Invalid language"
}

local DEFAULT_LANGUAGE = "en-gb"
local currentLang = DEFAULT_LANGUAGE
require("henke.txt")

if SERVER then
    -- this is just to prevent some idiots from making a copy of the thing, but it won't prevent clientside stealing.
    chip():setNoDraw(true)

    -- hide tts chat messages
    hook.add("PlayerSay", "hide_tts_chat", function(ply, text)

        if ply == owner() and string.sub(text, 1, 1) == ";" then
            net.start("tts_message")
            net.writeString(string.sub(text, 2))
            net.send()
            return ""
        end

        if ply == owner() and string.sub(text, 1, 1) == ":" then
            net.start("tts_language_switch")
            net.writeString(string.sub(text, 2))
            net.send()
            return ""
        end
    end)
end

if CLIENT then
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
                    error("Could not decode JSON")
                end

                print("TTS is now ready! Available voices are: ")
                printTable(languageIndex)
                print("Type ':<lang>' to switch to that language.\nType ';<text>' to use the TTS!")
                print("Have fun :)")
            end
        end)
    end

    local function RequestTTS(txt, lng, callback)
        bass.loadURL("https://translate.google.com/translate_tts?ie=UTF-8&q=" .. txt .. "&tl=" .. lng .. "&client=tw-ob", "3d", callback)
    end

    local function DoTTS(sound)

        -- check for validity
        if not sound then
            error("Sound is invalid or nil!")
        end

        -- we dispose the current reference, then we create a new one
        if soundref then
            soundref:destroy()
        end

        soundref = sound

        --local soundLength = sound:getLength()
        hook.add("think", "soundFollow", function()
            if sound:isValid() then
                sound:setPos(owner():getPos())
            else
                hook.remove("think", "soundFollow")
            end
        end)

        sound:play()
    end

    -- check if the value exists in a table
    local function hasval(tab, val)
        for _, v in pairs(tab) do
            if v == val then return true end
        end

        return false
    end

    getRemoteLanguageIndex()

    net.receive("tts_message", function()
        local text = net.readString()

        RequestTTS(urlencode(text), currentLang, function(s, e)
            if s then
                DoTTS(s)
            else
                error("Error: " .. errorLookup[e])
            end
        end)
    end)

    net.receive("tts_language_switch", function()
        local lang = net.readString()

        if hasval(languageIndex, lang) then
            currentLang = lang
            print("Switched to language " .. lang)
        else
            currentLang = DEFAULT_LANGUAGE
            print("That language isn't valid!")
        end
    end)
end