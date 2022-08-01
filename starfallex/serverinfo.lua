--@name Test-Serverinfo
--@author Minori
--@shared
--[[
    This grabs the basic server information we can print later on
    This table doesn't need to be updated much so we can initialize this immediately.
]]
local serverMetadata = {
    serverName = game.getHostname(),
    map = game.getMap(),
    maxPlayers = game.getMaxPlayers(),
    cTime = os.date(),
    sTime = os.date()
}

if SERVER then
    hook.add("think", "serverTimeTick", function()
        local prevSTime = ""

        if prevSTime != os.date() then
            prevSTime = os.date()
            net.start("serverTime")
            net.writeString(os.date())
            net.send(owner(), false)
        end
    end)
end

if CLIENT then
    hook.add("think", "clientTimeTick", function()
        serverMetadata.cTime = os.date()
    end)

    net.receive("serverTime", function()
        serverMetadata.sTime = net.readString()
    end)

    hook.add("render", "metadataRenderMain", function()
        render.setColor(Color(255, 0, 0, 255))
        render.drawText(10, 10, "Server Name: " .. serverMetadata.serverName)
        render.drawText(10, 30, "Map: " .. serverMetadata.map)
        render.drawText(10, 50, "Client Time: " .. serverMetadata.cTime)
        render.drawText(10, 70, "Server Time: " .. serverMetadata.sTime)
    end)

    hook.add("ComponentUnlinked", "unlink_evt", function()
        hook.remove("think", "curTimeMutator")
        hook.remove("render", "metadataRenderMain")
    end)
end