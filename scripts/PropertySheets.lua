---
--- Modified with permission from Semlar of AdvancedInterfaceOptions
---
local addonName, addon = ...
local _G = _G

local LastClickTime = GetTime();

local propertyDataGeneral = {
	{ "scale", "Scale", "Button Scale", nil },
	{ "texture", "Texture", "Icon/Texture Name or Id", nil },
    { "zoneType", "Zone Type", "world, dungeon, raid, battleground", nil },
	{ "tooltip", "Tooltip", "Overriding Tooltip Text", nil },
	{ "isusable-item", "IsUsable (Item)", "Macro visible usability is based on this item", nil },
	{ "isusable-spell", "IsUsable (Spell)", "Macro visible usability is based on this spell", nil },
}

local propertyDataLeftClick = {
	-- Types: spell, item, flyout, macro, actionbar, action, pet, item, worldmarker, cancelaura, stop, target, focus, assist, mainassist,
	--        maintank, click, attribute, togglemenu
	{ "type", "Type", "Button Type", nil },
	{ "unit", "Unit", "Unit to cast on", nil },
	{ "hotkey", "Hot Key", "Hot key binding string, like 'CTRL-F'", nil },
    { "action", "Action", "Action Name or Id", nil },
    { "spell", "Spell", "Spell Name or Id", nil },
    { "item", "Item", "Item Name or Id", nil },
    { "macro", "Macro", "Macro Name or Id", nil },
	{ "macrotext", "Macro Text", "Macro text string", nil },
	{ "clickbutton", "Click Button", "The name of the button for 'click' types.", nil },
	{ "marker", "Marker", "Marker Index for 'worldmarker' type", nil },
	{ "toy", "Toy", "Toy Id or name for the 'toy' type", nil },
    --{ "flyout", "Flyout Id", "Flyout Id", nil },
    { "flyoutDirection", "Flyout Direction", "LEFT, RIGHT, UP, or DOWN", nil },
}

local propertyDataRightClick = {
	-- Types: spell, item, flyout, macro, actionbar, action, pet, item, worldmarker, cancelaura, stop, target, focus, assist, mainassist,
	--        maintank, click, attribute, togglemenu
	{ "type2", "Type", "Button Type", nil },
	{ "unit2", "Unit", "Unit to cast on", nil },
	{ "hotkey2", "Hot Key", "Hot key binding string, like 'CTRL-F'", nil },
    { "action2", "Action", "Action Name or Id", nil },
    { "spell2", "Spell", "Spell Name or Id", nil },
    { "item2", "Item", "Item Name or Id", nil },
    { "macro2", "Macro", "Macro Name or Id", nil },
	{ "macrotext2", "Macro Text", "Macro text string", nil },
	{ "clickbutton2", "Click Button", "The name of the button for 'click' types.", nil },
	{ "marker2", "Marker", "Marker Index for 'worldmarker' type", nil },
	{ "toy2", "Toy", "Toy Id or name for the 'toy' type", nil },
    --{ "flyout2", "Flyout Id", "Flyout Id", nil },
    { "flyoutDirection2", "Flyout Direction", "LEFT, RIGHT, UP, or DOWN", nil },
}

local propertyDataMiddleClick = {
	-- Types: spell, item, flyout, macro, actionbar, action, pet, item, worldmarker, cancelaura, stop, target, focus, assist, mainassist,
	--        maintank, click, attribute, togglemenu
	{ "type3", "Type", "Button Type", nil },
	{ "unit3", "Unit", "Unit to cast on", nil },
	{ "hotkey3", "Hot Key", "Hot key binding string, like 'CTRL-F'", nil },
    { "action3", "Action", "Action Name or Id", nil },
    { "spell3", "Spell", "Spell Name or Id", nil },
    { "item3", "Item", "Item Name or Id", nil },
    { "macro3", "Macro", "Macro Name or Id", nil },
	{ "macrotext3", "Macro Text", "Macro text string", nil },
	{ "clickbutton3", "Click Button", "The name of the button for 'click' types.", nil },
	{ "marker3", "Marker", "Marker Index for 'worldmarker' type", nil },
	{ "toy3", "Toy", "Toy Id or name for the 'toy' type", nil },
    --{ "flyout3", "Flyout Id", "Flyout Id", nil },
    { "flyoutDirection3", "Flyout Direction", "LEFT, RIGHT, UP, or DOWN", nil },
}

local propertyDataButton4 = {
	-- Types: spell, item, flyout, macro, actionbar, action, pet, item, worldmarker, cancelaura, stop, target, focus, assist, mainassist,
	--        maintank, click, attribute, togglemenu
	{ "type4", "Type", "Button Type", nil },
	{ "unit4", "Unit", "Unit to cast on", nil },
	{ "hotkey4", "Hot Key", "Hot key binding string, like 'CTRL-F'", nil },
    { "action4", "Action", "Action Name or Id", nil },
    { "spell4", "Spell", "Spell Name or Id", nil },
    { "item4", "Item", "Item Name or Id", nil },
    { "macro4", "Macro", "Macro Name or Id", nil },
	{ "macrotext4", "Macro Text", "Macro text string", nil },
	{ "clickbutton4", "Click Button", "The name of the button for 'click' types.", nil },
	{ "marker4", "Marker", "Marker Index for 'worldmarker' type", nil },
	{ "toy4", "Toy", "Toy Id or name for the 'toy' type", nil },
    --{ "flyout4", "Flyout Id", "Flyout Id", nil },
    { "flyoutDirection4", "Flyout Direction", "LEFT, RIGHT, UP, or DOWN", nil },
}

