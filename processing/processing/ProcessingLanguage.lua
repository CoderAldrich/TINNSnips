
local Color = require("processing.Color")

--[==================================================[
		LANGUAGE COMMANDS
--]==================================================]

function blue(c)
	return c.B
end

function green(c)
	return c.G
end

function red(c)
	return c.R
end

function alpha(c)
	return c.A
end


function color(...)
	return Color(...)
end

function background(...)
	--if arg.n == 1 and type(arg[1]) == "table" then
	--	return Processing.SetBackgroundColor(arg[1])
	--end
	if select("#",...) == 1 and type(select(1,...)) == "table" then
		return Processing.Renderer:setBackgroundColor(select(1,...))
	end

	return Processing.Renderer:setBackgroundColor(Color(...))
end

function colorMode(amode)
	-- if it's not valid input, just return
	if amode ~= RGB and amode ~= HSB then 
		return false
	end

	--return Processing.SetColorMode(amode)
end

function fill(...)
	-- See if we're being passed a 'Color'
	-- type
	if select("#",...) == 1 and type(select(1,...)) == "table" then
		return Processing.Renderer:setFillColor(select(1,...))
	end

	return Processing.Renderer:setFillColor(Color(...))
end

function noFill()
	return Processing.Renderer:setFillColor(Color(0,0))
end

function noStroke()
	return Processing.Renderer:setStrokeColor(Color(0,0))
end

function stroke(...)
	if select("#",...) == 1 and type(select(1,...) == "table") then
		-- We already have a color structure
		-- so just set it
		return Processing.Renderer:setStrokeColor(select(1,...))
	end

	-- Otherwise, construct a new color object
	-- and set it
	return Processing.Renderer:setStrokeColor(Color(...))
end


function point(x,y,z)
	Processing.Renderer:drawPoint(x,y)
end

function line(...)
	-- We either have 4, or 6 parameters
	local x1, y1, z1, x2, y2, z2

	if select("#", ...) == 4 then
		x1 = arg[1]
		y1 = arg[2]
		x2 = arg[3]
		y2 = arg[4]
	elseif select('#',...) == 6 then
		x1 = arg[1]
		y1 = arg[2]
		z1 = arg[3]
		x2 = arg[4]
		y2 = arg[5]
		z2 = arg[6]
	else
		return false
	end

	return Processing.Renderer:drawLine(x1, y1, x2, y2)
end

function rect(x, y, w, h)
	Processing.Renderer:drawRect(x, y, w, h)
end

function triangle(x1, y1, x2, y2, x3, y3)
	Processing.Renderer:drawTriangle(x1, y1, x2, y2, x3, y3)
end

function polygon(pts)
	Processing.Renderer:drawPolygon(pts)
end

function quad(x1, y1, x2, y2, x3, y3, x4, y4)
	local pts = {
		Point3D(x1, y1, 0),
		Point3D(x2, y2, 0),
		Point3D(x3, y3, 0),
		Point3D(x4, y4, 0),
	}

	polygon(pts)
end

function ellipse(centerx, centery, awidth, aheight)
	return Processing.Renderer:drawEllipse(centerx, centery, awidth, aheight)
end

--[====================================[
--	Curves
--]====================================]



function bezier(x1, y1,  x2, y2,  x3, y3,  x4, y4)
	Processing.Renderer:DrawBezier(
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0})
end

function bezierDetail(...)
end

function bezierPoint(...)
end

-- Catmull - Rom curve
function curve(x1, y1,  x2, y2,  x3, y3,  x4, y4)
	Processing.Renderer:DrawCurve(
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0})
end

function curveDetail(...)
end

function curvePoint(...)
end

function curveTangent(...)

end

function curveTightness(...)
end

-- ATTRIBUTES
function smooth()
	Processing.Renderer:SetAntiAlias(true)
end

function noSmooth()
	Processing.Renderer:SetAntiAlias(false)
end

function pointSize(ptSize)
	Processing.Renderer:SetPointSize(ptSize)
end

function strokeCap(cap)
	Processing.Renderer:SetLineCap(cap);
end

function strokeJoin(join)
	Processing.Renderer:SetLineJoin(join)
end

function strokeWeight(weight)
	Processing.Renderer:SetLineWidth(weight)
end

function size(awidth, aheight, MODE)
	Processing.SetCanvasSize(awidth, aheight, MODE)
end

-- VERTEX
function beginShape(...)
	local sMode = POLYGON
	if arg.n == 0 then
		Processing.VertexMode = gl.POLYGON
	elseif arg[1] == POINTS then
		Processing.ShapeMode = gl.POINTS
	elseif arg[1] == LINES then
		Processing.ShapeMode = gl.LINES
	end
