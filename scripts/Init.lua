local addonName, addon = ...
local _G = _G

-- Initialize namespace (table)
MagnetButtons = addon;

-- Global saved settings
MagnetButtons_Global = { };
MagnetButtons_Global.HideBars = { };

-- Saved button data
MagnetButtons_ButtonData = { };			-- old
MagnetButtons_GlobalButtonData = { }; 	-- new

-- Global debug setting
BINDING_HEADER_MAGNETBUTTONS = "Magnet Buttons";
BINDING_NAME_MAGBUTTON_CREATE = "Create a new magnetic button";

local LINE_THICKNESS = 4;
addon.MaxFrameIndex = 0;
addon.IsInVehicle = false;
addon.clicks = { "LeftButton", "RightButton", "MiddleButton", "Button4", "Button5" };

DoIt.RegisterModule(addonName, addon);
