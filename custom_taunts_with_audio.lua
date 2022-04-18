-- Code by Minori
-- Based on custom_taunt code by Henke

local MATCHING_SOUNDS_MMD = {
    fulldance1 = "",
    fulldance2 = "",
    fulldance3 = "",
    fulldance4 = "",
    fulldance5 = "",
    fulldance6 = "",
    fulldance7 = "",
    fulldance8 = "",
    fulldance9 = "",
    fulldance10 = ""
}

local INFO_TYPES = {
    Stop = 0,
    Dance = 1,
    Emote = 2,
    Traversal = 3,
    Follow = 4,
    SPeed = 5,
    LoopUpdate =6,
    RequestInfo = 7,
    Sterile = 8,
}

function PlayMusic(music)
    print("DEBUG: Playing" .. tostring(music))
    -- as there is no proper way to do webaudio
    -- we will be abusing pac here and attach
    -- an audio in a outfit
    -- FIXME: This doesn't know how to clean out music
    local audio = pac.CreatePart("mmd_audio_" .. tostring(music))

    audio:SetPath(tostring(music))
    audio:SetParent(self)

    for _, part in pairs(pac.GetLocalParts()) do
        if part.ClassName == "group" then
            part:SetParent(part)
            break
    end
  end
end

function custom_taunts:OnDanceChanged(sid64, newdata)

   --  if not sid64 == LocalPlayer():SteamID64 then return nil end

    if newdata.type == INFO_TYPES.Dance then
        print("DEBUG: State change to Dance, applying music.")
        local dance = newdata.sequence
        local music  = MATCHING_SOUNDS_MMD[dance]

        if not music then print("ERROR: could not find song for dance" .. dance) return end

        --FIXME: find a way to clean this out!
        PlayMusic(music)
    end

    if newdata.type == INFO_TYPES.Stop then
        print("DEBUG: State changed to Stopped, throwing away everything.")
        -- clean up everything
        for _, part in pairs(pac.GetLocalParts()) do
              if not string.find(part:Name(), "mmd_music_%w") then
                  return
              else
                 pac.RemovePart(part)
            end
        end
    end
end

