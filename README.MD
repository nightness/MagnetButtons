Event's watch and unwatch for polling changes from a function

Force the correct cursor with the "Unit" attribute set, force setting Cursor, like is done in Vendor buy buttons

"Click specific textures", so a button shows just the one texture now; just one of the five possible actions for button's specific clicks is represented by that texture, that's why it's on the general tab... I have no idea if Blizzard will allow this, but for other button clicks it might be possible to change the button's texture starting onMouseDown, and restoring the default onMouseUp. :)

With the option to leave the button before MouseUp, and cancel the Click, since a Click even requires the MouseUp event. So you can see the texture, just to see it, you don't have to follow though on the click and use it. :)

Properties General and Tab's with "type" set, should show as bold text on the tab

Show keybindings in tooltips

Implement Companion/Pet's in retail
    "battlepet", petId = GetCursorInfo();
    C_PetJournal.GetPetInfoByPetID(petId)
    petId = C_PetJournal.GetSummonedPetGUID()
    C_PetJournal.SummonPetByGUID(petId)
    Add support for SummonRandomFavoritePet()


MagnetButtons In-progress
=================================================================================================================================================
* Make cooldown window black/transparent
* Fix zoneType
* Add an "instance" zoneType for (dungeons, raid, pvp, arena, but not world)?
* Support for companions (retail)
* Pet buttons to hide with pet, also these buttons should somehow be pet (and spec) specific.

Everything a button needs to do before 1.x release
==================================================
* Inherit from the secure button templates (Gives click handler) [DONE]
* Show Tool Tips (mouse enter/leave) [DONE]
* Show Cooldowns (animation) [PARTIAL_NEEDS_TOOLTOP_SUPPORT]
* Show Cooldown expirations (animation)
* Show Counts (text) [DONE]
* Show In-Range dots, when a target is selected

* Note: When I do a macro... /cast [spell name], it will ONLY cast the highest rank or specified rank of the spell (example: /cast Rebirth(Rank 3)).
        But blizzard's buttons can scale down the rank to a rank appropiate for the target's level.


Other Ideas
=================================================================================================================================================
       
* Advanced mode: all set properties, and insertion for new properties.
* There is room for one more tab, "Custom properties"
* Need to be able to add custom attributes

"type" 	Any clicks.
"*type1" 	Any left click.
"type1" 	Unmodified left click.
"shift-type2" 	Shift+right click. (But not Alt+Shift+right click)
"shift-type*" 	Shift+any button click.
"alt-ctrl-shift-type*" 	Alt+Control+Shift+any button click. 

* Add button modify protection, a general property "readonly" that will ask for confirmation to save, overwrite, or delete a button.
* Extra and not supose to be there, line highlighting in propery editors
* Set the default scale in addon options.
* /script ToggleFrame(SpellBookFrame)
* Add a multi-line edit box for properties like macrotext.
* Fix "Page 2" Pet Button drops, and pet spell visibility issues
    - Also, Mask or hide button?
* Layout templates containers
    - Builder UI



MagnetButtons Notes
=================================================================================================================================================
* Try to reuse Blizzard's icon selection window used in macros
* Create an option to add additional button properties, there are certainly a plethera of options.
* Create a text window for exporting a single buttons properties to text, for importing by someone else.
* Use addon messaging to quickly send buttons to people in your group.
* Change over to using the "toy" type and "cancelaura" for type2
* Don't allow button modification in combat... Created buttons need a reload, and changed buttons only change textures!
	* Or find an untainted way of doing it
* Make it so all buttons disappear when the vehicle bar is shown.
* Should only show drop target only when shift is pressed, this way people can still trade the cursor drop with someone.
* Borders and border flashing
* Add "In-Range" dots
		inRange = IsItemInRange(itemID, "unit") or IsItemInRange("itemName", "unit") or IsItemInRange("itemLink", "unit")
			itemID - An item's ID (number)
			itemName - An item's name (string)
			itemLink - An item's hyperlink, or any string containing the itemString portion of an item link (string)
			unit - A unit on which to use the item (string, unitID)	
		inRange = IsSpellInRange(index, "bookType", "unit") or IsSpellInRange("name", "unit")
			index - Index of a spell in the spellbook (number, spellbookID)
			bookType - Type of spellbook (string)
				pet - The pet's spellbook
				spell - The player's spellbook
			name - Name of a spell (string)
			unit - A unit to target with the spell (string, unitID)
* Need the "Sparkle" - "I'm ready" flash after a cooldown is complete
* Start looking at container options
* Masque themeing/skinning support
* (Boolean) feature, display a button only when usable, like the the mounts for specific dungeons and raids. 

References
=================================================================================================================================================
"PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED"

eventtrace - /eventtrace,/etrace - Allows the user to trace events in-game. 
framestack - /framestack,/fstack - Allows the user to see all frames under the cursor. 

"cancelaura"	target-slot, index, spell
"destroytotem"	"totem-slot"
"leavevehicle"

