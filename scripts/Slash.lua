local addonName, addon = ...
local _G = _G

-- Popup Dialogs
StaticPopupDialogs["MAGNET_BUTTONS"] = {
  text = "Are you sure you want to destroy that item?",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function()
      DeleteCursorItem();
  end,
  timeout = 0,
  whileDead = true,
  showAlert = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

StaticPopupDialogs["MAGNET_BUTTONS2"] = {
  text = 'Are you sure you want to delete all of the magnet buttons? Saying "Yes" will also reload the user interface.',
  button1 = "Yes",
  button2 = "No",
  OnAccept = function()
      addon.ResetButtons();
	    ReloadUI(); -- This should fail in combat
  end,
  timeout = 0,
  whileDead = true,
  showAlert = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

-- Popup Dialogs
StaticPopupDialogs["MAGNET_BUTTONS3"] = {
  text = "Are you sure you want to delete the current magnet button?",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function()
      DeleteCurrentMagnetButton();
  end,
  timeout = 0,
  whileDead = true,
  showAlert = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

-- Popup Dialogs
StaticPopupDialogs["MAGNET_BUTTONS4"] = {
  hasEditBox = true,
  text = "Enter the full 'name-realm' for the character you want to copy MagnetButtons from. You may need to login to the other character before doing this. A user interface reload will happen if a valid name is entered.",
  button1 = "Confirm",
  button2 = "Cancel",
  OnAccept = function()
      if (addon.CopyButtonDataFrom(addon.copyFrom)) then
        ReloadUI()
      end
  end,
  EditBoxOnTextChanged = function (self, data)   -- careful! 'self' here points to the editbox, not the dialog
    addon.copyFrom = self:GetText();
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  enterClicksFirstButton = true,
}
----------------------------------------------------------------------------------
-- Binding and Chat Command Functions
--
SLASH_MAGBUTTON_CREATEB1, SLASH_MAGBUTTON_CREATEB2 = '/newb', '/newbutton';
SLASH_MAGBUTTON_CLEAR1, SLASH_MAGBUTTON_CLEAR2 = '/clearbuttons', "/resetbuttons";
SLASH_MAGBUTTON_ADDONS1, SLASH_MAGBUTTON_ADDONS2 = '/magconfig', '/mbconfig';
SLASH_MAGBUTTON_COPYFROM1, SLASH_MAGBUTTON_COPYFROM2 = "/magcopy", '/mbcopy';

SlashCmdList["MAGBUTTON_COPYFROM"] = function (msg, editbox)
  StaticPopup_Show("MAGNET_BUTTONS4");
end;

SlashCmdList["MAGBUTTON_CREATEB"] = function (msg, editbox)
  local inLockdown = InCombatLockdown();
  if (not inLockdown) then
    addon.NewEmptyButton()
  end
end;

SlashCmdList["MAGBUTTON_CLEAR"] = function (msg, value)
	StaticPopup_Show("MAGNET_BUTTONS2");
end;

SlashCmdList["MAGBUTTON_ADDONS"] = function (msg, value)
  addon:ShowInterfaceProperties()
end;



