-- Creates a temporary list that contains UUIDs of players with CommandSpy enabled. Resets after a reload or restart.
CommandSpyList = {}

function Initialize(Plugin)
	Plugin:SetName(g_PluginInfo.Name)
	Plugin:SetVersion(g_PluginInfo.Version)

	cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND, OnExecuteCommand)

	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	RegisterPluginInfoCommands()

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end

function HandleCommandSpyCommand(Split, Player)
	if Split[2] == "on" then
		-- Add UUID of player to list of players with CommandSpy enabled
		CommandSpyList[Player:GetUUID()] = true
		Player:SendMessageSuccess("Successfully enabled CommandSpy")
	elseif Split[2] == "off" then
		-- Remove UUID of player from list of players with CommandSpy enabled
		CommandSpyList[Player:GetUUID()] = nil
		Player:SendMessageSuccess("Successfully disabled CommandSpy")		
	else
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <on|off>")
	end
	return true
end

function OnExecuteCommand(Player, CommandSplit, EntireCommand)
	local DisplayCommand = function(OtherPlayer)
		if CommandSpyList[OtherPlayer:GetUUID()] ~= nil then
			if Player then
				if CommandSpyList[Player:GetUUID()] ~= nil then
					OtherPlayer:SendMessage(cChatColor.Yellow .. Player:GetName() .. cChatColor.Yellow .. ": " .. EntireCommand)
				else
					OtherPlayer:SendMessage(cChatColor.LightBlue .. Player:GetName() .. cChatColor.LightBlue .. ": " .. EntireCommand)
				end
			-- A player didn't execute the command, then the console or a command block must have executed it
			else
				OtherPlayer:SendMessage(cChatColor.Purple .. "Console/Command Block: " .. EntireCommand)
			end
		end
	end
	cRoot:Get():ForEachPlayer(DisplayCommand)
end

function OnDisable()
	LOG("Disabled " .. cPluginManager:GetCurrentPlugin():GetName() .. "!")
end
