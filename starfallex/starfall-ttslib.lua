--@name Starfall-TTSLib
--@author Minori
--@shared
local VoiceRemoteList = {
    {
        URL = "https://tetyys.com/SAPI4/SAPI4?voice%s&pitch=100&speed150&text=",
        Name = "sapi4",
        Voices = {"Sam", "Mike", "Mary"}
    },
    {
        URL = "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=%s&q=%s",
        Name = "google",
        Voices = {"en", "fr", "jp"}
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

function TTSLib:speak(ent, txt, remote, variant)
    for k,v in ipairs(VoiceRemoteList) do
        if v.Name == remote then
            if v.Name == "dectalk" then
                local url = v.URL .. txt

                http.get(url, function(code, body)
                    if code == 200 then
                        file.writeTemp("tts.mp3", body)
                        ent:EmitSound("tts.mp3")
                    else
                        print("Error: HTTP Code" .. code)
                    end
                end)
            elseif itExists(v.Voices, variant) then
                local url = string.format(v.URL, variant, txt)

                http.get(url, function(code, body)
                    if code == 200 then
                        file.writeTemp("tts.mp3", body)
                        ent:EmitSound("tts.mp3")
                    else
                        print("Error: HTTP Code" .. code)
                    end
                end)
            end
        end
    end
end