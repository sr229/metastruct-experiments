--@name Starfall-TTS (Shared)
--@author Minori, Henke, Empy, et al.
--@include https://raw.githubusercontent.com/sr229/metastruct-experiments/master/starfallex/google_tts/libraries/hasvalue.lua as hasvalue.txt
--@include https://raw.githubusercontent.com/sr229/metastruct-experiments/master/starfallex/google_tts/libraries/urlencode.lua as urlencode.txt
--@shared

-- constants
DEFAULT_LANGUAGE = "en-gb"
DEBUG = false
REMOTE_INDEX = "https://raw.githubusercontent.com/sr229/metastruct-experiments/master/starfall_metadata/allowed_google_voices.json"

-- mutables
BASS_REFERENCES = {}

-- top level requires
require("urlencode.txt")
require("hasvalue.txt")

local function getRemoteLanguageIndex(idx)
    if not hasPermission("http.get", "https://translate.google.com/translate_tts") then
        error("Cannot fetch remote index, context has no perms!")
    end

    http.get(REMOTE_INDEX, function(body, len)
        if len > 0 then
            local rawData = json.decode(body)

            if rawData then
                for i, v in pairs(rawData.voices) do
                    table.insert(idx, i, v)
                end
            else
                error("Could not decode JSON")
            end
        end

        if #idx > 0 then
            print("FUNC: Finished fetching index.")
            print(string.format("Available Languages: %s", table.concat(idx, ", ")))
        end
    end)
end



if SERVER then
    -- Userdata will collect the Player ID and the language.
    -- Layout may look something like this: 
    -- userdata = {
    --     [1] = "en-gb"
    -- }
    local userdata = {}
    -- if you just want to hide it from the idiots around you
    -- chip():setOwner(true)

    hook.add("PlayerSay", "msgHandler", function(ply, msg)
        if ply and string.sub(msg, 1, 1) == ":" and userdata[ply:getUserID()] then

            net.start("broadcast_tts")
            net.writeInt(ply:getUserID(), 32)
            net.writeString(userdata[ply:getUserID()])
            net.writeString(tostring(string.sub(msg, 2)))
            net.send()
        elseif ply and string.sub(msg, 1, 1) == ":" then
            -- initialize the user
           table.insert(userdata, ply:getUserID(), DEFAULT_LANGUAGE)

           net.start("broadcast_tts")
           net.writeInt(ply:getUserID(), 32)
           net.writeString(userdata[ply:getUserID()])
           net.writeString(tostring(string.sub(msg, 2)))
           net.send()
        end

        if ply and string.sub(msg, 1, 1) == "+" and userdata[ply:getUserID()] then
            local preferredLang = tostring(string.sub(msg, 2))

            print(string.format("Switched to %s", preferredLang))
            print("WARN: server has no knowledge of valid languages! Make sure what you entered is correct!")
            userdata[ply:getUserID()] = preferredLang
        elseif ply and string.sub(msg, 1, 1) == "+" then
            local preferredLang = tostring(string.sub(msg, 2))
            
            print(string.format("No preferences found for %s (%s). Initializing with a default language.", ply:getName(), ply:getUserID()))
            table.insert(userdata, ply:getUserID(), preferredLang or DEFAULT_LANGUAGE)
        end
    end)
end

if CLIENT then
    -- keep client cache of index
    -- TODO: make clientside verification for language switching
    local clIdx = {}
    getRemoteLanguageIndex(clIdx)
    
    -- Check if client has permission
    if not hasPermission("bass.loadURL", "https://translate.google.com/translate_tts") then
        print("WARNING: Your starfall settings prevents this chip from working, please redo your settings.")
    else
        print("CLIENT: Clientside hook initialized.")
    end

    local function requestTTS(txt, lng, callback)
        local url = string.format("https://translate.google.com/translate_tts?ie=UTF-8&q=%s&tl=%s&client=tw-ob", txt, lng)
        bass.loadURL(url, "3d noblock", callback)
    end

    local function doTTS(ply, sound)

        -- check for validity
        if not sound then
            error("Sound is invalid or nil!")
        end

        table.insert(BASS_REFERENCES, {
            ref = sound,
            timestamp = os.time()
        })

        hook.add("think", "soundFollow", function()
            if sound:isValid() then
                sound:setPos(ply:getPos())
            else
                hook.remove("think", "soundFollow")
            end
        end)

        sound:setVolume(1.3)
        sound:play()
    end

    local function gc()
        table.sort(BASS_REFERENCES, function(a, b) return a.timestamp < b.timestamp end)

        if #BASS_REFERENCES ~= 0 and #BASS_REFERENCES > 2 then
            BASS_REFERENCES[1].ref:destroy()
            table.remove(BASS_REFERENCES, 1)
        end
    end

    net.receive("broadcast_tts", function()
        local ply = player(net.readInt(32))
        local lang = net.readString()
        local msg = net.readString()

        if DEBUG then print(string.format("DEBUG: Ply: %s, Lang: %s, Msg: %s", ply:getName(), lang, msg)) end
        requestTTS(UrlEncode(msg), lang, function(s)
            if s then
                doTTS(ply, s)
                gc()
            end
        end)
    end)
end