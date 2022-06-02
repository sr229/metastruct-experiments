--@name GimpyTTS
--@author Mavain and Minori
--@client

local VALID_LANGS = {"en-gb", "en-ca", "en-us", "en-au", "ja", "ph", "so"}

local lang = "en-gb"
local soundref

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

hook.add("playerchat", "henkey", function(ply, txt)
    if ply ~= owner() then return end

    if string.sub(txt, 1, 1) ~= ";" then return end
    txt = string.sub(txt, 2)
    
    if has_value(VALID_LANGS, txt) then 
        lang = txt
    else
      if txt:len() == 0 then return end

      bass.loadURL("https://translate.google.com/translate_tts?ie=UTF-8&q=" .. http.urlEncode(txt) .. "&tl=" .. lang .. "&client=tw-ob", "3d",
    function(a, err, name)
          -- we dispose the current reference, then we create a new one
          if soundref then soundref:stop() end
          -- make sure we do not assign nil
          if not a then return end
          soundref = a

          hook.add("think", "soundFollow", function() a:setPos(owner():getPos()) end)
          -- do not make it play anything if its nil
          if not soundref then return end
        
          soundref:play()
      end)
   end
end)
