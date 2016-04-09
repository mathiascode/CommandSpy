-- Creates a temporary list that contains UUIDs of players with CommandSpy enabled. Resets after a reload or restart.
CommandSpyList = {}

-- Code required to initialize the plugin
function Initialize(Plugin)
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")

	-- Sets the name and version of the plugin
	Plugin:SetName(g_PluginInfo.Name)
	Plugin:SetVersion(g_PluginInfo.Version)

	-- Hook required for capturing commands
	cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND, OnExecuteCommand)

	-- Registers the commands found in Info.lua
	RegisterPluginInfoCommands()

	-- Shows up in console
	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end

-- Code that handles the main command for enabling/disabling CommandSpy
function HandleCommandSpyCommand(Split, Player)
	-- If command contains "on", enable CommandSpy for player
	if Split[2] == "on" then
		-- Add UUID of player to list of players with CommandSpy enabled
		CommandSpyList[Player:GetUUID()] = true
		Player:SendMessageSuccess("Successfully enabled CommandSpy")
		return true
	end
	-- If command contains "off", disable CommandSpy for player
	if Split[2] == "off" then
		-- Remove UUID of player from list of players with CommandSpy enabled
		CommandSpyList[Player:GetUUID()] = nil
		Player:SendMessageSuccess("Successfully disabled CommandSpy")		
		return true
	end

	-- If command doesn't contain "on" or "off", display command usage information
	Player:SendMessageInfo("Usage: " .. Split[1] .. " <on|off>")
	return true
end

-- Code that catches commands executed by players
function OnExecuteCommand(Player, CommandSplit, EntireCommand)
	-- Adds a function that displays commands in chat for players with CommandSpy enabled
	local DisplayCommand = function(OtherPlayer)
		-- If player is in list of players with CommandSpy enabled
		if CommandSpyList[OtherPlayer:GetUUID()] ~= nil then
			-- Go ahead, but check if a player executed a command instead of console
			if Player then
				-- A player executed a command, but check if that player has CommandSpy enabled or not
				if CommandSpyList[Player:GetUUID()] ~= nil then
					-- It's enabled, make the command output in chat yellow
					OtherPlayer:SendMessage(cChatColor.Yellow .. Player:GetName() .. cChatColor.Yellow .. ": " .. EntireCommand)
				else
					-- It's disabled, make the command output in chat blue
					OtherPlayer:SendMessage(cChatColor.LightBlue .. Player:GetName() .. cChatColor.LightBlue .. ": " .. EntireCommand)
				end
			-- A player didn't execute the command, then the console or a command block must have executed it
			else
				-- The command output in chat is purple in that case
				OtherPlayer:SendMessage(cChatColor.Purple .. "Console/Command Block: " .. EntireCommand)
			end
		end
	end
	-- Executes the function above whenever someone executes a command on the Server
	cRoot:Get():ForEachPlayer(DisplayCommand)
end

-- Shows up in console
function OnDisable()
	LOG("CommandSpy is shutting down...")
end
