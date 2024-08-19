tbl_utils = {}


tbl_utils.contains = function (table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end