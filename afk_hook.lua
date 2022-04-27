-- This should be added either as a autorun
-- or on your own outfit.
hook.Add("AFK", "pac_afk", function(pl, afk)
    if pl and pl == LocalPlayer() and afk then
        LocalPlayer():ConCommand("pac_event afk 1")
    else
        LocalPlayer():ConCommand("pac_event afk 0")
    end
end)

local away = false hook.Add("Think", "pac_away", function()
    if not away and not system.HasFocus() then
        away = true
        LocalPlayer():ConCommand("pac_event away 1")
    end
    if away and system.HasFocus() then
        away = false
        LocalPlayer():ConCommand("pac_event away 0")
    end
end)