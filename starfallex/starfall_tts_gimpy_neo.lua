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


getRemoteLanguageIndex()
parseLanguageIndex()