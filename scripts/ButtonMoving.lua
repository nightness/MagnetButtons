--[[

    This file contains the code to move magnet buttons around, both single buttons and blocks of buttons.
    Moving multiple frames simultaneously? frame:StartMoving() can't be called on a different frame until you call frame:StopMovingOrSizing().
    So for moving multiple buttons it uses DoIt mouse move event to provide an (x, y) offset to change the (xOfs, yOfs)
    of a button's single anchor point.

]] --
local addonName, addon = ...
local _G = _G

---
--- Clears the block selection set for the target button (butoon that has the cursor)
---
function addon.ClearBlockSelection(self)
    -- Clear the selection set
    self.select_set = nil;
end

---
--- This function is called when both shift and control are down and a drag begins, it triggers a start of 
--- block move of buttons. 
---      TODO: It should hightlight all buttons to be included in the block move. :)
---
function addon.SetBlockSelection(self)
    -- Create an empty single array for a selection
    self.select_set = Classy.DataSet.new();

    -- This function get's a button's neighbors (up to four buttons),
    -- then recursively calls it's self on those (up to) four buttons. Recursion stops when a
    -- frame that is already in the selection set is passed as an argument.
    function findNeighbors(frame)
        -- Stop recursing if the frame is already in the selection set
        if (not frame or self.select_set:find(frame)) then return end

        -- add this frame to the selection set
        self.select_set:add(frame);

        -- scan for other magnet button frames
        local otherFrames = addon.GetOtherFrameLocations(frame);

        -- Create a subset and find neighboring frames.
        local subset = Classy.DataSet.new();
        local scale = Classy.Math.round(frame:GetParent():GetScale());
        local rect = Rectangle.CreateFromFrame(frame);

        for index = 1, #otherFrames do
            local frameName = otherFrames[index]["name"]; -- use or remove
            local targetFrame = getglobal(frameName); -- use or remove
            local targetScale = Classy.Math.round(targetFrame:GetScale());

            if (scale == targetScale) then
                local isAdjacent = Rectangle.IsAdjacent(rect, otherFrames[index]["rect"]);
                if (isAdjacent) then subset:add(targetFrame); end
            end
        end

        -- process all frames in the subset		
        for i = 1, subset:length() do findNeighbors(subset:get(i)); end
    end -- end declaration of the findNeighbors internal recursive function

    -- Find neighbors, initial start of the recursive function 
    findNeighbors(self:GetParent());
end

---
--- This holds a reference to the mouse-move event handler, so it can be
--- unsubscribed with finished.
---
local actual_handler = nil;
function addon.IsBlockMoving()
	return (actual_handler ~= nil);
end

---
--- This function is called to start moving a block of magnet buttons
---
function addon.StartBlockMove(self)
	-- Sanity Check
	if (addon.IsBlockMoving()) then return end

	--DoIt.Debug("Start block move... ")
	local select_set = self.select_set;

	local mouseMoveHandler = function (offsetX, offsetY)
		-- scale offset
		local bScale = self:GetParent():GetScale();
		offsetX = offsetX / bScale;
		offsetY = offsetY / bScale;
	
		for i = 1, select_set:length() do
			local parent = select_set:get(i);
			local frameName = parent:GetName() .. "CheckButton";
			local frame = getglobal(frameName);
			
			-- Disable button and clicks
			frame:Disable();
			frame:RegisterForClicks();

			-- Change offsets
			local point, relativeTo, relativePoint, xOfs, yOfs = parent:GetPoint(1);
			parent:ClearAllPoints();
			parent:SetPoint(point, relativeTo, relativePoint, xOfs + offsetX, yOfs + offsetY)
		end
	end	
	
	actual_handler = function(x, y, deltaX, deltaY, isDown)
		if (isDown) then
			-- Still dragging, handle event
			mouseMoveHandler(deltaX, deltaY);
		else
			--DoIt.Debug("Stop block move...")
			DoIt.Events.onMouseMove:unsubscribe(actual_handler)
			for i = 1, select_set:length() do
				local parent = select_set:get(i);
				local frameName = parent:GetName() .. "CheckButton";
				local frame = getglobal(frameName);

				-- Save button position
				addon.SaveButton(frame);

				-- Reenable frame and clicks
				frame:Enable();
				frame:RegisterForClicks("AnyUp");
			end
			actual_handler = nil;
			GameTooltip:Hide()
        end
	end
	
	-- Subscribe to onMouseMove event handler
    DoIt.Events.onMouseMove:subscribe(actual_handler);
