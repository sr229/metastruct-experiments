function HasValue(tab, val)
    for _, v in pairs(tab) do
        if v == val then return true end
    end

    return false
end