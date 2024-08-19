-- original code by Aoki (@aoki.me)

local prefixes = {
    '/',
    '!',
    '.',
}

hook.Add( 'OnPlayerChat', 'pickuper', function( ply, message )
    local usedPrefix = nil

    for _, prefix in ipairs( prefixes ) do
        if string.StartWith( message, prefix ) then
            usedPrefix = prefix
            break
        end
    end

    if !usedPrefix then return end
    local args = string.Explode( '%s+', string.sub( message, #usedPrefix + 1 ):lower(), true )

    if args[1] == 'pickup' then
		local target = easylua.FindEntity( args[2] )

		if target != LocalPlayer() then return end
		if !LocalPlayer():IsFriend( ply ) then return end

		RunConsoleCommand( 'aowl', 'goto', ply:SteamID64() )
		RunConsoleCommand( 'aowl', 'siton', ply:SteamID64() )
	end
end)