--@name Starfall-TTSv2
--@author Minori
--@client

local remoteLanguageIndex = "https://raw.githubusercontent.com/sr229/metastruct-experiments/master/starfall_metadata/allowed_google_voices.json"
local localLanguageIndex = "./tts_index.json"
local languageIndex
local errorLookup = { [2] = "Invalid language" }

local DEFAULT_LANGUAGE = "en-gb"
local currentLang = DEFAULT_LANGUAGE

if not owner() then return end

-- Check if client has permission
if not hasPermission("bass.loadURL", "https://translate.google.com/translate_tts") then return end
if not hasPermission("file.read", localLanguageIndedx) then return end

local function getRemoteLanguageIndex()
    http.get(remoteLanguageIndex, function(body, len, hdrs, code)
        if len > 0 then
            file.write(localLanguageIndex, body)
        end
    end)
end


local function parseLanguageIndex()
   print("Building language index, please be patient...")
   getRemoteLanguageIndex()
   local rawFile = file.read(localLanguageIndex)

   while rawFile == nil do
     -- do nothing while we wait for data
     return
   end

   if not file.exists(localLanguageIndex) then
     print("Parsing index failed.")
   end

   local rawTable = json.decode(rawFile)
   languageIndex = rawTable.voices

   if languageIndex ~= nil then
      print("Index built successfully. You're now ready to use TTS.")
      print("Available languages: ")
      printTable(languageIndex)

      -- Remove the local language index.
      file.delete(localLanguageIndex)
      -- print("DEBUG: languageIndex val: " .. tostring(languageIndex))
   end
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
local function hasval(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end


parseLanguageIndex()

hook.add("playerchat", "tts", function(ply, txt)
    if ply ~= owner() then return end

    if string.sub(txt, 1, 1) == ":" then
        local l = string.gsub(txt, ":", "")
        if #l > 1 then
            local lastLang = currentLang

            if hasval(languageIndex, l) then
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

    txt = http.urlEncode(txt)

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