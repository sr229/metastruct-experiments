
say("[Luadev/follow] Disengaging autopilot")

hook.Remove("Think", "henkers")
hook.Remove("StartCommand", "autopilot")