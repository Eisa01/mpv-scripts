local utils = require 'mp.utils'
local seconds = 0
local undoTime = 0
local seekNumber = 0
local seekTable = {}

mp.register_event('file-loaded', function()
	filePath = mp.get_property('path')

	timer = mp.add_periodic_timer(1, function()
		seconds = seconds + 1
	end)
end)

mp.register_event('playback-restart', function()
	seconds = 0
	time = math.floor(mp.get_property_number('time-pos'))
	seconds = seconds + time
end)

mp.register_event('pause', function()
	timer:stop()
	time = math.floor(mp.get_property_number('time-pos'))
	seconds = time
end)

mp.register_event('unpause', function()
	timer:resume()
	time = math.floor(mp.get_property_number('time-pos'))
	seconds = time
end)

mp.register_event('seek', function()
	seekNumber = seekNumber + 1
	table.insert(seekTable, seekNumber, seconds)	
	undoTime = seekTable[seekNumber]
end)

mp.register_event('end-file', function()
	timer:kill()
end)

mp.add_key_binding("ctrl+z", "undo", function()
	if (filePath ~= nil) and (seekNumber > 0) then
		mp.commandv('seek', undoTime, 'absolute', 'exact')
		mp.osd_message('Undo Last Seek')
	elseif (filePath ~= nil) then
		mp.osd_message('No Undo Found')
	end
end)
