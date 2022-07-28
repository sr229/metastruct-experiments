--@name Test-Serverinfo
--@author Minori
--@server

--[[
    This table contains the server metadata that is not usually need to be updated.
    So it's fine to initialize them like this immediately.
    TODO: Why is serverFrameTime nil? I don't get it.
]]
local serverMetadata = {
    serverName = game.getHostname(),
    map = game.getMap(),
    maxPlayers = game.getMaxPlayers()
}

--[[
    This keeps track of who is lagging the server, for visualization purposes.
    The format would be the player's name and their Lag Point (LP) which is calculated based on info
    we can publicly access in starfall.
]]
local serverBaddies = {}