end

-- This function adjusts x and y during the drag and determines if near other buttons
function addon.DragUpdateLocation(self, distanceResolution)
    local xpos, ypos = GetScaledCursorPosition();
    local rectThis = Rectangle.CreateFromFrame(self);
    local buttonScale = self:GetParent():GetScale();
    local count = 0;
    local found = false;

    -- adjust for offset point
    xpos = xpos - (self:GetWidth() / 2);
    ypos = ypos - (self:GetHeight() / 2);

    -- scan for other magnet button frames
    for index = 1, #self.OtherFrames do
        -- get the Rectangle of the other frame
        local rectFrame = self.OtherFrames[index]["rect"];
        local frameName = self.OtherFrames[index]["name"]; -- use or remove
        local targetFrame = getglobal(frameName); -- use or remove
        local targetScale = targetFrame:GetScale();

        if (targetScale == buttonScale) then
            -- bIntersect set to true only means the other return values are not null.
            -- local bIntersect, offsetX, offsetY = Rectangle.Intersect(rectThis, rectFrame);
            local bIntersect, offsetX, offsetY =
                Rectangle.ZoneIntersect(rectThis, rectFrame, distanceResolution);
            local oldX = xpos;
            local oldY = ypos;
            -- We're intersection with another button
            if (bIntersect) then
                -- local side = "";
                count = count + 1;

                -- 'a' squared plus 'b' squared is equal to 'c' squared.
                local length = math.sqrt(offsetX * offsetX + offsetY * offsetY);

                -- What side?
                local angle = math.atan2(offsetX, offsetY);
                angle = 180 - (angle * (180 / 3.141592653589793));

                if (angle > 45) and (angle <= 135) then
                    -- side = "left";
                    xpos = rectFrame["x"] - rectFrame["width"];
                    ypos = rectFrame["y"];
                elseif (angle > 135) and (angle <= 225) then
                    -- side = "bottom";
                    ypos = rectFrame["y"] - rectFrame["width"];
                    xpos = rectFrame["x"];
                elseif (angle > 225) and (angle <= 315) then
                    -- side = "right";
                    xpos = rectFrame["x"] + rectFrame["width"];
                    ypos = rectFrame["y"];
                else
                    -- side = "top";
                    ypos = rectFrame["y"] + rectFrame["width"];
                    xpos = rectFrame["x"];
                end
                ypos = ypos * buttonScale;
                xpos = xpos * buttonScale;
                found = true;
            end

            -- Prevent two buttons from having the same location
            if (bIntersect) then
                local i;
                local targetRect = Rectangle.Create(xpos, ypos, 0, 0);
                for i = 1, #self.OtherFrames do
                    local rectTest = self.OtherFrames[i]["rect"];
                    if (Rectangle.IsSameLocation(targetRect, rectTest)) then
                        xpos = oldX;
                        ypos = oldY;
                        found = false;
                        break
                    end
                end
            end
        end
    end
    return xpos, ypos, found;
end

function addon.IsButtonLocked(self) return false; end

function addon.StartButtonMove(self)
    local parent = self:GetParent();

    self.IsMoving = true;
    self.OtherFrames = addon.GetOtherFrameLocations(self);
    self:RegisterForClicks();
    self:Disable();
    parent:StartMoving();
end

function addon.StopButtonMove(self)
    local parent = self:GetParent();

    self.IsMoving = false;
    self.OtherFrames = nil;
    parent:StopMovingOrSizing();
    addon.SaveButton(self);
    self:Enable();
    self:RegisterForClicks("AnyUp");
end

