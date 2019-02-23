local utils = require 'mp.utils'
local videoTime = 0
local oldVideoTime = 0
local count = 0

mp.register_event('file-loaded', function()
	filePath = mp.get_property('path')

	timer = mp.add_periodic_timer(1, function()
		videoTime = videoTime + 1
	end)
end)

mp.register_event('playback-restart', function()
	oldVideoTime = videoTime
	
	count = count + 1
	videoTime = 0
	time = math.floor(mp.get_property_number('time-pos'))
	videoTime = videoTime + time
end)

mp.register_event('pause', function()
	timer:stop()
	time = math.floor(mp.get_property_number('time-pos'))
	videoTime = time
end)

mp.register_event('unpause', function()
	timer:resume()
	time = math.floor(mp.get_property_number('time-pos'))
	videoTime = time
end)

mp.register_event('end-file', function()
	timer:kill()
	count = 0
end)

mp.add_key_binding("ctrl+z", "undo", function()
	if (filePath ~= nil) and (count > 1) then
		mp.commandv('seek', oldVideoTime, 'absolute', 'exact')
		mp.osd_message('Undo Last Seek')
	elseif (filePath ~= nil) then
		mp.osd_message('No Undo Found')
	end
end)
