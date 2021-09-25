-- Copyright (c) 2021, Eisa AlAwadhi
-- License: BSD 2-Clause License

-- Creator: Eisa AlAwadhi
-- Project: SimpleUndo
-- Version: 3.2

local utils = require 'mp.utils'
local msg = require 'mp.msg'
local seconds = 0
local countTimer = -1
local previousUndoTime = 0
local undoTime = 0
local pause = false

----------------------------USER CUSTOMIZATION SETTINGS-----------------------------------
--These settings are for users to manually change some options in the script.
--Keybinds can be defined in the bottom of the script.

local osd_messages = true --true is for displaying osd messages when actions occur, Change to false will disable all osd messages generated from this script

---------------------------END OF USER CUSTOMIZATION SETTINGS---------------------

local function getUndo()
	previousUndoTime = undoTime
	undoTime = math.floor(mp.get_property_number('time-pos'))

	if (pause == true) then
		seconds = seconds
	else
		seconds = seconds - 0.5
	end

	previousUndoTime = previousUndoTime + seconds
	seconds = 0
end

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
			timer:resume()
			getUndo()
		end

	end)
	timer2:stop()
end)

mp.register_event('seek', function()
	countTimer = 0
	timer2:resume()
	timer:stop()
end)

mp.observe_property('pause', 'bool', function(name, value)
	if value then
		if timer ~= nil then
			timer:stop()
		end
		pause = true
	else
		if timer ~= nil then 
			timer:resume()
		end
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
	countTimer = -1
end)

local function undo()
	if (filePath ~= nil) and (countTimer >= 0) and (countTimer < 0.6) then
		timer2:stop()

		getUndo()

		if (previousUndoTime < 0) then
			previousUndoTime = 0
		end

		mp.commandv('seek', previousUndoTime, 'absolute', 'exact')
		if (osd_messages == true) then
			mp.osd_message('Undo')
		end
		msg.info('Seeked using undo')
	elseif (filePath ~= nil) and (countTimer > 0.5) then

		if (previousUndoTime < 0) then
			previousUndoTime = 0
		end

		mp.commandv('seek', previousUndoTime, 'absolute', 'exact')
		if (osd_messages == true) then
			mp.osd_message('Undo')
		end
		msg.info('Seeked using undo')
	elseif (filePath ~= nil) and (countTimer == -1) then
		if (osd_messages == true) then
			mp.osd_message('No Undo Found')
		end
		msg.info('No undo found')
	end
end

mp.add_key_binding("ctrl+z", "undo", undo)
mp.add_key_binding("ctrl+Z", "undoCaps", undo)
