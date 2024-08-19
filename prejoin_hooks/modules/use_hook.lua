include("metastruct_specific/util/use_hook_randomiser.lua")
include("metastruct_specific/util/tbl_utils.lua")

local lastTime = 0
local pokeCount = 0
local SPECIAL_UIDS = { 195868133, 48693720 }
local INPUT_COOLDOWN = false

hook.Add("PlayerUsedByPlayer", "touched", function(target, aimer)
	if lastTime + 0.1 > CurTime() or INPUT_COOLDOWN then return end
	lastTime= CurTime()
	
	if pokeCount == 40 then
		pokeCount = 0
		INPUT_COOLDOWN = true
		print(string.format("%s triggered the limit!", aimer))
		
		-- check if player is in the UID list
		if tbl_utils.contains(SPECIAL_UIDS, aimer:AccountID()) then
			interactions.interact(aimer, true)
			
			timer.Simple(4, function()
				INPUT_COOLDOWN = false
			end)
		else
			interactions.interact(aimer, false)

			timer.Simple(4, function()
				INPUT_COOLDOWN = false
			end)
		end
	else
		pokeCount = pokeCount + 1
		RunConsoleCommand("actx", "poke")
		
		if tbl_utils.contains(SPECIAL_UIDS, aimer:AccountID()) then
			RunConsoleCommand("saysound", "hi honey++29")
		else
			RunConsoleCommand("saysound", "hi honey#1--25 hi honey#1++75:pitch(-1)")
		end
	end
end)