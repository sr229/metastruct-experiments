--@name StarfallTop
--@author Minori
--@shared
local serverMetadata = {
    serverName = game.getHostname(),
    map = game.getMap(),
    cTime = "",
    sTime = "",
    runningChips = {}
}

function getRunningChips()
    for _, v in ipairs(find.byClass("starfall_processor")) do
        if not isValid(v) then continue end

        table.insert(serverMetadata.runningChips, {
            ["this"] = v,
            ["chip_name"] = #v:getChipName() ~= 0 and v:getChipName() or "<none>",
            ["chip_owner"] = v:getOwner():getName(),
            ["chip_quota"] = math.floor(v:getQuotaAverage() * 100000)
        })
    end
end

if SERVER then
    local prevName = ""
    local prevSTime = ""

    hook.add("tick", "serverTimeTick", function()
        if prevSTime ~= os.date() then
            prevSTime = os.date()
            net.start("serverTime")
            net.writeString(os.date())
            net.send(owner(), false)
        end
    end)

    -- METASTRUCT SPECIFIC HOOK
    hook.add("tick", "e621", function()
        if prevName ~= game.getHostname() then
            prevName = game.getHostname()
            net.start("serverName")
            net.writeString(game.getHostname())
            net.send(owner(), false)
        end
    end)
end

if CLIENT then
    getRunningChips()

    hook.add("tick", "clientTimeTick", function()
        serverMetadata.cTime = os.date()
    end)

    -- METASTRUCT SPECIFIC HOOK
    net.receive("serverTime", function()
        serverMetadata.sTime = net.readString()
    end)

    net.receive("serverName", function()
        serverMetadata.serverName = net.readString()
    end)
    -- update the table
    timer.create("update", 1, 0, function()
        if serverMetadata.runningChips == {} then
            -- don't forget to populate dr freeman
            getRunningChips()
        end

        for i, v in ipairs(serverMetadata.runningChips) do
            local ent = v["this"]
            v.chip_quota = math.floor(ent:getQuotaAverage() * 100000)
        end
    end)

    hook.add("render", "metadataRenderMain", function()
        render.setColor(Color(255, 0, 0, 255))
        render.drawText(10, 10, "Server Name: " .. serverMetadata.serverName)
        render.drawText(10, 30, "Map: " .. serverMetadata.map)
        render.drawText(10, 50, "Client Time: " .. serverMetadata.cTime)
        render.drawText(10, 70, "Server Time: " .. serverMetadata.sTime)
        render.setColor(Color(255, 255, 255 , 255))
        render.drawText(10, 110, "Running Chips: ")

        render.setColor(Color(82, 113, 250))
        for i, v in ipairs(serverMetadata.runningChips) do
            render.drawText(10, 130 + (i * 20), "" .. v["chip_name"] .. " by " .. v["chip_owner"] .. " (" .. v["chip_quota"] .. "us)")
        end
    end)
end