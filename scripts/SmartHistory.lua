-- Copyright (c) 2021, Eisa AlAwadhi
-- License: BSD 2-Clause License

-- Creator: Eisa AlAwadhi
-- Project: SmartHistory
-- Version: 1.7.1

local utils = require 'mp.utils'
local seconds = 0
local time = 0
local pause = false
local empty = false
local lastVideoTime

----------------------------USER CUSTOMIZATION SETTINGS-----------------------------------
--These settings are for users to manually change some options in the script.
--Keybinds can be defined in the bottom of the script.

local offset = -0.65 --change to 0 so that pasting resumes from the exact position, or decrease the value so that it gives you a little preview before reaching the exact pasted position

---------------------------END OF USER CUSTOMIZATION SETTINGS------------------------


mp.register_event('file-loaded', function()
	filePath = mp.get_property('path')

	timer = mp.add_periodic_timer(1, function()
		seconds = seconds + 1
	end)
	
	if (pause == true) then
		timer:stop()
	else
		timer:resume()
	end
	
	if (empty == true) then
		local seekTime
		if (lastVideoTime ~= nil) then
			
			seekTime = lastVideoTime + offset
			if (seekTime < 0) then
				seekTime = 0
			end
			
			mp.commandv('seek', seekTime, 'absolute', 'exact')
			
			empty = false
		end
	end
end)

mp.register_event('playback-restart', function()
	seconds = 0
	time = math.floor(mp.get_property_number('time-pos') or 0)
	seconds = seconds + time
end)

mp.observe_property('pause', 'bool', function(name, value)
	if value then
		if timer ~= nil then
			timer:stop()
		end
		time = math.floor(mp.get_property_number('time-pos') or 0)
		seconds = time
		pause = true
	else
		if timer ~= nil then
			timer:resume()
		end
		time = math.floor(mp.get_property_number('time-pos') or 0)
		seconds = time
		pause = false
	end
end)

mp.register_event('end-file', function()
	empty = false
	local historyLog = (os.getenv('APPDATA') or os.getenv('HOME')..'/.config')..'/mpv/mpvHistory.log'
	local historyLogAdd = io.open(historyLog, 'a+')
	
	if string.match(seconds, '-1') then
		seconds = 0
	else
		seconds = seconds
	end
	
	if (filePath ~= nil) then
		historyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), filePath..' |time='..tostring(seconds)))
		timer:kill()
		seconds = 0
		time = 0
		historyLogAdd:close()
	end
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
	local seekTime
	
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
			mp.osd_message('Resumed Last Position')
			
			seekTime = currentVideoTime + offset
			if (seekTime < 0) then
				seekTime = 0
			end
		
			mp.commandv('seek', seekTime, 'absolute', 'exact')
		end
	else
		mp.osd_message('No Resume Position')
	end
	else
		empty = true
		lastPlay()
	end
	historyLogAdd:close()
	historyLogOpen:close()
end

function lastPlay()
	local historyLog = (os.getenv('APPDATA') or os.getenv('HOME')..'/.config')..'/mpv/mpvHistory.log'
	local historyLogAdd = io.open(historyLog, 'a+')
	local historyLogOpen = io.open(historyLog, 'r+')
    local linePosition
	local videoFile
	local lastVideoFound

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
			lastVideoTime = string.match(lastVideoFound, ' |time=(.*)')
		else
			videoFile = lastVideoFound
		end
		
		if (filePath ~= nil) then
			mp.osd_message('Added Last Item Into Playlist:\n'..videoFile)
			mp.commandv('loadfile', videoFile, 'append-play')
		else
			if (empty == false) then
				mp.osd_message('Loaded Last Item:\n'..videoFile)
			else 
				mp.osd_message('Resumed Last Item:\n'..videoFile)
			end
			mp.commandv('loadfile', videoFile)
		end
	else
		mp.osd_message('History is Empty')
	end
end

---------------------------KEYBINDS CUSTOMIZATION SETTINGS---------------------------------

mp.add_key_binding("ctrl+r", "resume", resume)
mp.add_key_binding("ctrl+R", "resumeCaps", resume)

mp.add_key_binding("ctrl+l", "lastPlay", lastPlay)
mp.add_key_binding("ctrl+L", "lastPlayCaps", lastPlay)

---------------------END OF KEYBINDS CUSTOMIZATION SETTINGS---------------------------------
