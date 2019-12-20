-- Copyright (c) 2019, Eisa AlAwadhi
-- License: BSD 2-Clause License

-- Creator: Eisa AlAwadhi
-- Project: SmartHistory
-- Version: 1.5

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
	local historyLog = (os.getenv('APPDATA') or os.getenv('HOME')..'/.config')..'/mpv/mpvHistory.log'
	local historyLogAdd = io.open(historyLog, 'a+')
	
	if string.match(seconds, '-1') then
		seconds = 0
	else
		seconds = seconds
	end
	
	historyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), filePath..' |time='..tostring(seconds)))
	timer:kill()
	historyLogAdd:close()
end)

local function resume()
	local historyLog = (os.getenv('APPDATA') or os.getenv('HOME')..'/.config')..'/mpv/mpvHistory.log'
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
		   
			if line.match(line, '(.*) |time=') == filePath then
				videoFound = line
			end
		   
		end
		
	if (videoFound ~= nil) then
		currentVideo = string.match(videoFound, '(.*) |time=')
		currentVideoTime = string.match(videoFound, ' |time=(.*)')

		if (filePath == currentVideo) and (currentVideoTime ~= nil) then
			mp.commandv('seek', currentVideoTime, 'absolute', 'exact')
			mp.osd_message('Resumed To Last Position')
		end
	else
		mp.osd_message('No Resume Position')
	end
	else
		mp.osd_message('Failed to Resume\nNo Item Found')
	end
	historyLogAdd:close()
	historyLogOpen:close()
end

local function lastPlay()--1.3
	local historyLog = (os.getenv('APPDATA') or os.getenv('HOME')..'/.config')..'/mpv/mpvHistory.log'
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
		
		if string.match(lastVideoFound, '(.*) |time=') then
			videoFile = string.match(lastVideoFound, '(.*) |time=')
		else
			videoFile = lastVideoFound
		end
		
		if (filePath ~= nil) then
			mp.commandv('loadfile', videoFile, 'append-play')
			mp.osd_message('Added Last Item Into Playlist:\n'..videoFile)
		else
			mp.commandv('loadfile', videoFile)
			mp.osd_message('Loaded Last Item:\n'..videoFile)
		end
	else
		mp.osd_message('History is Empty')
	end
end


mp.add_key_binding("ctrl+r", "resume", resume)
mp.add_key_binding("ctrl+R", "resumeCaps", resume)

mp.add_key_binding("ctrl+l", "lastPlay", lastPlay)
mp.add_key_binding("ctrl+L", "lastPlayCaps", lastPlay)
