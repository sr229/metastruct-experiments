--@name Not very accurate ESP-ish (Coroutine edition)
--@author Minori
--@shared

if SERVER then
    chip():setNoDraw(true)
end

local function displayAllPlys()
    local plys = find.allPlayers()

    if not plys then
        coroutine.yield()
    else
        for _, v in ipairs(plys) do
            if v ~= owner() then
                -- draw a rectangle is to where the player is relative to screen space
                local pos = v:obbCenterW():toScreen()
                -- caclulate distance between self and ent
                local dist = v:getPos():getDistance(owner():getPos()) - 27

                if v:isAlive() then
                    render.setColor(Color(230, 230, 0))
                    render.drawText((pos.x), (pos.y - 30),
                        string.format("HP: %i AP: %i DIST: %i", v:getHealth(), v:getArmor(), dist), 0)
                else
                    render.setColor(Color(255, 50, 0))
                    render.drawText((pos.x), (pos.y - 30), string.format("[DEAD] DIST: %i", dist), 0)
                end


                -- FIXME: using getName() causes EasyChat to error out which errors out the SF
                -- so we're only using the SteamID for now
                render.drawText(pos.x, (pos.y - 45), v:getName(), 0)
                render.drawRectFast(pos.x, pos.y, 10, 15)
            end
        end
        coroutine.yield()
    end
end

if CLIENT then
    if player() == owner() then
        enableHud(owner(), true)
        hook.add("postdrawhud", "ent_tracker", function()
            local plyco = coroutine.create(displayAllPlys)
            coroutine.resume(plyco)
        end)
    else
        return
    end
end