local propertyDataButton5 = {
	-- Types: spell, item, flyout, macro, actionbar, action, pet, item, worldmarker, cancelaura, stop, target, focus, assist, mainassist,
	--        maintank, click, attribute, togglemenu
	{ "type5", "Type", "Button Type", nil },
	{ "unit5", "Unit", "Unit to cast on", nil },
	{ "hotkey5", "Hot Key", "Hot key binding string, like 'CTRL-F'", nil },
    { "action5", "Action", "Action Name or Id", nil },
    { "spell5", "Spell", "Spell Name or Id", nil },
    { "item5", "Item", "Item Name or Id", nil },
    { "macro5", "Macro", "Macro Name or Id", nil },
	{ "macrotext5", "Macro Text", "Macro text string", nil },
	{ "clickbutton5", "Click Button", "The name of the button for 'click' types.", nil },
	{ "marker5", "Marker", "Marker Index for 'worldmarker' type", nil },
	{ "toy5", "Toy", "Toy Id or name for the 'toy' type", nil },
    --{ "flyout5", "Flyout Id", "Flyout Id", nil },
    { "flyoutDirection5", "Flyout Direction", "LEFT, RIGHT, UP, or DOWN", nil },
}

-- This function is used to to support the /cmd1 +/cmd2 syntax in macro text attributes
-- Also converts texture id to texture names
local function fixValues(checkButton, propertyData, isLoad)
	if (isLoad) then
		for i, tbl in ipairs(propertyData) do
			local value = checkButton:GetAttribute(tbl[1]);
			tbl[4] = value;
			if (value) then
				if (tbl[1] == "texture") then
					local num = tonumber(value);
					if (type(tbl[4]) == "string" and tbl[4]:len() > 16 and tbl[4]:sub(1, 16):lower() == "interface/icons/") then
						tbl[4] = tbl[4]:sub(17);
					end
					local id, name = DoIt.GetTextureInfo(num or tbl[4]);
					if (name) then
						tbl[4] = name;
					else
						tbl[4] = num;
					end
				elseif (tbl[2] == "Macro Text") then
					tbl[4] = string.gsub(value, '\n/', '+/');
				end
			end
		end
	else
		for i, tbl in ipairs(propertyData) do
			local prop, name, value = tbl[1], tbl[2], tbl[4];
			if (value) then
				if (prop == "texture") then
					local num = tonumber(value);
					if (type(value) == "string" and value:len() > 16 and value:sub(1, 16):lower() == "interface/icons/") then
						value = value:sub(17);
					end
					local id, textureName, texturePath = DoIt.GetTextureInfo(num or value);
					value = texturePath or num;
				elseif (name == "Macro Text") then
					value = string.gsub(value, '+/', '\n/');
				end
				checkButton:SetAttribute(prop, value)
			else
				checkButton:SetAttribute(prop, value)
			end
		end
	end
end