"unit" 	"target" 	Make all actions target the player's target.
"*harmbutton1" 	"nuke1" 	Remap any left clicks to "nuke1" clicks when target is hostile.
"*harmbutton2" 	"nuke2" 	Remap any right clicks to "nuke2" clicks when target is hostile.
"helpbutton1" 	"heal1" 	Remap unmodified left clicks to "heal1" clicks when target is friendly.
"type" 	"spell" 	Make all clicks cast a spell.
"spell-nuke1" 	"Mind Flay" 	Cast Mind Flay on "hostile" left click.
"spell-nuke2" 	"Shadow Word: Death" 	Cast Shadow Word: Death on "hostile" right click.
"alt-spell-nuke2" 	"Mind Blast" 	Cast Mind Blast on "hostile" alt-right click.
"spell-heal1" 	"Flash Heal" 	Cast Flash Heal on "friendly" left click. 
"downbutton" 	Any string 	Remaps the mouse button if this is a "down" click. This transformation is applied before all others.
"unitsuffix" 	"pet", "target", etc. 	Appends the attribute's value to the "unit" attribute value when resolving units.
"toggleForVehicle" 	true, false 	When the unit's owner is in a vehicle, remap the pet to its owner, and its owner to its pet (the vehicle). Based on the original unit:

    If it was a pet unit ("raidpetX", "pet", etc), and owner is in a vehicle, remap to owner.
    If it did not contain "target", or "allowVehicleTarget" attribute is set to true, remap the original unit to its pet.

"allowVehicleTarget" 	true, false 	If true, allows "toggleForVehicle" to remap units like "party1target" to "partypet1target".
"checkselfcast" 	true, false 	If true, and the SELFCAST modifier is held down, resolves the unit to "player".
"checkfocuscast" 	true, false 	If true, and the FOCUSCAST modifier is held down, resolves the unit to "focus". 

"actionbar" 	"action" 	Switches the current action bar depending on the value of the "action" attribute:

    A number: switches to a the bar specified by the number.
    "increment" or "decrement": move one bar up/down.
    "a, b", where a, and b are numeric, switches between bars a and b.

"action" 	"unit", "action"
["actionpage"] 	Performs an action specified by the "action" attribute (a number).

If the button:GetID() > 0, paging behavior is supported; see the ActionButton_CalculateAction FrameXML function.
"pet" 	"unit", "action" 	Calls CastPetAction(action, unit);
"spell" 	"unit", "spell" 	Calls CastSpellByName(spell, unit);
"item" 	"unit"
"item" OR
["bag", "slot"] 	Equips or uses the specified item, as resolved by SecureCmdItemParse.

    "item" attribute value may be a macro conditioned string, item name, or "bag slot" string (e.g. "1 3").
    If "item" is nil, the "bag" and "slot" attributes are used; those are deprecated -- use a "bag slot" item string.

"macro" 	"macro" OR
"macrotext" 	If "macro" attribute is specified, calls RunMacro(macro, button); otherwise, RunMacroText(macrotext, button);
"flyout" 	"spell"[, "flyoutDirection"] 	Toggles the specified spell flyout (flyout ID in the spell attribute), with the specified direction ("UP", "DOWN", "LEFT", RIGHT"; defaults to "UP").
"glyph" 	"glyph", "slot" 	Applies a glyph specified by the glyph attribute (either by name or ID) to the specified slot ("minor1", "major1", ...)
"worldmarker" 	"marker", "action" 	Sets, clears, or toggles the world marker specified by the marker attribute if the action is "set", "clear", or "toggle" respectively.
"cancelaura" 	"unit", "spell"[, "rank"]
"target-slot"
"index"[, "filter"] 	Performs the first of the following actions that applies:

    If the "spell" attribute is set, calls CancelUnitBuff(unit, spell, rank).
    If the "target-slot" attribute is set to a weapon (main or secondary) slot ID, calls CancelItemTempEnchantment for the appropriate slot.
    If the "index" attribute is set, calls CancelUnitBuff("player", index, filter)

"stop" 	  	Calls SpellStopTargeting().
"target" 	"unit" 	Changes target, targets a unit for a spell, or trades unit an item on the cursor.

If "unit" attribute value is "none", your target is cleared.
"focus" 	"unit" 	Calls FocusUnit(unit).
"assist" 	"unit" 	Calls AssistUnit(unit).
"mainassist" 	"action", "unit" 	Performs a main assist status on the unit based on the value of the "action" attribute:

    nil or "set": the unit is assigned main assist status. (SetPartyAssignment)
    "clear": the unit is stripped main assist status. (ClearPartyAssignment)
    "toggle": the main assist status of the unit is inverted.

"maintank" 	"action", "unit" 	As "mainassist", but for main tank status.
"click" 	"clickbutton" 	Calls clickbutton:Click(button)
"attribute" 	["attribute-frame",]
"attribute-name"
"attribute-value" 	Calls frame:SetAttribute(attributeName, attributeValue). If "attribute-frame" is not specified, the button itself is assumed.
"togglemenu" 	"unit" 	Opens a unit popup menu at the cursor for this button's unit. [New in 5.2]

Any other value 	"_type" 	Action depends on the value of the modified ("_" .. type) attribute, or rawget(button, type), in that order.

    If the value is a function, it is called with (self, unit, button, actionType) arguments
    If the value is a string, a restricted snippet stored in the attribute specified by the value on the button is executed as if it was OnClick.


	  