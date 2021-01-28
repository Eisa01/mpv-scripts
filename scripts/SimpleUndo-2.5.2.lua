-- Copyright (c) 2020, Eisa AlAwadhi
-- License: BSD 2-Clause License

-- Creator: Eisa AlAwadhi
-- Project: SimpleUndo
-- Version: 2.5.1

local utils = require 'mp.utils'
local seconds = 0
local countTimer = 0
local previousUndoTime = 0
local undoTime = 0

local pause = false

mp.register_event('file-loaded', function()
	filePath = mp.get_property('path')

	timer = mp.add_periodic_timer(0.1, function()
		seconds = seconds + 0.1
	end)
	
	if (pause == true) then
		timer:stop()
	else
		timer:resume()
	end
	
	timer2 = mp.add_periodic_timer(0.1, function()
	
		countTimer = countTimer + 0.1
		
		if (countTimer == 0.6) then
			previousUndoTime = undoTime
			undoTime = math.floor(mp.get_property_number('time-pos'))
		
			if (pause == true) then
				seconds = seconds
			else
				seconds = seconds - 0.7
			end
			
			previousUndoTime = previousUndoTime + seconds
			seconds = 0
			
		end
		
	end)
	timer2:stop()
end)

mp.register_event('seek', function()
	timer2:resume()
	countTimer = 0
end)

mp.observe_property('pause', 'bool', function(name, value)
	if value then
		timer:stop()
		pause = true
	elseif timer then  -- otherwise we error on startup, likely because the property is observed as startup, but timer not yet set
		timer:resume()
		pause = false
	end
end)

mp.register_event('end-file', function()
	if timer ~= nil then
		timer:kill()
	end
	if timer2 ~= nil then
		timer2:kill()
	end
	previousUndoTime = 0
	undoTime = 0
	seconds = 0
	countTimer = 0
end)

local function undo()
	if (filePath ~= nil) and (countTimer > 0.5) then
	
		if (previousUndoTime < 0) then
			previousUndoTime = 0
		end
		
		mp.commandv('seek', previousUndoTime, 'absolute', 'exact')
		
		mp.osd_message('Undo')
	elseif (filePath ~= nil) and (countTimer > 0) and (countTimer < 0.6) then
		mp.osd_message('Seeking Still Running')
	elseif (filePath ~= nil) and (countTimer == 0) then
		mp.osd_message('No Undo Found')
	end
end


mp.add_key_binding("ctrl+z", "undo", undo)
mp.add_key_binding("ctrl+Z", "undoCaps", undo)