end

function bezierVertex()
end

function curveVertex()
end

function endShape()
end

function texture()
end

function textureMode()
end

function vertex(...)
	local x = nil
	local y = nil
	local z = nil
	local u = nil
	local v = nil

	if (arg.n == 2) then
		x = arg[1]
		y = arg[2]
		z = 0
	elseif arg.n == 3 then
		x = arg[1]
		y = arg[2]
		z = arg[3]
	elseif arg.n == 4 then
		x = arg[1]
		y = arg[2]
		u = arg[3]
		v = arg[4]
	elseif arg.n == 5 then
		x = arg[1]
		y = arg[2]
		z = arg[3]
		u = arg[4]
		v = arg[5]
	end


	if u and v then
		-- texture coordinate
	end

	if x and y and z then
		gl.vertex(x,y,z)
	end

end






--[==============================[
	TRANSFORM
--]==============================]

-- Matrix Stack
function popMatrix()
	Processing.Renderer:PopMatrix();
end


function pushMatrix()
	Processing.Renderer:PushMatrix();
end

function applyMatrix()
end

function resetMatrix()
end

function printMatrix()
end


-- Simple transforms
function translate(x, y, z)
	Processing.Renderer:Translate(x, y, z)
end

function rotate(rads)
	Processing.Renderer:Rotate(rads)
end

function rotateX(rad)
end

function rotateY(rad)
end

function rotateZ(rad)
end

function scale(sx, sy, sz)
	Processing.Renderer:Scale(sx, sy, sz)
end

function shearX()
end

function shearY()
end



--[[
	Scene
--]]
function addactor(actor)
	if not actor then return end

	if actor.Update then
		table.insert(Processing.Actors, actor)
	end

	if actor.Render then
		addgraphic(actor)
	end

	addinteractor(actor)
end

function addgraphic(agraphic)
	if not agraphic then return end

	table.insert(Processing.Graphics, agraphic)
end

function addinteractor(interactor)
	if not interactor then return end

	if interactor.MouseActivity then
		table.insert(Processing.MouseInteractors, interactor)
	end

	if interactor.KeyboardActivity then
		table.insert(Processing.KeyboardInteractors, interactor)
	end
end


--[==============================[
	TYPOGRAPHY
--]==============================]

function createFont()
end

function loadFont()
end

function text(x, y, txt)
	Processing.Renderer:drawText(x, y, txt)
end

-- Attributes

function textAlign(align, yalign)
	yalign = yalign or Processing.TextYAlignment

	Processing.TextAlignment = align
	Processing.TextYAlignment = yalign
	--Processing.SetTextAlignment(align, yalign)

	Processing.Renderer:SetTextAlignment(align)
end

function textLeading(leading)
	Processing.TextLeading = leading
end

function textMode(mode)
	Processing.TextMode = mode
end

function textSize(asize)
	Processing.TextSize = asize
end

function textWidth(txt)
	twidth, theight = Processing.Renderer:MeasureString(txt)
	return Processing.GetTextWidth(astring)
end

function textFont(fontname)
	return Processing.Renderer:SetFont(fontname);
	--return Processing.SetFontName(fontname)
end

-- Metrics
--[[
function textAscent()
end

function textDescent()
end
--]]

--[==============================[
	ENVIRONMENT
--]==============================]

function cursor()
end

function noCursor()
end

function frameRate(rate)
	Processing.FrameRate = rate
end




--[==============================[
	IMAGE
--]==============================]
function createImage(awidth, aheight, dtype)
	local pm = PImage(awidth, aheight, dtype)
	return pm
end

-- Loading and Displaying
--(img, offsetx, offsety, awidth, aheight)
function image(img, x, y, awidth, aheight)
	if img == nil then return end
	awidth = awidth or 0
	aheight = aheight or 0

	Processing.Renderer:DrawImage(img, x, y, awidth, aheight)
end

function imageMode()
end

function loadImage(filename)
	local pm = PImage({Filename = filename})

	return pm
end

function requestImage()
end

function tint()
end

function noTint()
end

-- Pixels
function blend()
end

function copy()
end

function filter()
end

function get(x, y)
	return Processing.Renderer:get(x,y)
end

function set(x, y, acolor)
	Processing.Renderer:set(x, y, acolor)
end

function loadPixels()
	Processing.Renderer:loadPixels()
end

function pixels()
end

function updatePixels()
	Processing.Renderer:updatePixels();
end


