--@name Starfall-TTS
--@author Minori

local VoiceRemoteList = {
    {
        URL = "https://tetyys.com/SAPI4/SAPI4?voice%s&pitch=100&speed150&text=",
        Name = "sapi4",
        Voices = {"Sam", "Mike", "Mary"},
        DefaultVoice = "Sam"
    },
    {
        URL = "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=%s&q=",
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

local function playSound(url, ent)
    bass.loadURL(tostring(url), "3d", function(audio, err, name)
        hook.add("think", "followSound", function() audio:SetPos(ent:GetPos()) end)
        audio:play()
    end)
end

local function playTTS(ent, txt, remote, variant)
    for k,v in ipairs(VoiceRemoteList) do
        if v.Name == remote then
            if v.Name == "dectalk" then
                url = v.URL .. txt
                playSound(ent, url)
            elseif itExists(v.Voices, variant) then
                url = string.format(v.URL, variant) .. txt
                print(url .. " Type: " .. type(url))
                playSound(ent, url)
            elseif variant == nil then
                url = string.format(v.URL, v.DefaultVoice) .. txt
                playSound(ent, url)
            end
        end
    end
end

hook.add("playerchat", "henkey", function(ply, txt)
    if ply ~= owner() then return end
    playTTS(ply, txt, "google", "en")
end)