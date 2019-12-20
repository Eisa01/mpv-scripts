-- Copyright (c) 2019, Eisa AlAwadhi
-- License: BSD 2-Clause License

-- Creator: Eisa AlAwadhi
-- Project: SimpleUndo
-- Version: 2.5

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

mp.register_event('pause', function()
	timer:stop()
	pause = true
end)

mp.register_event('unpause', function()
	timer:resume()
	pause = false
end)

mp.register_event('end-file', function()
	timer:kill()
	timer2:kill()
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
