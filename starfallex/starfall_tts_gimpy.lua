--@name GimpyTTS
--@author Mavain, Minori, Henke, et al.
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

hook.add("playerchat", "fucke2", function(ply, txt)
    if ply ~= owner() then return end

    if string.sub(txt, 1, 1) == ":" then
        local l = string.gsub(txt, ":", "")
        if #l > 1 then
            local lastLang = l

            if has_value(VALID_LANGS, l) then
                lang = l
            else
                print("Invalid parameter, check source for valid languages.")
                -- Do not error, just reassign back the last language selection
                lang = lastLang
            end
        end
    end
    if string.sub(txt, 1, 1) ~= ";" then return end

    txt = string.sub(txt,2)
    if #txt < 1 then return end

    txt = http.urlEncode(txt)

    bass.loadURL("https://translate.google.com/translate_tts?ie=UTF-8&q=" .. txt .. "&tl=" .. lang .. "&client=tw-ob", "3d",
    function(a, err, name)

        if not a then
            print("error: " .. err)
            return
        end
        -- we dispose the current reference, then we create a new one
        if soundref then soundref:stop() end
        soundref = a

        hook.add("think", "soundFollow", function() a:setPos(owner():getPos()) end)
        a:play()
    end)
end)