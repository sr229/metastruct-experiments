-- This should be added either as a autorun
-- or on your own outfit.

hook.Add("AFK", "pacafk", function(ply, afk)
    if ply and ply == LocalPlayer() then
        if afk then
            LocalPlayer():ConCommand("pac_event afk 1")
        else
            LocalPlayer():ConCommand("pac_event afk 0")
        end
    end
end)