-- Update the properties of a specific button with the values of the current property sheet
function addon.SaveProperties(checkButton)
	-- Clear the existing hotkey
	for idx = 1, 5 do
		local oldHotkey;
		if (idx == 1) then
			oldHotkey = checkButton:GetAttribute("hotkey")
		else
			oldHotkey = checkButton:GetAttribute("hotkey"..tostring(idx))
		end
		if (type(oldHotkey) == "string" and string.len(oldHotkey) > 0) then
			SetOverrideBinding(checkButton:GetParent(), false, oldHotkey);			
		end
	end

	fixValues(checkButton, propertyDataGeneral, false);
	fixValues(checkButton, propertyDataLeftClick, false);
	fixValues(checkButton, propertyDataRightClick, false);
	fixValues(checkButton, propertyDataMiddleClick, false);
	fixValues(checkButton, propertyDataButton4, false);
	fixValues(checkButton, propertyDataButton5, false);
	
	local parent = checkButton:GetParent();
	local scale = tonumber(checkButton:GetAttribute("scale"));
	local oldScale = parent:GetScale();
	if (scale and oldScale ~= scale) then
		local uiScale = UIParent:GetEffectiveScale();
		local point, relativeTo, relativePoint, xOfs, yOfs = parent:GetPoint(1);
		--DoIt.Debug("DEBUG: Setting parent scale to "..tostring(scale)..", "..tostring()
		parent:SetScale(scale);
		parent:ClearAllPoints();
		if (scale > oldScale) then
			parent:SetPoint(point, relativeFrame, relativePoint, xOfs / scale, yOfs / scale);
		elseif (scale < oldScale) then
			parent:SetPoint(point, relativeFrame, relativePoint, xOfs * scale, yOfs * scale);
		end
	else
		--DoIt.Debug("DEBUG: No scale is set!");
	end

	-- Set the new HotKeys
	for idx = 1, 5 do
		local hotkey;
		if (idx == 1) then
			hotkey = checkButton:GetAttribute("hotkey")
		else
			hotkey = checkButton:GetAttribute("hotkey"..tostring(idx))
		end
		if (type(hotkey) == "string" and string.len(hotkey) > 0) then
			SetOverrideBindingClick(checkButton:GetParent(), true, hotkey, checkButton:GetName(), addon.clicks[idx]);			
		end
	end

	local texture = checkButton:GetAttribute("texture");
	local icon = getglobal(checkButton:GetParent():GetName().."CheckButtonIcon");
	if (texture and icon) then
		icon:SetTexture(texture);
	end

	addon.SetButtonItemCount(checkButton);
	addon.SaveButton(checkButton);
end

-- Loads the current property sheet with the button's current attributes.
function addon.LoadProperties(checkButton)

	fixValues(checkButton, propertyDataGeneral, true);
	fixValues(checkButton, propertyDataLeftClick, true);
	fixValues(checkButton, propertyDataRightClick, true);
	fixValues(checkButton, propertyDataMiddleClick, true);
	fixValues(checkButton, propertyDataButton4, true);
	fixValues(checkButton, propertyDataButton5, true);

	MagnetButtonProperties.PropertyFrame0:SetItems(propertyDataGeneral);
	MagnetButtonProperties.PropertyFrame1:SetItems(propertyDataLeftClick);
	MagnetButtonProperties.PropertyFrame2:SetItems(propertyDataRightClick);
	MagnetButtonProperties.PropertyFrame3:SetItems(propertyDataMiddleClick);
	MagnetButtonProperties.PropertyFrame4:SetItems(propertyDataButton4);
	MagnetButtonProperties.PropertyFrame5:SetItems(propertyDataButton5);
end

function addon.GetPropertyValue(name)
    --DoIt.Debug("SetPropertyValue: "..tostring(name)..", "..tostring(value));
    for i, tbl in ipairs(propertyDataGeneral) do
        if (tbl[1] == name) then
            return tbl[4];
        end
	end
    for i, tbl in ipairs(propertyDataLeftClick) do
        if (tbl[1] == name) then
            return tbl[4];
        end
	end
    for i, tbl in ipairs(propertyDataRightClick) do
        if (tbl[1] == name) then
            return tbl[4];
        end
	end
    for i, tbl in ipairs(propertyDataMiddleClick) do
        if (tbl[1] == name) then
            return tbl[4];
        end
	end
    for i, tbl in ipairs(propertyDataButton4) do
        if (tbl[1] == name) then
            return tbl[4];
        end
	end
    for i, tbl in ipairs(propertyDataButton5) do
        if (tbl[1] == name) then
            return tbl[4];
        end
    end
end

function addon.SetPropertyValue(name, value)
    --DoIt.Debug("SetPropertyValue: "..tostring(name)..", "..tostring(value));
    for i, tbl in ipairs(propertyDataGeneral) do
        if (tbl[1] == name) then
            tbl[4] = value;
        end
	end
    for i, tbl in ipairs(propertyDataLeftClick) do
        if (tbl[1] == name) then
            tbl[4] = value;
        end
	end
    for i, tbl in ipairs(propertyDataRightClick) do
        if (tbl[1] == name) then
            tbl[4] = value;
        end
	end
    for i, tbl in ipairs(propertyDataMiddleClick) do
        if (tbl[1] == name) then
            tbl[4] = value;
        end
	end
    for i, tbl in ipairs(propertyDataButton4) do
        if (tbl[1] == name) then
            tbl[4] = value;
        end
	end
    for i, tbl in ipairs(propertyDataButton5) do
        if (tbl[1] == name) then
            tbl[4] = value;
        end
    end
	MagnetButtonProperties.PropertyFrame0:SetItems(propertyDataGeneral);
	MagnetButtonProperties.PropertyFrame1:SetItems(propertyDataLeftClick);
	MagnetButtonProperties.PropertyFrame2:SetItems(propertyDataRightClick);
	MagnetButtonProperties.PropertyFrame3:SetItems(propertyDataMiddleClick);
	MagnetButtonProperties.PropertyFrame4:SetItems(propertyDataButton4);
	MagnetButtonProperties.PropertyFrame5:SetItems(propertyDataButton5);
end


local PropertyInputBoxMouseBlocker = CreateFrame('frame', nil, ListFrame)
PropertyInputBoxMouseBlocker:Hide()

local PropertyInputBox = CreateFrame('editbox', nil, PropertyInputBoxMouseBlocker, 'InputBoxTemplate')
-- block clicking and cancel on any clicks outside the edit box
PropertyInputBoxMouseBlocker:EnableMouse(true)
PropertyInputBoxMouseBlocker:SetScript('OnMouseDown', function(self)
	PropertyInputBox:GetScript('OnEnterPressed')(PropertyInputBox)
	PropertyInputBox:ClearFocus()
end);
PropertyInputBoxMouseBlocker:SetFrameStrata("TOOLTIP");
PropertyInputBoxMouseBlocker:SetFrameLevel(999);
-- block scrolling
PropertyInputBoxMouseBlocker:EnableMouseWheel(true)
PropertyInputBoxMouseBlocker:SetScript('OnMouseWheel', function() end)
PropertyInputBoxMouseBlocker:SetAllPoints(nil)

local blackout = PropertyInputBoxMouseBlocker:CreateTexture(nil, 'BACKGROUND')
blackout:SetAllPoints()
blackout:SetColorTexture(0,0,0,0.2)

PropertyInputBox:SetFrameStrata("TOOLTIP");
PropertyInputBox:SetFrameLevel(1000);
PropertyInputBox:Hide()
PropertyInputBox:SetSize(160, 20)
PropertyInputBox:SetJustifyH('RIGHT')
PropertyInputBox:SetTextInsets(5, 10, 0, 0)
PropertyInputBox:SetScript('OnEscapePressed', function(self)
    self:ClearFocus()
    self:Hide()
end)

PropertyInputBox:SetScript('OnEnterPressed', function(self)
    addon.SetPropertyValue(self.property, self:GetText());
    self:Hide()
    --FilteredRefresh()
end)
--PropertyInputBox:SetScript('OnShow', function(self)
    --self:SetFocus()
--end)
PropertyInputBox:SetScript('OnHide', function(self)
    PropertyInputBoxMouseBlocker:Hide()
    if self.str then
        self.str:Show()
    end
end)
PropertyInputBox:SetScript('OnShow', function(self)
    --PropertyInputBoxMouseBlocker:Show()
end);
PropertyInputBox:SetScript('OnEditFocusLost', function(self)
    self:Hide()
    --FilterBox:SetFocus()
end)

local function setTabId(tabId, isNewTab)
	if (isNewTab) then
		getglobal("MagnetButtonPropertiesTabButton"..tabId.."Active"):Show()
		getglobal("MagnetButtonPropertiesTabButton"..tabId.."Inactive"):Hide()
	else
		getglobal("MagnetButtonPropertiesTabButton"..tabId.."Active"):Hide()
		getglobal("MagnetButtonPropertiesTabButton"..tabId.."Inactive"):Show()
	end
end

local function showPropertyFrame(tabId)
	if (tabId == 1) then
		MagnetButtonProperties.PropertyFrame0:Show();
	else
		MagnetButtonProperties.PropertyFrame0:Hide();
	end
	if (tabId == 2) then
		MagnetButtonProperties.PropertyFrame1:Show();
	else
		MagnetButtonProperties.PropertyFrame1:Hide();
	end
	if (tabId == 3) then
		MagnetButtonProperties.PropertyFrame2:Show();
	else
		MagnetButtonProperties.PropertyFrame2:Hide();
	end
	if (tabId == 4) then
		MagnetButtonProperties.PropertyFrame3:Show();
	else
		MagnetButtonProperties.PropertyFrame3:Hide();
	end
	if (tabId == 5) then
		MagnetButtonProperties.PropertyFrame4:Show();
	else
		MagnetButtonProperties.PropertyFrame4:Hide();
	end
	if (tabId == 6) then
		MagnetButtonProperties.PropertyFrame5:Show();
	else
		MagnetButtonProperties.PropertyFrame5:Hide();
	end
end

function _MagnetButtonsSetTabFunc(tabId)
	-- Set the current tab
	setTabId(1, (tabId == 1));
	setTabId(2, (tabId == 2));
	setTabId(3, (tabId == 3));
	setTabId(4, (tabId == 4));
	setTabId(5, (tabId == 5));
	setTabId(6, (tabId == 6));

	-- Change which property panel is displayed
	showPropertyFrame(tabId);
end

local function initializeListFrame(frame, propertyData)
	frame:SetPoint("CENTER", MagnetButtonProperties, "CENTER", 0, 5);
    frame:SetItems(propertyData);
    frame.Bg:SetAlpha(0.8);
    frame:SetScripts({
        OnEnter = function(self)
            if self.value ~= '' then
                --GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
                --local cvarTable = CVarList[self.value]
                --local _, defaultValue = GetCVarInfo(self.value)
                --GameTooltip:AddLine(cvarTable['prettyName'] or self.value, nil, nil, nil, false)
                --GameTooltip:AddLine(" ")
                --if cvarTable['description'] then --and _G[ cvarTable['description'] ] then
                --	GameTooltip:AddLine(cvarTable['description'], 1, 1, 1, true)
                --end
                --GameTooltip:AddDoubleLine("Default Value:", defaultValue, 0.2, 1, 0.6, 0.2, 1, 0.6)
    
                --local modifiedBy = AdvancedInterfaceOptionsSaved.ModifiedCVars[ self.value:lower() ]
                --if modifiedBy then
                --	GameTooltip:AddDoubleLine("Last Modified By:", modifiedBy, 1, 0, 0, 1, 0, 0)
                --end
    
                --GameTooltip:Show()
            end
            self.bg:Show()
        end,
        OnLeave = function(self)
            --GameTooltip:Hide()
            self.bg:Hide()
        end,
        OnMouseDown = function(self)
            local now = GetTime()
            if now - LastClickTime <= 0.2 then
                -- display edit box on row with current cvar value
                -- save on enter, discard on escape or losing focus
                if PropertyInputBox.str then
                    PropertyInputBox.str:Show()
                end
                self.cols[#self.cols]:Hide()
                PropertyInputBox.str = self.cols[#self.cols]
                PropertyInputBox.property = self.value
                PropertyInputBox.row = self
                PropertyInputBox:SetPoint('RIGHT', self)

				local value = addon.GetPropertyValue(self.value);
				--DoIt.Debug("DEBUG: "..tostring(value)..", "..tostring(self.value))
                PropertyInputBox:SetText(value or '')
                PropertyInputBox:HighlightText()
                PropertyInputBoxMouseBlocker:Show()
                PropertyInputBox:Show()
                PropertyInputBox:SetFocus()
            else
                LastClickTime = now
            end
        end,
	});
	return frame;
end

-- After login create the widgets, this is a one-shot event handler
PropertyInputBox:RegisterEvent("PLAYER_LOGIN");
PropertyInputBox:SetScript("OnEvent", function ()
    local columnHeaders = {{'Name', 100}, {'Description', 220, 'LEFT'}, {'Value', 160, 'RIGHT'}};
	local frame0 = addon:CreateListFrame(MagnetButtonProperties, 535, 200, columnHeaders);
	local frame1 = addon:CreateListFrame(MagnetButtonProperties, 535, 200, columnHeaders);
	local frame2 = addon:CreateListFrame(MagnetButtonProperties, 535, 200, columnHeaders);
	local frame3 = addon:CreateListFrame(MagnetButtonProperties, 535, 200, columnHeaders);
	local frame4 = addon:CreateListFrame(MagnetButtonProperties, 535, 200, columnHeaders);
	local frame5 = addon:CreateListFrame(MagnetButtonProperties, 535, 200, columnHeaders);

	MagnetButtonProperties.PropertyFrame0 = initializeListFrame(frame0, propertyDataGeneral);
	MagnetButtonProperties.PropertyFrame1 = initializeListFrame(frame1, propertyDataLeftClick);
	MagnetButtonProperties.PropertyFrame2 = initializeListFrame(frame2, propertyDataRightClick);
	MagnetButtonProperties.PropertyFrame3 = initializeListFrame(frame3, propertyDataMiddleClick);
	MagnetButtonProperties.PropertyFrame4 = initializeListFrame(frame4, propertyDataButton4);
	MagnetButtonProperties.PropertyFrame5 = initializeListFrame(frame5, propertyDataButton5);

	frame0:Show();
	frame1:Hide();
	frame2:Hide();
	frame3:Hide();
	frame4:Hide();
	frame5:Hide();
end);

function addon:CreateString(parent, text, width, justify)
	local str = parent:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmallLeft')
	str:SetText(text)
	str:SetWordWrap(false) -- hacky bit to truncate string without elipsis
	str:SetNonSpaceWrap(true)
	str:SetHeight(10)
	str:SetMaxLines(2)
	if width then str:SetWidth(width) end
	if justify then str:SetJustifyH(justify) end
	return str
end

-- Scroll frame
local function updatescroll(scroll)
	for line = 1, scroll.slots do
		local lineoffset = line + scroll.value
		if lineoffset <= scroll.itemcount then
			-- If we're mousing over a row when its contents change
			-- call its OnLeave/OnEnter scripts if they exist
			local mousedOver = scroll.slot[line]:IsMouseOver()
			if mousedOver then
				local OnLeave = scroll.slot[line]:GetScript('OnLeave')
				if OnLeave then
					OnLeave(scroll.slot[line])
				end
			end

			scroll.slot[line].value = scroll.items[lineoffset][1]
			scroll.slot[line].offset = lineoffset
			--local text = scroll.items[lineoffset][2]
			--if(scroll.slot[line].value == scroll.selected) then
				--text = "|cffff0000"..text.."|r"
			--end
			--scroll.slot[line].text:SetText(text)
			for i, col in ipairs(scroll.slot[line].cols) do
				col.item = scroll.items[lineoffset][i+1]
				col:SetText(scroll.items[lineoffset][i+1])
				col.id = i
			end

			if mousedOver then
				local OnEnter = scroll.slot[line]:GetScript('OnEnter')
				if OnEnter then
					OnEnter(scroll.slot[line])
				end
			end
			--scroll.slot[line].cols[2]:SetText(text)
			scroll.slot[line]:Show()
		else
			--scroll.slot[line].cols[2]:SetText("")
			scroll.slot[line].value = nil
			scroll.slot[line]:Hide()
		end
	end

	--scroll.scrollbar:SetValue(scroll.value)
end

local function scrollscripts(scroll, scripts)
	for k,v in pairs(scripts) do
		scroll.scripts[k] = v
	end
	for line = 1, scroll.slots do
		for k,v in pairs(scroll.scripts) do
			scroll.slot[line]:SetScript(k,v)
		end
	end
end

local function selectscrollitem(scroll, value)
	scroll.selected = value
	scroll:Update()
end

local function normalize(str)
	str = str and gsub(str, '|c........', '') or ''
	return str:gsub('(%d+)', function(d)
		local lenf = strlen(d)
		return lenf < 10 and (strsub('0000000000', lenf + 1) .. d) or d -- or ''
		--return (d + 0) < 2147483648 and string.format('%010d', d) or d -- possible integer overflow
	end):gsub('%W', ''):lower()
end

local function sortItems(scroll, col)
	-- todo: Keep items sorted when :Update() is called
	-- todo: Show a direction icon on the sorted column
	-- Force it in one direction if we're sorting a different column than was previously sorted
	if not col then
		if scroll.sortCol then
			col = scroll.sortCol
			if scroll.sortUp then
				table.sort(scroll.items, function(a, b)
					local x, y = normalize(a[col]), normalize(b[col])
					if x ~= y then
						return x < y
					else
						return a[1] < b[1]
					end
				end)
			else
				table.sort(scroll.items, function(a, b)
					local x, y = normalize(a[col]), normalize(b[col])
					if x ~= y then
						return x > y
					else
						return a[1] > b[1]
					end
				end)
			end
		end
	else
		if col ~= scroll.sortCol then
			scroll.sortUp = nil
			scroll.sortCol = col
		end
		if scroll.sortUp then
			table.sort(scroll.items, function(a, b)
				local x, y = normalize(a[col]), normalize(b[col])
				if x ~= y then
					return x > y
				else
					return normalize(a[1]) > normalize(b[1])
				end
			end)
			scroll.sortUp = false
		else
			table.sort(scroll.items, function(a, b)
				local x, y = normalize(a[col]), normalize(b[col])
				if x ~= y then
					return x < y
				else
					return normalize(a[1]) < normalize(b[1])
				end
			end)
			scroll.sortUp = true
		end
	end
	scroll:Update()
end

local function setscrolllist(scroll, items)
	scroll.items = items
	scroll.itemcount = #items
	scroll.stepValue = min(ceil(scroll.slots / 2), max(floor(scroll.itemcount / scroll.slots), 1))
	scroll.maxValue = max(scroll.itemcount - scroll.slots, 0)
	--scroll.value = scroll.minValue
	scroll.value = scroll.value <= scroll.maxValue and scroll.value or scroll.maxValue

	scroll.scrollbar:SetMinMaxValues(0, scroll.maxValue)
	scroll.scrollbar:SetValue(scroll.value)
	scroll.scrollbar:SetValueStep(scroll.stepValue)

	sortItems(scroll)

	scroll:Update()
end



local function scroll(self, arg1)
	-- Called when mousewheel is scrolled or scroll buttons are pressed
	local oldValue = self.value
	if ( self.maxValue > self.minValue ) then
		if ( self.value > self.minValue and self.value < self.maxValue )
		or ( self.value == self.minValue and arg1 == -1 )
		or ( self.value == self.maxValue and arg1 == 1 ) then
			local newval = self.value - arg1 * self.stepValue
			if ( newval <= self.maxValue and newval >= self.minValue ) then
				self.value = newval
			elseif ( newval > self.maxValue ) then
				self.value = self.maxValue
			elseif ( newval < self.minValue ) then
				self.value = self.minValue
			end
		elseif ( self.value < self.minValue ) then
			self.value = self.minValue
		elseif ( self.value > self.maxValue ) then
			self.value = self.maxValue
		end

		if self.value ~= oldValue then
			self:Update() -- probably does not need to be called unless value has changed
		end
	end
	if oldValue ~= self.value then
		self.scrollbar:SetValue(self.value)
	end
end

function addon:CreateListFrame(parent, w, h, cols)
	-- Contents of the list frame should be completely contained within the outer frame
	local frame = CreateFrame('Frame', nil, parent, 'InsetFrameTemplate')

	local inset = CreateFrame('Frame', nil, frame, 'InsetFrameTemplate')


	frame:SetSize(w, h)
	frame:SetFrameLevel(100)

	frame.scripts = {
		--["OnMouseDown"] = function(self) print(self.text:GetText()) end
	}
	frame.selected = nil
	frame.items = {}
	frame.itemcount = 0
	frame.minValue = 0
	frame.itemheight = 15 -- todo: base this on font size
	frame.slots = floor((frame:GetHeight()-10)/frame.itemheight)
	frame.slot = {}
	frame.stepValue = min(frame.slots, max(floor(frame.itemcount / frame.slots), 1))
	frame.maxValue = max(frame.itemcount - frame.slots, 0)
	frame.value = frame.minValue

	frame:EnableMouseWheel(true)
	frame:SetScript("OnMouseWheel", scroll)

	frame.Update = updatescroll
	frame.SetItems = setscrolllist
	frame.SortBy = sortItems
	frame.SetScripts = scrollscripts

	-- scrollbar
	local scrollUpBg = frame:CreateTexture(nil, nil, 1)
	scrollUpBg:SetTexture([[Interface\ClassTrainerFrame\UI-ClassTrainer-ScrollBar]])
	scrollUpBg:SetPoint('TOPRIGHT', 0, -2)--TOPLEFT', scrollbar, 'TOPRIGHT', -3, 2)
	scrollUpBg:SetTexCoord(0, 0.46875, 0.0234375, 0.9609375)
	scrollUpBg:SetSize(30, 120)


	local scrollDownBg = frame:CreateTexture(nil, nil, 1)
	scrollDownBg:SetTexture([[Interface\ClassTrainerFrame\UI-ClassTrainer-ScrollBar]])
	scrollDownBg:SetPoint('BOTTOMRIGHT', 0, 1)
	scrollDownBg:SetTexCoord(0.53125, 1, 0.03125, 1)
	scrollDownBg:SetSize(30, 123)
	--scrollDownBg:SetAlpha(0)


	local scrollMidBg = frame:CreateTexture(nil, nil, 2) -- fill in the middle gap, a bit hacky
	scrollMidBg:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-ScrollBar]], false, true)
	--scrollMidBg:SetPoint('RIGHT', -1, 0)
	scrollMidBg:SetTexCoord(0, 0.44, 0.75, 0.98)
	--scrollMidBg:SetSize(28, 80)
	--scrollMidBg:SetWidth(28)
	scrollMidBg:SetPoint('TOPLEFT', scrollUpBg, 'BOTTOMLEFT', 1, 2)
	scrollMidBg:SetPoint('BOTTOMRIGHT', scrollDownBg, 'TOPRIGHT', -1, -2)




	local scrollbar = CreateFrame('Slider', nil, frame, 'UIPanelScrollBarTemplate')
	--scrollbar:SetPoint('TOPLEFT', frame, 'TOPRIGHT', 4, -16)
	--scrollbar:SetPoint('BOTTOMLEFT', frame, 'BOTTOMRIGHT', 4, 16)
	scrollbar:SetPoint('TOP', scrollUpBg, 2, -18)
	scrollbar:SetPoint('BOTTOM', scrollDownBg, 2, 18)
	scrollbar.ScrollUpButton:SetScript('OnClick', function() scroll(frame, 1) end)
	scrollbar.ScrollDownButton:SetScript('OnClick', function() scroll(frame, -1) end)
	scrollbar:SetScript('OnValueChanged', function(self, value)
		frame.value = floor(value)
		frame:Update()
		if frame.value == frame.minValue then self.ScrollUpButton:Disable()
		else self.ScrollUpButton:Enable() end
		if frame.value >= frame.maxValue then self.ScrollDownButton:Disable()
		else self.ScrollDownButton:Enable() end
	end)
	frame.scrollbar = scrollbar

	local padding = 4
	-- columns
	frame.cols = {}
	local offset = 0
	for i, colTbl in ipairs(cols) do
		local name, width, justify = colTbl[1], colTbl[2], colTbl[3]
		local col = CreateFrame('Button', nil, frame)
		col:SetNormalFontObject('GameFontHighlightSmallLeft')
		col:SetHighlightFontObject('GameFontNormalSmallLeft')
		col:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 8 + offset, 0)
		col:SetSize(width, 18)
		col:SetText(name)
		col:GetFontString():SetAllPoints()
		if justify then
			col:GetFontString():SetJustifyH(justify)
			col.justify = justify
		end
		col.offset = offset
		col.width = width
		offset = offset + width + padding
		frame.cols[i] = col

		col:SetScript('OnClick', function(self)
			frame:SortBy(i+1)
		end)
	end


	-- rows
	for slot = 1, frame.slots do
		local f = CreateFrame("frame", nil, frame)
		f.cols = {}

		local bg = f:CreateTexture()
		bg:SetAllPoints()
		bg:SetColorTexture(1,1,1,0.1)
		bg:Hide()
		f.bg = bg

		f:EnableMouse(true)
		f:SetWidth(frame:GetWidth() - 38)
		f:SetHeight(frame.itemheight)

		for i, col in ipairs(frame.cols) do
			local str = addon:CreateString(f, 'x')
			str:SetPoint('LEFT', col.offset, 0)
			str:SetWidth(col.width)
			if col.justify then
				str:SetJustifyH(col.justify)
			end
			f.cols[i] = str
		end

		--[[
		local str = addon:CreateString(f, "Scroll_Slot_"..slot)
		str:SetAllPoints(f)
		str:SetWordWrap(false)
		str:SetNonSpaceWrap(false)
		--str:SetWidth(frame:GetWidth() - 50)
		--]]

		frame.slot[slot] = f
		if(slot > 1) then
			f:SetPoint("TOPLEFT", frame.slot[slot-1], "BOTTOMLEFT")
		else
			f:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
		end
		--f.text = str
	end


	frame:Update()
	return frame
