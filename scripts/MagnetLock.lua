--
-- The mathy part of magnetic locking
--
Rectangle = { };

local function round(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 2.5) else x = math.ceil(x - 2.5) end
    return x / n
end

function Rectangle.Create(x, y, width, height)
	local table = {};
	table["x"] = x;
	table["y"] = y;
	table["width"] = width;
	table["height"] = height;
	return table;
end

function Rectangle.CreateFromFrame(frame)
	local x, y, width, height;
	--DoIt.Debug("Rectangle.CreateFromFrame: "..frame:GetName());
	if (not frame) then
		return nil;
	end
	x = frame:GetLeft(); -- * frame:GetScale();
	y = frame:GetBottom() -- * frame:GetScale();
	width = frame:GetWidth() -- * frame:GetScale();
	height = frame:GetHeight() -- * frame:GetScale();
	-- DoIt.Debug("Rectangle.CreateFromFrame: Creating at "..x..", "..y);
	return Rectangle.Create(x, y, width, height);
end

-- Is some part of rect2 in rect1's zone-radius
-- rect1 is really just a point, the mouse pointer location
function Rectangle.ZoneIntersect(rect1, rect2, distanceResolution)
	local cX1 = rect1["x"] + (rect1["width"] / 2); -- center
	local cY1 = rect1["y"] + (rect1["height"] / 2);
	local cX2 = rect2["x"] + (rect2["width"] / 2);
	local cY2 = rect2["y"] + (rect2["height"] / 2 );
	--local radius = rect2["width"] * 1.5;
	local dist = math.sqrt(math.pow(cX2 - cX1, 2) + math.pow(cY2 - cY1, 2));
	-- DoIt.Debug("ZoneIntersect check: radius = "..tostring(radius));
	if (dist < distanceResolution) then
		-- Return parameters 2 & 3, x & y adjustments to intersect
		return true, (rect2["x"] - rect1["x"]), (rect2["y"] - rect1["y"]);
	end
	return false;
end

function Rectangle.IsSameLocation(rect1, rect2)
	local x = round(rect1["x"]) == round(rect2["x"]);
	local y = round(rect1["y"]) == round(rect2["y"]);
	return (x and y);
end

-- Is some part of rect2 intersecting with rect1?
function Rectangle.Intersect(rect1, rect2)
	local rX1 = rect1["x"] + rect1["width"]; -- right 
	local rY1 = rect1["y"] + rect1["height"]; -- bottom
	local rX2 = rect2["x"] + rect2["width"]; -- right
	local rY2 = rect2["y"] + rect2["height"]; -- bottom
	local xNonIntercept = ((rect2["x"] >= rX1) or (rX2 <= rect1["x"]));
	local yNonIntercept = ((rect2["y"] >= rY1) or (rY2 <= rect1["y"]));	
	if (not xNonIntercept and not yNonIntercept) then
		-- Return parameters 2 & 3, x & y adjustments to not intersect
		return true, (rect2["x"] - rect1["x"]), (rect2["y"] - rect1["y"]);
	end
	return false;
end

--
-- Rectangle.IsAdjacent(rect1, rect2): Is rect1 adjacent to rect2? More specifically... is
-- it horizonally or vertally locked to a side of the first rect?
--
local function round(num) return floor(num + 0.5) end	
local function makeint(rect) return floor(rect["x"]), floor(rect["y"]), round(rect["width"]), round(rect["height"]) end
function Rectangle.IsAdjacent(rect1, rect2)
	local x1, y1, width1, height1 = makeint(rect1);
	local x2, y2, width2, height2 = makeint(rect2)
	if (width1 == width2 and height1 == height2) then
		return (
			(x1 == x2 and y1 + height1 == y2) or
			(x1 == x2 and y1 - height1 == y2) or
			(y1 == y2 and x1 + width1 == x2) or
			(y1 == y2 and x1 - width1 == x2)
		);
	end
	return false;
end
