-- Webaudio based audio implementation override for custom taunts
-- Code by Minori
-- Based on custom_taunt code by Henke
local webaudio = include("pac3/libraries/webaudio.lua")
pac.webaudio2 = webaudio

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

function playMusic(music)
    -- as there is no proper way to do webaudio
    -- we will be abusing pac here and attach
    -- an audio in a outfit
    -- FIXME: This doesn't know how to clean out music
    local audio = pac.CreatePart("mmd_audio_" .. tostring(music))

    audio:SetURL(tostring(music))
    audio:SetVolume(1)
    audio:SetPitch(1)
    audio:SetStopOnHide(true)
    audio:SetPauseOnHide(true)
    audio:SetParent(self)
end

function cleanupAudio(music)
    local name = "mmd_audio_" .. tostring(music)
    pac.RemovePart(name)
end

function custom_taunts:OnDanceChanged(sid64, newdata)
    -- do not run if it's not us
    if sid64 == LocalPlayer():SteamID64 then return end

    if newdata.type == INFO_TYPES.Dance then
        local player = LocalPlayer()
        local dance = newdata.sequence
        local music  = MATCHING_SOUNDS_MMD[dance]

        if not music then print("ERROR: could not find song for dance" .. dance) return end

        --FIXME: find a way to clean this out!
        playMusic(music)
    end
end

