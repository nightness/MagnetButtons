local addonName, addon = ...
local _G = _G

--[[

    There are two timers here, the quick timer that runs ever 0.05 seconds, and the slow timer that runs every 0.5 seconds.
    Each timer also calls a button specific local function for all buttons

]]--

local function quickTickerOnButton(self, ...)
	local altDown = IsAltKeyDown();
	local shiftDown = IsShiftKeyDown();
	local ctrlDown  = IsControlKeyDown();
	if (shiftDown and ctrlDown and addon.IsBlockMoving()) then
		SetCursor("Interface/CURSOR/openhandglow");
		return;
	end

	-- Change Cursor for when ctrl or shift are pressed
	if (self.HasCursor == true) and (not CursorHasItem()) and (not CursorHasMacro()) and (not CursorHasMoney()) and (not CursorHasSpell()) then
		local inCombat = (UnitAffectingCombat("player") or InCombatLockdown());
		local shiftCursor = (shiftDown and (not ctrlDown) and (not altDown) and (not inCombat));
		local controlCursor = (ctrlDown and (not shiftDown) and (not altDown) and (not inCombat));
		local blockMoveCursor = (ctrlDown and shiftDown and (not altDown) and (not inCombat));
		if ((not shiftCursor) and (not controlCursor) and (not blockMoveCursor) and (not self.HasNormalCursor)) then
			self.HasNormalCursor = true;
			self.HasShiftCursor = false;
			self.HasControlCursor = false;
			self.HasBlockMoveCursor = false;
			addon.ClearBlockSelection(self);
			ResetCursor();
		elseif (blockMoveCursor and (not self.HasBlockMoveCursor)) then
			self.HasNormalCursor = false;
			self.HasShiftCursor = false;
			self.HasControlCursor = false;
			self.HasBlockMoveCursor = true;
			-- Builds a selection set
			addon.SetBlockSelection(self);			
			-- Sets the cursor
			SetCursor("Interface/CURSOR/openhandglow");
		elseif (controlCursor and (not self.HasControlCursor)) then
			self.HasNormalCursor = false;
			self.HasShiftCursor = false;
			self.HasBlockMoveCursor = false;
			self.HasControlCursor = true;
			addon.ClearBlockSelection(self);
			SetCursor("INSPECT_CURSOR");
		elseif (shiftCursor and (not self.HasShiftCursor)) then
			self.HasNormalCursor = false;
			self.HasControlCursor = false;
			self.HasBlockMoveCursor = false;
	        self.HasShiftCursor = true;
			addon.ClearBlockSelection(self);
			SetCursor("ITEM_CURSOR");
		end
	end
end

-- The quick timer (every 0.05 seconds)
addon.QuickTicker = DoIt.Ticker.new(0.05, nil, function ()
	-- Simulated "event" that watches for cursor pick-ups
	local type = GetCursorInfo();
	local shiftDown = IsShiftKeyDown();
	local supportedType = (type == "spell" or type == "item" or type == "petaction" or type == "macro" or type == "flyout" or type == "mount");
	if (shiftDown and supportedType and not MagnetButtonsDropTarget:IsShown()) then
		-- Cursor Pickup
		MagnetButtonsDropTarget:Show();
	elseif ((type == nil or not shiftDown) and MagnetButtonsDropTarget:IsShown()) then
		-- Cursor Drop
		addon.DraggingPetSpellIndex = nil;
		MagnetButtonsDropTarget:Hide();
	end

    -- This is the button specific quick ticker
	addon.ForEachButton(quickTickerOnButton);
end);
addon.QuickTicker:start() -- Start and never end

addon.DisplayedAllyFrames = Classy.Observable.new(GetDisplayedAllyFrames());
addon.DisplayedAllyFrames:subscribe(function (frameSystem)
	addon.ForEachButton(function (button, ...)
		local unit = addon.GetUnit(button)
		if (unit ~= nil) then
			if (type(unit) == "string") then
				if (frameSystem == "party" and starts_with(unit, "party")) then
					DoIt.Debug("Change to Party... MagnetButtonFrame"..tostring(index))
				elseif (frameSystem == "raid" and starts_with(unit, "raid")) then
					DoIt.Debug("Change to Raid... MagnetButtonFrame"..tostring(index))					
				end
			end				
		end
	end)
end)

-- Slow timer (every 0.5 seconds) for each button
local function slowTickerOnButton(self, ...)
	-- Add tooltips for macros and updates cooldown times in tooltips
	addon.DisplayTooltip(self);

	-- Hide/Show Pet Buttons when appropate
	local parentFrame = self:GetParent();
	if (addon.IsPetAction(self)) and (PetHasActionBar() and UnitIsVisible("pet")) then
		if (not parentFrame:IsShown()) then
			parentFrame:Show();
		end
	elseif (addon.IsPetAction(self)) then
		if (parentFrame:IsShown()) then
			parentFrame:Hide();
		end	
	end

	addon.UpdateState(self);
	addon.UpdateUsable(self);
	addon.UpdateCooldown(self);
	addon.UpdateVisibility(self);
end

-- The slow timer (every 0.5 seconds)
addon.SlowTicker = DoIt.Ticker.new(0.5, nil, function ()
	-- Watches for changes to the GetDisplayedAllyFrames() returned value (addon.DisplayedAllyFrames is an Observable)
	addon.DisplayedAllyFrames:set(GetDisplayedAllyFrames())

	-- Manage hot key bindings on a Vehicle (retail)
	local inVehicle = DoIt.PlayerInVehicle();
	if (addon.IsInVehicle ~= inVehicle) then
		addon.IsInVehicle = inVehicle;
		if (addon.IsInVehicle) then
			addon.DisableHotKeysBindings();
		else
			addon.EnableHotKeysBindings();
		end
	end

	-- Simulate events for when the flyout bar is hidden or shown (retail)
	if (SpellFlyout) then
		if (not isFlyoutBeingShown and SpellFlyout:IsShown()) then
			isFlyoutBeingShown = true;
			addon.OnFlyoutShow();
		elseif (isFlyoutBeingShown and not SpellFlyout:IsShown()) then
			isFlyoutBeingShown = false;
			addon.OnFlyoutHide();
		end
	end

    -- This is the button specific slow ticker
	addon.ForEachButton(slowTickerOnButton);
end);
addon.SlowTicker:start() -- Start and never end
