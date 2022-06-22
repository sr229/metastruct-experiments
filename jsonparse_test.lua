local url = "https://raw.githubusercontent.com/sr229/metastruct-experiments/master/starfall_metadata/allowed_google_voices.json"
local data


local function hasValue(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

http.Fetch(url, function(body, length, headers, code)
    if length == 0 then
        print("Invalid length! Length should be non-zero.")

        return
    end

    data = util.JSONToTable(body)
    print("DEBUG: " .. tostring(data))
    PrintTable(data)
    say(tostring(data))

    -- now to check if we can langselect
    local testSetLang = "en"
    local langTable = data.voices

    PrintTable(langTable)

    if hasValue(langTable, testSetLang) then
        print("Lang " .. testSetLang .. " is valid!")
        say("DEBUG: Langselect Test succeeded now stop being an idiot and actually do your starfall code you little shit.")
    else
        print("Lang " .. testSetLang .. " is not valid!")
        say("DEBUG: Langselect Test did not succeed.")
    end
end)