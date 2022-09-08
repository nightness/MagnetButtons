local addonName, addon = ...
local _G = _G

function addon.IsCompanion(self)
	return (addon.GetCompanion(self) ~= nil);
end

-- macrotext, starts with /use and is followed by the name of a toy
function addon.IsToy(self)
	if (DoIt.IsClassic) then
		return false;
	end
	local t = self:GetAttribute("type");
	local val = self:GetAttribute("macrotext");
	if (t ~= "macro") then return false end
	if (val and string.sub(val, 1, 4) == "/use") then
		local toyCount = C_ToyBox.GetNumToys();
		local what = string.sub(val, 5); 
		for idx = 1, toyCount, 1 do
			local toyId = C_ToyBox.GetToyFromIndex(idx)
			local itemId, toyName, icon, isFavorite, hasFanfare, itemQuality = C_ToyBox.GetToyInfo(toyId)
			if (toyName ~= nil) then
				local a = string.match(toyName, what);
				local b = string.match(what, toyName);
				if (a or b) then
					return true;
				end
			end
		end
	end
end

-- macrotext, starts with /use and is followed by the name of a toy
function addon.GetToyId(self)
	local t = self:GetAttribute("type");
	local val = self:GetAttribute("macrotext");
	if (t ~= "macro") then return false end
	if (val and string.sub(val, 1, 4) == "/use") then
		local toyCount = C_ToyBox.GetNumToys();
		local what = string.sub(val, 5); 
		for idx = 1, toyCount, 1 do
			local toyId = C_ToyBox.GetToyFromIndex(idx)
			local itemId, toyName, icon, isFavorite, hasFanfare, itemQuality = C_ToyBox.GetToyInfo(toyId)
			if (toyName ~= nil) then
				local a = string.match(toyName, what);
				local b = string.match(what, toyName);
				if (a or b) then
					return toyId;
				end
			end
		end
	end
end

function addon.IsSpell(self)
	return (addon.GetSpellValue(self) ~= nil);
end

function addon.IsItem(self)
	return (addon.GetItemName(self) ~= nil);
end

function addon.IsPetAction(self)
	return (addon.GetPetAction(self) ~= nil);
end

function addon.IsMacro(self)
	return (addon.GetMacroName(self) ~= nil);
end

function addon.IsFlyout(self)
	return (addon.GetFlyout(self) ~= nil);
end

function addon.IsWorldMarker(self)
	return (addon.GetMarker(self) ~= nil);
end

function addon.IsMacroText(self)
	return (addon.GetMacroText(self) ~= nil);
end

function addon.GetMarker(self)
	if (self:GetAttribute("type") == "worldmarker") then
		return self:GetAttribute("marker") or 1;
	end
end

function addon.GetFlyout(self)
	if (self:GetAttribute("type") == "flyout") then
		return self:GetAttribute("spell");
	end
end

function addon.GetType(self)
	return self:GetAttribute("type");
end

function addon.GetCompanion(self)
	return self:GetAttribute("value1"), self:GetAttribute("value2");
end

function addon.GetSpellValue(self)
	--if (self:GetAttribute("type") == "spell") then
		return self:GetAttribute("spell");
	--end
end

function addon.GetItemName(self)
	return self:GetAttribute("item");
end

function addon.GetPetAction(self)
	if (self:GetAttribute("macrotext") ~= nil) then
		return self:GetAttribute("action");
	end
end

function addon.GetMacroName(self)
	return self:GetAttribute("macro");
end

function addon.GetMacroText(self)
	return self:GetAttribute("macrotext");
end

function addon.GetTooltip(self)
	return self:GetAttribute("tooltip");
end

function addon.GetSpell(self)
	return self:GetAttribute("spell");
end

function addon.GetUnit(self)
	return self:GetAttribute("unit");
end

function addon.GetIcon(self)
	return getglobal(self:GetName().."Icon");
end

--[[
function addon.SetDisabled(self, disabled)
	if (disabled) then
		icon:SetAlpha(0.5);		
	else
		icon:SetAlpha(1.0);	
	end
end
]]--

function addon.GetIsUsableAttributes(self)
	return self:GetAttribute("isusable-spell"), self:GetAttribute("isusable-item");
end

function addon.IsUsable(self)
	return self.IsUsable
end

