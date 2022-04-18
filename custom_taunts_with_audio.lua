-- A really hacky way to add sounds on custom_taunts
-- Because why not, besides PAC3 is being abused everyday anyway

local MATCHING_SOUNDS_MMD = {
    fulldance1 = "",
    fulldance2 = "https://yuri.might-be-super.fun/5mAY8B3.ogg",
    fulldance3 = "",
    fulldance4 = "",
    fulldance5 = "",
    fulldance6 = "",
    fulldance7 = "",
    fulldance8 = "",
    fulldance9 = "",
    fulldance10 = "",
}

local INFO_TYPES = {
    Stop = 0,
    Dance = 1,
    Emote = 2,
    Traversal = 3,
    Follow = 4,
    SPeed = 5,
    LoopUpdate = 6,
    RequestInfo = 7,
    Sterile = 8,
}

function PlayMusic(music)
    print("DEBUG: Playing " .. tostring(music))

    -- as there is no proper way to do webaudio
    -- we will be abusing pac here and attach
    -- an audio in a outfit
    -- FIXME: This doesn't know how to clean out music
    local group = pac.CreatePart("group")
    group:SetPlayerOwner(LocalPlayer())
    group.Name = "mmd_music"

    local event = pac.CreatePart("event")
    event:SetParent(group)
    event.Event = "is_on_ground"

    local musicPart = pac.CreatePart("sound2")
    musicPart:SetPath(music)
    musicPart:SetParent(event)

    local transmissionID = math.random(1, 0x7FFFFFFF)

    pace.SendPartToServer(group, {
        partID = 1,
        totalParts = 1,
        transmissionID = transmissionID,
        temp_wear_filter = nil,
    })
end

function custom_taunts:OnDanceChanged(sid64, newdata)

   if sid64 ~= LocalPlayer():SteamID64() then return end

    if newdata.type == INFO_TYPES.Dance then
        print("DEBUG: State change to Dance, applying music.")
        local dance = newdata.sequence
        local music = MATCHING_SOUNDS_MMD[dance]

        if not music then print("ERROR: could not find song for dance" .. dance) return end

        PlayMusic(music)
    end
end

custom_taunts.OldDestroyPlayerInfo = custom_taunts.OldDestroyPlayerInfo or custom_taunts.DestroyPlayerInfo
function custom_taunts:DestroyPlayerInfo(sID64)
  self:OldDestroyPlayerInfo(sID64)
  print("State changed to Stopped.")
end