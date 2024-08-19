hook.Add("Think", "CtpCheck", function()
    if not ctp or not ctp.Toggle then return end

    function ctp:Toggle()
        self = self or ctp

        if ctp:IsEnabled() then
            ctp.Disable()
        else
            ctp.Enable()
        end

        hook.Run("OnCtpStateChanged", ctp:IsEnabled())
    end

    hook.Remove("Think", "CtpCheck")
end)