function addon.SetUsable(self, isUsable, notEnoughMana)
	local name = self:GetName();
	local icon = getglobal(name.."Icon");
	local normalTexture = getglobal(name.."NormalTexture");
	local parent = self:GetParent();
	-- icon:SetDesaturated(false);

	if (UnitOnTaxi("player") or UnitIsDeadOrGhost("player")) then
		parent:SetAlpha(0.25);	
	else
		parent:SetAlpha(1);
	end
		
	if (isUsable) and (not self.IsUsable) then
		--DoIt.Debug("MagnetButton: Button is now usable");
		self.IsUsable = true;
		if (self:GetParent():IsShown()) then
			icon:SetVertexColor(1.0, 1.0, 1.0);
			if (normalTexture) then
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			end
		end
	elseif (notEnoughMana) and (self.IsUsable) then
		--DoIt.Debug("MagnetButton: Button is now unusable, not enough mana");
		self.IsUsable = false;
		if (self:GetParent():IsShown()) then
			icon:SetVertexColor(0.5, 0.5, 1.0);
			if (normalTexture) then
				normalTexture:SetVertexColor(0.5, 0.5, 1.0);
			end
		end
	elseif (not isUsable) and (self.IsUsable) then
		--DoIt.Debug("MagnetButton: Button is now unusable");
		self.IsUsable = false;
		if (self:GetParent():IsShown()) then
			icon:SetVertexColor(0.4, 0.4, 0.4);
			if (normalTexture) then
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			end
		end
	end
end

function addon.FindCompanionByName(name)	
	local mountCount = GetNumCompanions("MOUNT")
	for idx = 1, mountCount, 1 do
		local creatureID, creatureName, creatureSpellID, icon, issummoned, mountTypeID = GetCompanionInfo("MOUNT", idx)
		if (name == creatureName) then
			return "MOUNT", idx;
		end
	end
	local critterCount = GetNumCompanions("CRITTER")
	for idx = 1, critterCount, 1 do
		local creatureID, creatureName, creatureSpellID, icon, issummoned, mountTypeID = GetCompanionInfo("CRITTER", idx)
		if (name == creatureName) then
			return "CRITTER", idx;
		end
	end
end


function addon.FindCompanion(companionType, name)	
	local mountCount = GetNumCompanions(companionType)
	DoIt.Echo("FindCompanion: " .. companionType .. " " .. name .. " " .. mountCount);
	for idx = 1, mountCount, 1 do
		local creatureID, creatureName, creatureSpellID, icon, issummoned, mountTypeID = GetCompanionInfo(companionType, idx)
		if (name == creatureName) then
			return idx;
		end
	end
end

function IsUsableCompanion(self, value1, value2)
	if (value1 == "MOUNT") then
		return ((not InCombatLockdown()) and (not IsIndoors()));
	end
	return true;
end

function addon.CompanionClickHandler(self)
	-- This calls or dismisses a companion
	if (self:GetAttribute("type") == "companion") then
		local spell = self:GetAttribute("spell");
		-- local type = self:GetAttribute("type"); -- companion
		local value1 = self:GetAttribute("value1");
		local value2 = self:GetAttribute("value2");
		-- DoIt.Echo("CompanionClickHandler: "..companionType.." "..id);
		if (value1 ~= nil) then
			value1, value2 = addon.FindCompanionByName(spell);
			self:SetAttribute("value1", value1);
			self:SetAttribute("value2", value2);
		end

		local id = addon.FindCompanion(value1, spell);
		if (value2 ~= id) then
			value2 = id;
			self:SetAttribute("value2", id);
		end

		-- DoIt.Echo("Call companion: "..value1..", "..value2);
		if (DoIt.Player.hasAura(spell)) then
			DismissCompanion(value1, value2);
			-- DismissCompanion(companionType, id);
		else
			-- DoIt.Echo("Calling companion: "..spell);
			CallCompanion(value1, value2);
			-- CallCompanion(companionType, id);
		end
	end	
end

function addon.ForEachButton(func, ...)
	-- Loop though all buttons
	for index = 1, addon.MaxFrameIndex do
		local parent = getglobal("MagnetButtonFrame"..tostring(index));
		if (parent ~= nil) then
			local frameName = parent:GetName() .. "CheckButton";
			local frame = getglobal(frameName);
			if (frame) then
				func(frame, ...);
			end
		end
	end
end

function addon.GetOtherFrameLocations(self)
	local myTable = { };
	local trueIndex = 1;
	for index = 1, addon.MaxFrameIndex do
		local frameName = "MagnetButtonFrame"..tostring(index);
		local f = getglobal(frameName);
		if (f ~= nil) and (f:IsShown()) and (f ~= self:GetParent()) then
			myTable[trueIndex] = { };
			myTable[trueIndex]["name"] = frameName;
			myTable[trueIndex]["rect"] = Rectangle.CreateFromFrame(f);
			trueIndex = trueIndex + 1;
		end
	end
	return myTable;
end

--[[

Button Visibility Management - Smart handling of buttons with unit property specified, where the unit is either party, raid, or arena
	* Raid Buttons for example, unit = "raid1"
		* If not in raid, button is 25% Alpha; UNLESS a global option to hide in this case instead
		* If in raid and target doesn't exist, then hide the button




]]--
