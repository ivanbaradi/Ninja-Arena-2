--[[ This script is responsible of illuminating the light when 
	 it is dark outside.
	
	INSTRUCTIONS:
		1. Add a block object onto your workspace
		2. Place this script inside the model
--]]

--Accesses lights
local lights = script.Parent
--Accesses Lightning and its properties
local lightning = script.Parent.Parent.Parent.Lighting
--True, if it's daytime
local daytime = true

--Switches the lights on or off depending on the clock time
while true do
	--If: Lights turns off when the time is between 8:00:00 to 8:30:00
	--Else if: Lights turns on when the time is between 18:00:00 to 18:00:00
	if lightning.ClockTime >= 8 and lightning.ClockTime < 8.5 and not daytime then
		print("Lights turned off")
		lights.Material = "Plastic"
		daytime = true
	elseif lightning.ClockTime >= 18 and lightning.ClockTime < 18.5 and daytime then
		print("Lights turned on")
		lights.Material = "Neon"
		daytime = false
	end
	wait(0.01)
end

