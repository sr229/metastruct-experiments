--@name Starfall-TTS
--@author Minori
--@shared
local ttsSnd

local VoiceRemoteList = {
    {
        URL = "https://tetyys.com/SAPI4/SAPI4?voice%s&pitch=100&speed150&text=",
        Name = "sapi4",
        Voices = {"Sam", "Mike", "Mary"},
        DefaultVoice = "Sam"
    },
    {
        URL = "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=%s&q=%s",
        Name = "google",
        Voices = {"en", "fr", "jp"},
        DefaultVoice = "en"
    },
    {
        URL = "https://tts.cyzon.us/tts?text=",
        Name = "dectalk",
    }
}

function itExists(table, val)
    for index, value in pairs(table) do
        if value == val then
            return true
        end
    end
    return false
end

local function playSound(url)
    if ttsSnd then ttsSnd:stop() end

    bass.loadURL(url, "3d noblock",  function(snd, err, errtxt)
        if snd then
            ttsSnd = snd
            snd:SetVolume(1)
            snd:Play()

            hook.add("think", "snd", function()
                if isValid(ttsSnd) and isValid(chip()) then
                    ttsSnd:setPos(chip():getPos())
                end
            end)
        else
            print(errtxt)
        end
    end)
end

local function playTTS(ent, txt, remote, variant)
    for k,v in ipairs(VoiceRemoteList) do
        if v.Name == remote then
            if v.Name == "dectalk" then
                url = v.URL .. txt
                playSound(url)
            elseif itExists(v.Voices, variant) then
                url = string.format(v.URL, variant, txt)
                playSound(url)
            elseif variant == nil then
                url = string.format(v.URL, v.DefaultVoice, txt)
                playSound(url)
            end
        end
    end
end


if SERVER then
    hook.add("PlayerSay", "Hey", function(ply, txt)
        if ply == owner() and txt:sub(1, 6) == "!tts2" then
            net.Start("henke")
            net.WriteString(txt:sub(7))
            net.send()

            return ""
        end
    end)
else
    net.recieve("henke", function(len)
        body = net.readSring()
        playTTS(chip(), body, "google", "en")
    end)
end