end


-- Input boxes
function addon:CreateInput(parent, width, defaultText, maxChars, numeric)
	local editbox = CreateFrame('EditBox', nil, parent)

	editbox:SetTextInsets(5, 0, 0, 0)

	local borderLeft = editbox:CreateTexture(nil, 'BACKGROUND')
	borderLeft:SetTexture([[Interface\Common\Common-Input-Border]])
	borderLeft:SetSize(8, 20)
	borderLeft:SetPoint('LEFT', 0, 0)
	borderLeft:SetTexCoord(0, 0.0625, 0, 0.625)

	local borderRight = editbox:CreateTexture(nil, 'BACKGROUND')
	borderRight:SetTexture([[Interface\Common\Common-Input-Border]])
	borderRight:SetSize(8, 20)
	borderRight:SetPoint('RIGHT', 0, 0)
	borderRight:SetTexCoord(0.9375, 1, 0, 0.625)

	local borderMiddle = editbox:CreateTexture(nil, 'BACKGROUND')
	borderMiddle:SetTexture([[Interface\Common\Common-Input-Border]])
	borderMiddle:SetSize(10, 20)
	borderMiddle:SetPoint('LEFT', borderLeft, 'RIGHT')
	borderMiddle:SetPoint('RIGHT', borderRight, 'LEFT')
	borderMiddle:SetTexCoord(0.0625, 0.9375, 0, 0.625)

	editbox:SetFontObject('ChatFontNormal')

	editbox:SetSize(width or 8, 20)
	editbox:SetAutoFocus(false)

	if defaultText then
		local placeholderText = addon:CreateString(editbox, defaultText, width or 8)
		placeholderText:SetFontObject('GameFontDisableLeft')
		placeholderText:SetPoint('LEFT', 5, 0)

		editbox:SetScript('OnEditFocusLost', function(self)
			if self:GetText() == '' then
				placeholderText:Show()
			else
				EditBox_ClearHighlight(self)
			end
		end)

		editbox:SetScript('OnEditFocusGained', function(self)
			placeholderText:Hide()
			EditBox_HighlightText(self)
		end)
	else
		editbox:SetScript('OnEditFocusLost', EditBox_ClearHighlight)
		editbox:SetScript('OnEditFocusGained', EditBox_HighlightText)
	end

	editbox:SetScript('OnEscapePressed', EditBox_ClearFocus)
	--editbox:SetScript('OnEditFocusLost', EditBox_ClearHighlight)
	--editbox:SetScript('OnEditFocusGained', EditBox_HighlightText)
	editbox:SetScript('OnTabPressed', function(self)
		if self.tabTarget then
			self.tabTarget:SetFocus()
		end
	end)
	if maxChars then
		editbox:SetMaxLetters(maxChars)
	end
	if numeric then
		editbox:SetNumeric(true)
	end
	--editbox:SetText(defaultText or '')
	return editbox
