
if _G.dhooks then return end

_G.dhooks = {}

local vaporize = {
	["CalcMainActivity"] = {
		"prone.Animations",
		"simfphysSeatActivityOverride",
	},
	["CalcView"] = {
		"Fishingmod:CalcView",
		"XMV_CalcView",
		"NewShuttleCalcView",
	},
	["CreateMove"] = {
		"arcade_cabinet_scroll",
	},
	["ChatText"] = {
		"vrutil_hook_chattext",
	},
	["DrawPhysgunBeam"] = {
		"physparent_drawphysgunbeam",
		"pac_physgun_event",
	},
	["EntityEmitSound"] = {
		"mta",
	},
	["HUDDrawTargetID"] = {
		"arcade_no_targetid",
	},
	["HUDPaint"] = {
		"mining_rig_automation_graph_hud",
		"mining_automation_entity_info",
		"simfphys_crosshair",
		"RotdampWorldTip",
		"HealthWorldTip",
		"paradeploy",
		"Fishingmod:HUDPaint",
		"InstrumentPaint",
		"Radial.DrawRadialMenu",
		"NewShuttleDrawInfoOverlay",
		"wire_gpu_drawhud",
		"PP_SurfaceBlur",
		"EasyChatModulePMBadge",
		"soccer",
		"mta_pickpocket",
		"trashscav",
		"SoccerHud",
		"raffler",
		"mta_vault",
		"tremble",
		"blindeffect",
		"arcade_hud",
		"XMVDrawHUD",
		"Hoverboard_HUDPaint",
		"mta_bounties",
		"ms.Coins",
		"showValuesFinHUD",
		"wish_fountain",
		--"wire_draw_world_tips",
		"fairy_chatboxes",
		"simfphys_vehicleditorinfo",
		"mta_balancing",
		"debugutils_HUDPaint",
		"mta_fever",
		"meta_custom_taunts",
		"FishingModHooks",
		"targetgame",
		"EGP_HUDPaint",
		"prop_owner",
		--"mta",
		"spddampWorldTip",
		"DebuggerDrawHUD",
		"pac_pac_show_render_times",
		"simfphys_HUD",
		"oxygen_hud",
		"EasyChatBlur",
		"mta_mug",
		"aliens",
		"heybanni",
		"pac_in_editor",
		"CakeHUD",
		"meta_ai",
	},
	["HUDShouldDraw"] = {
		"tobecontinued",
		"RagdollFightHUDShouldDraw",
		"hide_hl2_crosshair",
		"CatmullRomCams.CL.HUDHide",
		"CakeHUD",
		"mta_riot_shield",
		"XMV_HUDShouldDraw",
		"mta",
		"tremble",
		"HideHUD",
	},
	["NetworkEntityCreated"] = {
		"mining_rig_automation_graph_hud",
	},
	["OnEntityCreated"] = {
		"mining_rig_automation_graph_hud",
	},
	["OnPlayerChat"] = {
		"steam_blocked",
	},
	["PostDraw2DSkyBox"] = {
		"skyboxer",
		"StyloSilo_skybox_rocket",
	},
	["PostDrawHUD"] = {
		"dond_host",
		"dond_notify",
		"trackassembly_physgun_drop_draw",
		"trackassembly_radial_menu_draw",
		"DrawEZDoorName",
	},
	["PostDrawOpaqueRenderables"] = {
		"PropellerEngine:PostDrawOpaqueRenderables",
		"WireMapInterface_Draw",
		"tanktracktoolRenderDraw",
		"ACF_RenderDamage",
	},
	["PostDrawTranslucentRenderables"] = {
		"stacker_improved_directions",
		"simfphys_draw_sprites",
		"custom_taunts_indicator",
		"DrawJumppadLAndingPos",
		"avr_drawplayerlasers",
		"OptiWeldShowContraints",
		"JGHUD",
		"weapon_lawp",
		"NightclubLightsRenderFix",
		"Decent Vehicle: Draw waypoints",
		"3dsmileys",
		"EasyChatModuleVoiceHUD",
		"tg_ent_postdraw",
		"dond_rt",
	},
	["PreDrawOpaqueRenderables"] = {
		"meta_custom_taunts",
	},
	["PrePlayerDraw"] = {
		"VoiceRing",
		"PropellerEngine:PrePlayerDraw",
		"arcade_cabinet_hideplayers",
		"mount_base",
		"lay_down_anim",
		"_dont_draw",
		"outfitter_tttfix",
	},
	["PreDrawHalos"] = {
		"stacker_improved_predrawhalos",
	},
	["RenderScene"] = {
		"WorldPortals_Render",
		"attach_ragdoll_think",
		"RenderStereoscopy",
		"RenderStereoscopyMirror",
		"RenderSuperDoF",
	},
	["RenderScreenspaceEffects"] = {
		"RenderToyTown",
		"RenderBokeh",
		"beer.RenderScreenspaceEffects",
		"Scare System",
		"weapon_squirtbottle",
		"swcs.flashbang",
		"tobecontinued",
		"RenderColorModify",
		"RenderMaterialOverlay",
		"Club",
		"RenderSharpen",
		"RenderSunbeams",
		"Fireworks.RenderScreenspaceEffects",
		"weapon_lawp",
		"RenderTexturize",
		"CatmullRomCams.CL.BlackenScreenDuringTunneling",
		"RenderSobel",
		"RadiationEffects",
		"DrawMorph",
		"RenderBloom",
		"rb655_rendervollight",
		"RenderMotionBlur",
		"tremble",
		"rb655_renderlight",
		"tod_pp",
		"fairy_sunbeams",
	},
	["PostPlayerDraw"] = {
		"soccer",
	},
	["PlayerBindPress"] = {
		"trackassembly_player_bind_press",
	},
	["PlayerNoClip"] = {
		"ACtrl"
	},
	["PlayerStartVoice"] = {
		"chatsounds_voicemute",
	},
	["ShouldDrawLocalPlayer"] = {
		"Fishingmod:ShouldDrawLocalPlayer",
		"Scare System",
		"SoccerView",
		"hoverboards_draw",
	},
	["SToolDecal"] = {
		"SToolDecal",
	},
	["Think"] = {
		"Fishingmod.Keys:Think",
		"trashscav",
		"CakeHUD",
		"steam_blocked",
		"DOFThink",
		"XMV_CAR_Think",
		"arcade_cabinet_think",
		"simfphys_lights_managment",
		"NightclubDancers",
		"trashscav",
		"Radial.CaptureMouseClicks",
		"mining_blood_ore_flesh_world_state",
		"Scare System",
		"roommusic",
		"trackassembly_update_ghosts",
	},
	["Tick"] = {
		"Fishingmod.CleanInfo:Tick",
		"RadiationNoise",
		"chatsounds_voicemute",
	},
	["UpdateAnimation"] = {
		"simfphysPoseparameters",
		"Hoverboard_UpdateAnimation",
		"swcs.ply_anim",
		"PropellerEngine:UpdateAnimation",
	},
}

hook.Disable = function(group, name)
	if not _G.dhooks then return print("dhooks doesnt exist? but how") end

	if not group then return print("Group not specified") end
	if not _G.dhooks[group] then
		_G.dhooks[group] = {}
		print("Group does not exist. Creating new one")
	end

	if not name then return print("Name not specified") end
	if _G.dhooks[group][name] then
		return print("Hook with the same name already disabled")
	end
	
	_G.dhooks[group][name] = hooks[group][name]
	hooks[group][name] = nil
	print("Disabling", group, name)
end

hook.Enable = function(group, name)
	if not _G.dhooks then return print("dhooks doesnt exist? but how") end

	if not group then return print("Group not specified") end
	if not _G.dhooks[group] or _G.dhooks[group] == {} then
		return print("Group does not exist. Are you sure any hook exists in there?")
	end

	if not name then return print("Name not specified") end
	if not _G.dhooks[group][name] then
		return print("Hook with specified name does not exist")
	end
	
	hooks[group][name] = _G.dhooks[group][name]
	_G.dhooks[group][name] = nil
	print("Enabling", group, name)
end

for hook_group, funcs in pairs(vaporize) do
	for _, func in pairs(funcs) do
		hook.Disable(hook_group, func)
	end
end