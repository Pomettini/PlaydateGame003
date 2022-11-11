import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Corelibs/crank"
import "planet"

local gfx <const> = playdate.graphics
local spritelib <const> = gfx.sprite
local screenWidth <const> = playdate.display.getWidth()
local screenHeight <const> = playdate.display.getHeight()

local planets = {}
local currentPlanetId = 3
local currentDay = 0
local scaleFactor = 13

local mercury = Planet()
mercury:setName("Mercury")
mercury:setRevolution(87.97)
table.insert(planets, mercury)

local venus = Planet()
venus:setName("Venus")
venus:setRevolution(224.7)
table.insert(planets, venus)

local earth = Planet()
earth:setName("Earth")
earth:setRevolution(365.26)
table.insert(planets, earth)

local mars = Planet()
mars:setName("Mars")
mars:setRevolution(686.67)
table.insert(planets, mars)

local jupiter = Planet()
jupiter:setName("Jupiter")
jupiter:setRevolution(4331.865)
table.insert(planets, jupiter)

local saturn = Planet()
saturn:setName("Saturn")
saturn:setRevolution(10760.265)
table.insert(planets, saturn)

local uranus = Planet()
uranus:setName("Uranus")
uranus:setRevolution(30684.653)
table.insert(planets, uranus)

local neptune = Planet()
neptune:setName("Neptune")
neptune:setRevolution(60189.5475)
table.insert(planets, neptune)

function drawCurrentDayText()
	local x = screenWidth - 10
	local y = screenHeight - 25
	local text = "Day " .. currentDay
	
	gfx.drawTextAligned(text, x, y, kTextAlignment.right)
end

function drawSelectedPlanetText()
	local x = 10
	local y = screenHeight - 25
	local planet = planets[currentPlanetId]
	local name = planet:getName()
	local rev = planet:getRevolutions()
	-- Rounding the revolutions to the last two decimal places
	local text = name .. " " .. string.format("%.2f", rev) .. " orbits"
	
	gfx.drawTextAligned(text, x, y, kTextAlignment.left)
end

function playdate.update()
	gfx.clear()
	
	-- playdate.drawFPS(0, 0)
	
	-- One crank spin = earth rotation around the sun
	currentDay += playdate.getCrankTicks(365.26)
	
	for i, planet in ipairs(planets) do
		local isSelected = currentPlanetId == i
		planet:setRadius(i * scaleFactor)
		planet:setScale(scaleFactor)
		planet:setDays(currentDay)
		planet:setSelected(isSelected)
		planet:draw()
	end
	
	drawSelectedPlanetText()
	drawCurrentDayText()
end

function playdate.upButtonUp()
	scaleFactor += 1
end

function playdate.downButtonUp()
	scaleFactor -= 1
end

function playdate.leftButtonUp()
	-- If id is -1 it becomes 8 (last planet id)
	-- Sorry for unnecessary complex code
	currentPlanetId = (currentPlanetId % #planets - 2) % #planets + 1
end

function playdate.rightButtonUp()
	-- If id is 9 it becomes 1 (last planet is 8)
	currentPlanetId = currentPlanetId % #planets + 1
end
