local utils = require 'mp.utils'
local seconds = 0
local countTimer = 0
local previousUndoTime = 0
local undoTime = 0
local seekNumber = 0

mp.register_event('file-loaded', function()
	filePath = mp.get_property('path')

	timer = mp.add_periodic_timer(1, function()
		seconds = seconds + 1
	end)
	
	timer2 = mp.add_periodic_timer(0.1, function()
		countTimer = countTimer + 0.1
		
		if countTimer == 0.6 then
	
			previousUndoTime = undoTime
			undoTime = math.floor(mp.get_property_number('time-pos'))
		
			seekNumber = 1
		
			if (undoTime ~= previousUndoTime) and (seekNumber > 0) then
				seconds = seconds - 0.5 --almost decrease as the countTimer makes better for accuracy
				previousUndoTime = previousUndoTime + seconds
				seconds = 0
			end
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
end)

mp.register_event('unpause', function()
	timer:resume()
end)

mp.register_event('end-file', function()
	timer:kill()
	timer2:kill()
	seekNumber = 0
	previousUndoTime = 0
	undoTime = 0
end)

mp.add_key_binding("ctrl+z", "undo", function()
	if (filePath ~= nil) and (seekNumber > 0) and (countTimer > 0.5) then
		mp.commandv('seek', previousUndoTime, 'absolute', 'exact')
		mp.osd_message('Undo Last Seek')
	elseif (filePath ~= nil) and (seekNumber > 0) and (countTimer <= 0.5) then
		mp.osd_message('Seeking Still Running')
	elseif (filePath ~= nil) and (seekNumber == 0) then
		mp.osd_message('No Undo Found')
	end
end)