end

-- Dropdown Menus
local DropdownCount = 0

local function initmenu(items)

	local info = UIDropDownMenu_CreateInfo()
	info.text = 'Challenge Mode' --GUILD_CHALLENGE_TYPE2
	info.func = function() return end
	UIDropDownMenu_AddButton(info)
end

function addon:CreateDropdown(parent, width, items, defaultValue)
	local dropdown = CreateFrame('frame', addonName .. 'DropDownMenu' .. DropdownCount, parent, 'UIDropDownMenuTemplate')
	-- todo: redo all of this
	--dropdown:EnableMouse(true)
	DropdownCount = DropdownCount + 1
	--groupTypeDropdown:SetPoint('LEFT', ilevelInput, 'RIGHT', -5, -3)
	--groupTypeDropdown:SetPoint('TOPRIGHT', titleInput, 'BOTTOMRIGHT', 16, -8)
	--dropdown:SetPoint('BOTTOMRIGHT', parent, 10, 0)
	--UIDropDownMenu_Initialize(dropdown, function()
	dropdown.SetValue = function(dropdown, value)
		dropdown.value = value
		dropdown:initialize()
	end

	dropdown.initialize = function(dropdown)
		--local selectedValue = UIDropDownMenu_GetSelectedValue(dropdown)
		for i, tbl in ipairs(items) do
			local info = UIDropDownMenu_CreateInfo()
			--info.value = v[1]
			--info.text = v[2]

			for k, v in pairs(tbl) do
				info[k] = v
				if not defaultValue and k == 'value' then
					defaultValue = v
				end
			end


			info.func = function(self)
				if tbl.func then
					tbl.func(self)
				end
				--UIDropDownMenu_SetSelectedID(dropdown, self:GetID(), true)
				UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				dropdown.value = self.value
			end

			--if info.isTitle then
				--info.text = '-' .. info.text .. '-'
			--end

			UIDropDownMenu_AddButton(info)
		end
		-- dropdown:SetValue(dropdown.value or defaultValue)
		UIDropDownMenu_SetSelectedValue(dropdown, dropdown.value or defaultValue)
	end


	--UIDropDownMenu_SetSelectedID(dropdown, defaultID or 1)
	--UIDropDownMenu_SetSelectedValue(dropdown, defaultValue)
	dropdown:SetValue(defaultValue)
	UIDropDownMenu_SetWidth(dropdown, width or 160)

	_G[dropdown:GetName() .. 'Button']:HookScript('OnClick', function(self)
		DropDownList1:ClearAllPoints()
		DropDownList1:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, 0)
		--ToggleDropDownMenu(nil, nil, dropdown, dropdown, 0, 0)
	end)

	return dropdown
end
