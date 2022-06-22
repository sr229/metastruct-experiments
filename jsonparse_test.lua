local url = "https://raw.githubusercontent.com/sr229/metastruct-experiments/master/starfall_metadata/allowed_google_voices.json"
local data

http.Fetch(url, function(body, length, headers, code)
    if length == 0 then
        print("Invalid length! Length should be non-zero.")

        return
    end

    data = util.JSONToTable(body)
    print("DEBUG: " .. tostring(data))
    PrintTable(data)
    say(tostring(data))
end)