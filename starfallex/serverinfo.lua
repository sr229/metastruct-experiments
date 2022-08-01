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
        --exclude self
        if v == chip() then continue end

        -- do not include empty objects
        if v == {} then continue end

        -- do not include objects with no owner
        if not v:getOwner() then continue end

        -- check if entry already exists
        if itExists(serverMetadata.runningChips, v) then
            continue
        elseif not isValid(v) then
            continue
        else
            table.insert(serverMetadata.runningChips, {
                this = v,
                chip_name = #v:getChipName() ~= 0 and v:getChipName() or "<none>",
                chip_owner = #v:getOwner():getName() ~= 0 and v:getOwner():getName() or "<none>",
                chip_quota = math.floor(v:getQuotaAverage() * 100000)
            })
        end
    end
end

function itExists(t, v)
    for _, sv in ipairs(t) do
        if sv.this == v then
            return true
        end
    end
    return false
end

function cleanupInvalid(t, v)
    for i, sv in ipairs(t) do
        if not isValid(sv.this) then
            table.remove(t, i)
        end
    end
end

if SERVER then
    local prevName = ""
    local prevSTime = ""

    hook.add("think", "serverTimeTick", function()
        if prevSTime ~= os.date() then
            prevSTime = os.date()
            net.start("serverTime")
            net.writeString(os.date())
            net.send()
        end
    end)

    -- METASTRUCT SPECIFIC HOOK
    hook.add("think", "e621", function()
        if prevName ~= game.getHostname() then
            prevName = game.getHostname()
            net.start("serverName")
            net.writeString(game.getHostname())
            net.send()
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
        for i, v in ipairs(serverMetadata.runningChips) do
            local ent = v.this
            v.chip_quota = math.floor(ent:getQuotaAverage() * 100000)
        end
    end)

    -- wait why do we ise a timer?
    -- well it seems OnEntityCreated doesn't have the full info immediately
    -- so we'll have to wait for 3s then get running chips again
    timer.create("update_list_scheduled", 3, 0, function()
        getRunningChips()
    end)

    -- mark and sweep invalid entries
    hook.add("think", "dispose_object", function()
        cleanupInvalid(serverMetadata.runningChips)
    end)

    hook.add("render", "metadataRenderMain", function()
        render.setColor(Color(255, 34, 34))
        render.drawText(10, 10, "Server Name: " .. serverMetadata.serverName)
        render.drawText(10, 30, "Map: " .. serverMetadata.map)
        render.drawText(10, 50, "Client Time: " .. serverMetadata.cTime)
        render.drawText(10, 70, "Server Time: " .. serverMetadata.sTime)
        render.setColor(Color(255, 255, 255 , 255))
        render.drawText(10, 110, "Running Chips: ")

        render.setColor(Color(82, 113, 250))
        if serverMetadata.runningChips == {} then
            render.drawText(10, 130, "No Chips Running!")
        end

        for i, v in ipairs(serverMetadata.runningChips) do
            render.drawText(10, 130 + (i * 20), "" .. v.chip_name .. " by " .. v.chip_owner .. " (" .. v.chip_quota .. "us)")
        end
    end)
end