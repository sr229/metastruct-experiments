-- Code by Henke and Minori
-- to remove the hook please run
-- hook.Remove("StartCommand", "heatseekingminori")

local target = razz

print("[luadev/Autopilot] Now following " .. tostring(target))


hook.Add("StartCommand", "heatseekingminori", function(ply, cmd)
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

	-- if father than 512 units away, noclip
	if target:GetPos():Distance(ply:GetPos()) > 512 then
		ply:ConCommand("noclip")
		cmd:AddKey(IN_SPEED)
		cmd:SetForwardMove(ply:GetRunSpeed())
	else
	    cmd:SetForwardMove(ply:GetWalkSpeed())
	end

	-- This is too far now, we need to TP at this rate.
	if target:GetPos():Distance(ply:GetPos()) > 2048 then
		RunConsoleCommand("aowl", "tp ", target:Name())
	end

	local ang = cmd:GetViewAngles()
	local targetAngle = (target:GetShootPos() - ply:GetShootPos()):GetNormalized():Angle()
	targetAngle = LerpAngle(0.1, ang, targetAngle)

	cmd:SetViewAngles(targetAngle)
end)