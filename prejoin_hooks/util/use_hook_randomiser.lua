interactions = {
    [1] = function(tp)
        hook.Add("StartCommand", "impending_doom", function(ply, cmd)
            local tgtAng = (tp:GetShootPos() - ply:GetShootPos()):GetNormalized():Angle()

            cmd:SetViewAngles(tgtAng)
        end)

        timer.Simple(1.5, function() 
            RunConsoleCommand("actx", "shove")
            RunConsoleCommand("hax", "nosound")
            RunConsoleCommand("saysound", "you are hentai++40^999")

            hook.Remove("StartCommand", "impending_doom")
        end)
    end,

    [2] = function()
        RunConsoleCommand("saysound", "i love you#2") 
        RunConsoleCommand("taunt", "IHeartYou")
    end,

    [3] = function()
        RunConsoleCommand("actx", "disagree")
        RunConsoleCommand("saysound", "you are horny")
    end,

    [4] = function(tp)
        local amt = math.random(1, 10000)
        SayLocal(":heart:")
        SayLocal(string.format("!givecoins %s, %s", tp:GetName(), amt))
    end,

    [5] = function()
        RunConsoleCommand("actx", "disagree")
        RunConsoleCommand("saysound", "nono")
    end,

    [6] = function()
        RunConsoleCommand("aowl", "killx", "1")
        RunConsoleCommand("saysound", "kani:echo()^500")
        
        timer.Simple(4, function()
            RunConsoleCommand("aowl", "revive")
            RunConsoleCommand("saysound", "oh my gah#2")
        end)
    end,

    [7] = function(tp)
        hook.Add("StartCommand", "impending_doom", function(ply, cmd)
            local tgtAng = (tp:GetShootPos() - ply:GetShootPos()):GetNormalized():Angle()

            cmd:SetViewAngles(tgtAng)
        end)

        RunConsoleCommand("taunt", "blow_kiss")
        RunConsoleCommand("saysound", "elmo kiss")

        timer.Simple(3, function() 
            hook.Remove("StartCommand", "impending_doom")
        end)
    end,
    [7] = function(tp)
        local amt = math.random(1, 100000)
        SayLocal(":heart:")
        SayLocal(string.format("!givecoins %s, %s", tp:GetName(), amt))
    end
}

interactions.interact = function(tp, isPlySpecial)
    local rnd = math.random(#interactions)
    local res = interactions[rnd]

    if isPlySpecial then
        while rnd % 2 ~= 0 do
            rnd = math.random(#interactions)
            res = interactions[rnd]
        end
    end

    res(tp)
end