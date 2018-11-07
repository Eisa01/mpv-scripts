local utils = require 'mp.utils'
local seconds = 0
local time = 0

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

mp.register_event('end-file', function()
	local historyLog = os.getenv('APPDATA')..'/mpv/mpvHistory.log'
	local historyLogAdd = io.open(historyLog, 'a+')
	
	if string.match(seconds, '-1') then
		seconds = 0
	else
		seconds = seconds
	end
	
	historyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), filePath..'&t='..tostring(seconds)))
	timer:kill()
	historyLogAdd:close()
end)

mp.add_key_binding("ctrl+r", "resume", function()
	local historyLog = os.getenv('APPDATA')..'/mpv/mpvHistory.log'
	local historyLogOpen = io.open(historyLog, 'r')
	local historyLogAdd = io.open(historyLog, 'a+')
	local filePath = mp.get_property('path')
	local linePosition
	local videoFound
	local currentVideo
	local currentVideoTime
	
	if (filePath ~= nil) then
		for line in historyLogOpen:lines() do
		   
		   linePosition = line:find(']')
		   line = line:sub(linePosition + 2)
		   
			if line.match(line, '(.*)&t=') == filePath then
				videoFound = line
			end
		   
		end
		
	if (videoFound ~= nil) then
		currentVideo = string.match(videoFound, '(.*)&t=')	
		currentVideoTime = string.match(videoFound, '&t=(.*)')

		if (filePath == currentVideo) and (currentVideoTime ~= nil) then
			mp.commandv('seek', currentVideoTime, 'absolute', 'exact')
			mp.osd_message('Resumed To Last Position')
		end
	else
		mp.osd_message('No Resume Position in This Video')
	end
	else
		local res = utils.subprocess({ args = {
        'powershell', '-NoProfile', '-Command', [[& {
		Trap {
                Write-Error -ErrorRecord $_
                Exit 1
            }
		Invoke-Item "$env:APPDATA\mpv\mpvHistory.log"
        }]]
    } })
		if not res.error then
			return res.stdout
		end
		return false
	end
	historyLogAdd:close()
	historyLogOpen:close()
end)

mp.add_key_binding("ctrl+l", "lastplay", function()
	local historyLog = os.getenv('APPDATA')..'/mpv/mpvHistory.log'
	local historyLogAdd = io.open(historyLog, 'a+')
	local historyLogOpen = io.open(historyLog, 'r+')
    local linePosition
	local videoFile

	for line in historyLogOpen:lines() do
		lastVideoFound = line
	end
	historyLogAdd:close()
	historyLogOpen:close()

	if (lastVideoFound ~= nil) then
		linePosition = lastVideoFound:find(']')
		lastVideoFound = lastVideoFound:sub(linePosition + 2)
		
		if string.match(lastVideoFound, '(.*)&t=') then
			videoFile = string.match(lastVideoFound, '(.*)&t=')
		else
			videoFile = lastVideoFound
		end
		
		if (filePath ~= nil) then
			mp.commandv('loadfile', videoFile, 'append-play')
			mp.osd_message('Added Last Video Into Playlist:\n'..videoFile)
		else
			mp.commandv('loadfile', videoFile)
			mp.osd_message('Opened Last Video From History:\n'..videoFile)
		end
	else
		mp.osd_message('No Video Found in History')
	end
end)
