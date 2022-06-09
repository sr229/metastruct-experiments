-- Code by Henke and Minori
-- to remove the hook please run
-- hook.Remove("StartCommand", "autopilot")

local target = puh
SHOULD_NOCLIP = false

say("[Luadev/follow] Now following", tostring(target))

hook.Add("StartCommand", "autopilot", function(ply, cmd)
	if ply ~= LocalPlayer() then return end
	if not target:Alive() then return end
	if target:GetPos():Distance(ply:GetPos()) < 128 then
		return
	end

	-- we wanna run if our target is greater than 256 units
	-- that way we can still catch up
	if target:GetPos():Distance(ply:GetPos()) > 256 then
		cmd:AddKey(IN_SPEED)
		cmd:SetForwardMove(ply:GetRunSpeed())
	else
	    cmd:SetForwardMove(ply:GetWalkSpeed())
	end

	-- if farther than 512 units away, noclip
	if target:GetPos():Distance(ply:GetPos()) > 512 then
		SHOULD_NOCLIP = true
		RunConsoleCommand("noclip")
		cmd:AddKey(IN_SPEED)
		cmd:SetForwardMove(ply:GetRunSpeed())
	end


	local ang = cmd:GetViewAngles()
	local targetAngle = (target:GetShootPos() - ply:GetShootPos()):GetNormalized():Angle()
	targetAngle = LerpAngle(0.1, ang, targetAngle)

	cmd:SetViewAngles(targetAngle)
end)

hook.Add("Think", "henkers", function()
	if SHOULD_NOCLIP and target:GetPos():Distance(LocalPlayer():GetPos()) < 512 then
		SHOULD_NOCLIP = false
		RunConsoleCommand("noclip")
	end
end)