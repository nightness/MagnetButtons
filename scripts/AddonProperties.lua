local addonName, addon = ...
local _G = _G

function addon.ShowProps(self)
	if (MagnetButtonProperties:IsShown()) then
		MagnetButtonProperties.button:Enable();
	end
 	self:Disable();
	MagnetButtonProperties.button = self;
	addon.LoadProperties(self);
	MagnetButtonProperties:Show();
	local icon = getglobal(self:GetName().."Icon");
	local texture = icon:GetTexture();
	MagnetButtonProperties:SetClampedToScreen(true);
end

-- Init for the button that the mouse is hovering over (on click)
function addon.Props_OnShow(self)
	DoIt.Debug("Displaying properties for button "..MagnetButtonProperties.button:GetName());
	-- this context is the frame, so need the button
	local deleteButton = getglobal(self:GetName().."DeleteButton");
	local saveButton = getglobal(self:GetName().."SaveButton");
	local cancelButton = getglobal(self:GetName().."CancelButton");
	deleteButton:RegisterForClicks("AnyUp");
	saveButton:RegisterForClicks("AnyUp");
	cancelButton:RegisterForClicks("AnyUp");
end

-- Save button settings for the button that the mouse is hovering over (on click)
function addon.Props_Save(self)
	local btn = MagnetButtonProperties.button;
	local btnName = btn:GetName();
	local parent = btn:GetParent();
	local parentName = parent:GetName();
	btn:Enable();
	addon.SaveProperties(btn);
	addon.SaveButton(btn);
	addon.OnPlayerZoneChange();
end

function DeleteCurrentMagnetButton(self)
	local btn = MagnetButtonProperties.button;
	local btnName = btn:GetName();
	local parent = btn:GetParent();
	btn:Enable();
	addon.RemoveButtonFrame(parent);
	MagnetButtonProperties:Hide();
end

-- No changes
function addon.Props_Cancel(self)
	local btn = self:GetParent().button;
	btn:Enable();
end

function addon.AddonProps_Close()
	MagnetButtons_Global.HideBars.dungeon = MagnetButtonInterfacePropertiesCheckButtonHideBarDungeon:GetChecked();
	MagnetButtons_Global.HideBars.world = MagnetButtonInterfacePropertiesCheckButtonHideBarWorld:GetChecked();
	MagnetButtons_Global.HideBars.raid = MagnetButtonInterfacePropertiesCheckButtonHideBarRaid:GetChecked();
	MagnetButtons_Global.HideBars.arena = MagnetButtonInterfacePropertiesCheckButtonHideBarArena:GetChecked();
	--MagnetButtons_Global.FadeBlizzardUI = MagnetButtonInterfacePropertiesCheckButtonFadeBlizzardUI:GetChecked();
	addon.OnPlayerZoneChange();
	--addon.MainMenuBarFade(false);
end

function addon.AddonProps_CancelOrLoad()
	MagnetButtonInterfacePropertiesCheckButtonHideBarDungeon:SetChecked(MagnetButtons_Global.HideBars.dungeon);
	MagnetButtonInterfacePropertiesCheckButtonHideBarWorld:SetChecked(MagnetButtons_Global.HideBars.world);
	MagnetButtonInterfacePropertiesCheckButtonHideBarRaid:SetChecked(MagnetButtons_Global.HideBars.raid);
	MagnetButtonInterfacePropertiesCheckButtonHideBarArena:SetChecked(MagnetButtons_Global.HideBars.arena);
	--MagnetButtonInterfacePropertiesCheckButtonFadeBlizzardUI:SetChecked(MagnetButtons_Global.FadeBlizzardUI);
end

function addon.AddonProps_OnLoad(self)
	-- Set the name for the Category for the Panel
	self.name = "MagnetButtons";

	-- When the player clicks okay, run this function.
	self.okay = function (self) addon.AddonProps_Close(); end;

	-- When the player clicks cancel, run this function.
	self.cancel = function (self) addon.AddonProps_CancelOrLoad();  end;

	-- Add the panel to the Interface Options
	InterfaceOptions_AddCategory(self);
end

function addon.AddonProps_OnShow(self)
	local world = MagnetButtons_Global.HideBars.world;
	local dungeon = MagnetButtons_Global.HideBars.dungeon;
	local raid = MagnetButtons_Global.HideBars.raid;
	local arena = MagnetButtons_Global.HideBars.arena;
	MagnetButtonInterfacePropertiesCheckButtonHideBarDungeon:SetChecked(dungeon);
	MagnetButtonInterfacePropertiesCheckButtonHideBarWorld:SetChecked(world);
	MagnetButtonInterfacePropertiesCheckButtonHideBarRaid:SetChecked(raid);
	MagnetButtonInterfacePropertiesCheckButtonHideBarArena:SetChecked(arena);
	--MagnetButtonInterfacePropertiesCheckButtonFadeBlizzardUI:SetChecked(MagnetButtons_Global.FadeBlizzardUI);
	if (not world and not dungeon and not raid and not arena) then
		MagnetButtonInterfacePropertiesCheckButtonHideBarNever:SetChecked(true);
		MagnetButtonInterfacePropertiesCheckButtonHideBarAlways:SetChecked(false);
	elseif (world and dungeon and raid and arena) then
		MagnetButtonInterfacePropertiesCheckButtonHideBarNever:SetChecked(false);
		MagnetButtonInterfacePropertiesCheckButtonHideBarAlways:SetChecked(true);
	end
end

function addon.ShowInterfaceProperties()
	-- This needs to be called twice because of a blizzard bug, there is
	-- no performance loss for doing this, even if Blizzard fixes the bug.
	InterfaceOptionsFrame_OpenToCategory("MagnetButtons");
	InterfaceOptionsFrame_OpenToCategory("MagnetButtons");
end

function addon.DesignModeForceAllCheck()
	if (MagnetButtonInterfacePropertiesCheckButtonForceDungeon:GetChecked() and
		MagnetButtonInterfacePropertiesCheckButtonForceRaid:GetChecked() and
		MagnetButtonInterfacePropertiesCheckButtonForceBattleground:GetChecked() and
		MagnetButtonInterfacePropertiesCheckButtonForceArena:GetChecked()) then
			MagnetButtonInterfacePropertiesCheckButtonForceAll:SetChecked(true);
	end
end

function addon.DesignModeForceAllUncheck()
	if (not MagnetButtonInterfacePropertiesCheckButtonForceDungeon:GetChecked() and
		not MagnetButtonInterfacePropertiesCheckButtonForceRaid:GetChecked() and
		not MagnetButtonInterfacePropertiesCheckButtonForceArena:GetChecked() and
		not MagnetButtonInterfacePropertiesCheckButtonForceBattleground:GetChecked() and
		not MagnetButtonInterfacePropertiesCheckButtonForceAll:GetChecked()) then
			MagnetButtonInterfacePropertiesCheckButtonDisableDesign:SetChecked(true);
	end
end

function addon.GetDesignMode()
	local disabled = MagnetButtonInterfacePropertiesCheckButtonDisableDesign:GetChecked();
	local dungeon = MagnetButtonInterfacePropertiesCheckButtonForceDungeon:GetChecked();
	local raid = MagnetButtonInterfacePropertiesCheckButtonForceRaid:GetChecked();
	local arena = MagnetButtonInterfacePropertiesCheckButtonForceArena:GetChecked();
	local bg = MagnetButtonInterfacePropertiesCheckButtonForceBattleground:GetChecked();
	return (not disabled), dungeon, raid, arena, bg;
end

