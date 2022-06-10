
say("[Luadev/follow] Disengaging autopilot")

hook.Remove("Think", "noclip_think")
hook.Remove("StartCommand", "autopilot")