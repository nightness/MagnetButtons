local addonName, addon = ...
local _G = _G

-- This function is first function called when everything is initialized and ready to go.
function addon.Startup()
	DoIt.Debug("Welcome to MagnetButtons "..tostring(DoIt.GetFullPlayerName())..".");
	if (DoIt.IsClassic) then
		DoIt.Debug("Notice: MagnetButtons is running in classic mode");
	end
end

--
-- This is the main start-up script, it's a one-shot, it executes itself then unsubscribes the event.
--
local startupScript = function (self, event, arg1, arg2)
	DoIt.Events:unsubscribe("PLAYER_LOGIN", startupScript);
	addon.Startup();
	addon.verifyGlobalButtonSettings()
	-- Loop through each saved button, create, and display
	for index,attributes in ipairs(MagnetButtons_ButtonData) do
		addon.MakeButton(index, attributes);
	end
	addon.OnPlayerZoneChange();
end
DoIt.Events:subscribe("PLAYER_LOGIN", startupScript);

-- Zone Changed event handling
addon.OnPlayerZoneChange = function ()
	local zone, area, world, zoneType, isManaged = DoIt.GetPlayerInfo();
	local isEnabled, inDungeon, inRaid, inArena, inBattleground = addon.GetDesignMode();
	local isControlled1 = UnitPlayerControlled("player")
	local isControlled2 = not HasFullControl();
	local inWorld = true;
	
	--DoIt.Debug("OnPlayerZoneChange: "..tostring(zone)..", "..tostring(area)..", "..tostring(world)..", "..tostring(zoneType)..", "..tostring(isManaged)..", LOC1 = "..tostring(isControlled1)..", LOC2 = "..tostring(isControlled2));

	addon.ForEachButton(function (button, ...)
		local parent = button:GetParent();
		local buttonType = button:GetAttribute("type")
		local buttonZoneType = button:GetAttribute("zoneType");
		if (butonType and buttonType ~= "") then
			-- Is DesignMode enabled?
			if (isEnabled) then
				--DoIt.Debug("InDesign Mode")
				local show = (buttonZoneType == nil or (buttonZoneType == "world" and inWorld));
				show = (show or (buttonZoneType == "dungeon" and inDungeon));
				show = (show or (buttonZoneType == "raid" and inRaid));
				show = (show or (buttonZoneType == "arena" and inArena));
				if (show) then
					parent:Show()
				else
					parent:Hide()
				end				
			else 	 		
				--DoIt.Debug("NOT InDesign Mode")
				if (buttonZoneType == nil or zoneType == buttonZoneType) then
					parent:Show()
				else
					parent:Hide()
				end
			end
		end
	end)
end
DoIt.Events.onZoneChanged:subscribe(function ()
	addon.OnPlayerZoneChange();
end)
