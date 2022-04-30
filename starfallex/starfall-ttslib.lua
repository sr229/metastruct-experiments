--@name Starfall-TTSLib
--@author Minori
--@shared

local remoteList = {
    "https://tetyys.com/SAPI4/SAPI4?voice%s&pitch=100&speed150&text=",
    "htts://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=%s&q=%s",
    "https://tts.cyzon.us/tts?text="
}

local sapi4Voices = {
    "Sam",
    "Mike",
    "Mary"
}

local googleVoices = {
    "en",
    "fr",
    "jp"
}

function itExists(table, val)
    for i, v in ipairs(table) do
        if v ~= val then
            return false
        else
            return true
        end
    end
end

function speak(ent, txt, remote, variant)
    if not itExists(remoteList, remote) then
        print(remote .. " Does not exist in this context")
    else
        local url = nil

        if remote == "sapi4" then
            if not itExists(sapi4Voices, variant) then
               print("Invalid voice argument, valid voices are: Sam, Mike, Mary")
            else
               url = string.format(remoteList[1], voice)
            end
        end

        if remote == "google" then
            if not itExists(googleVoices, variant) then
                print("Invalid voice argument, valid voices are: en, fr, jp")
            else
                url = string.format(remoteList[2], variant, txt)
            end
        end

        if remote == "dectalk" then
            if variant ~= nil then
                print("Warning: DECTalk does not have arguments, ignoring.")
                url = remote[3]
            else
                url = remote[3]
            end
        end

        http.get(url .. text, function(code, body)
            if code == 200 then
                file.writeTemp("tts.mp3", body)

                if ent ~= nil then
                    sounds.create(ent, "tts.mp3")
                else
                    print("No entity to play sound on")
                end

                --let's not wait for Starfall to delete this
                --dispose it immediately
                file.delete("tts.mp3")
            end
        end)
    end
end