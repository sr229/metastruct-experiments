-- Code by Henke and Minori
-- to remove the hook please run
-- hook.Remove("StartCommand", "autopilot")

local target = eno

say("[luadev/Autopilot] Now following " .. tostring(target))


hook.Add("StartCommand", "heatseekingminori", function(ply, cmd)
	if ply ~= LocalPlayer() then return end
	if not target:Alive() then return end
	if target:GetPos():Distance(ply:GetPos()) < 128 then
		return
	end
	
	
	
	-- we wanna run if our target is greater than 512 units
	-- that way we can still catch up
	if target:GetPos():Distance(ply:GetPos()) > 512 then
		cmd:AddKey(IN_SPEED)
		cmd:SetForwardMove(ply:GetRunSpeed())
	else 
	    cmd:SetForwardMove(ply:GetWalkSpeed())
	end		

	local ang = cmd:GetViewAngles()
	local targetAngle = (target:GetShootPos() - ply:GetShootPos()):GetNormalized():Angle()
	targetAngle = LerpAngle(0.1, ang, targetAngle)

	cmd:SetViewAngles(targetAngle)
end)