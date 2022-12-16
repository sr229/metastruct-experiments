Char2Hex = function(c) return string.format("%%%02X", string.byte(c)) end

function UrlEncode(url)
    if url == nil then return end
    url = url:gsub("\n", "\r\n")
    url = url:gsub("([^%w ])", Char2Hex)
    url = url:gsub(" ", "+")

    return url
end

Hex2Char = function(x) return string.char(tonumber(x, 16)) end

UrlDecode = function(url)
    if url == nil then return end
    url = url:gsub("+", " ")
    url = url:gsub("%%(%x%x)", Hex2Char)

    return url
end
-- ref: https://gist.github.com/ignisdesign/4323051
-- ref: http://stackoverflow.com/questions/20282054/how-to-urldecode-a-request-uri-string-in-lua
-- to encode table as parameters, see https://github.com/stuartpb/tvtropes-lua/blob/master/urlencode.lua