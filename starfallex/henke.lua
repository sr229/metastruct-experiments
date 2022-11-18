--@name Meowportation
--@author Henke
--@shared
if SERVER then
    chip():setNoDraw(true)

    local function getPlayerByName(str)
        for k, v in pairs(find.allPlayers()) do
            if string.match(string.lower(v:getName()), str) then return v end
        end
    end

    local function gotoPlayer(pl)
        pos = pl:getPos() + pl:getForward() * 64

        if hasPermission("entities.canTool", owner()) then
            owner():setPos(pos)
        else
            local seat = prop.createSeat(owner():getPos(), Angle(), "models/nova/jeep_seat.mdl", true)
            seat:setNoDraw()
            seat:use()
            seat:setPos(pos)
            seat:remove()
        end
    end

    hook.add("PlayerSay", "gotoplayer", function(ply, text, teamChat)
        if ply == owner() then
            local cmd = string.sub(string.lower(text), 1, 5)
            local str = string.sub(string.lower(text), 7) --lazy ok, u can basically do !sudo,name !sudo name !sudooname

            if cmd == "!meow" then
                local pl = getPlayerByName(str)

                if isValid(pl) then
                    gotoPlayer(pl)
                    print("Teleported to " .. pl:getName())
                end

                return ""
            end
        end
    end)
end