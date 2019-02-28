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
	
	timer2 = mp.add_periodic_timer(0.1, function()--this does all the magic
		countTimer = countTimer + 0.1--this does all the magic #2 to make it detect seek-end event
		
	if countTimer > 0.5 and countTimer < 0.7 then--if almost a second passed then take time and do all of the below
		
		previousUndoTime = undoTime
	
		undoTime = math.floor(mp.get_property_number('time-pos')) --try to get the time when it is very close to one second
		
		seekNumber = 1 --no need for dynamic value anymore since there is no table
		if (undoTime ~= previousUndoTime) and (seekNumber > 0) then -- if there is undoTime which means if a end-seek event happened
			seconds = seconds - 0.4 -- since seeking is saved after almost a second of seeking (we will deduct 1 second for it to be accurate)
			previousUndoTime = previousUndoTime + seconds -- make it dynamic and include the seconds because the deduction in the next elseif will make us return to this value (NEW -- THIS WILL WORK MAKE IT WORK FOR THE FIRST UNDO BECAUSE IT WILL HAVE SECONDS)
			--table.insert(seekTable, seekNumber, previousUndoTime)--use the seconds to be in the first row as it is the videoTime without seek
			seconds = 0 --use seconds to append it later for new undo positions and reset it after adding to the table (needs reseting because the dynamic value keeps on adding after every seek)
		end
	end
		
	end)
	
	timer2:stop()--do not make timer2 work at the bginning only after seek
end)


mp.register_event('seek', function()--for now use seek even if it detects chapter(update it does not detect chapters! ^ ^)
	timer2:resume()--make timer 
	countTimer = 0 --reset counter to make it take the undotime again when it becomes above THIS does all the magic #2 to make it detect seek-end event keep reseting counter and detect when it does not
	 --if the seeking happened twice in less than a second dont count it as seek or. THIS if almost second passed after seeking then take time
end)

mp.register_event('pause', function()
	timer:stop()--to handle accurate video playtime
end)

mp.register_event('unpause', function()
	timer:resume()--to handle accurate video playtime
end)

mp.register_event('end-file', function()
	timer:kill()--reset timer on video end
	timer2:kill()--reset timer on video end
	seekNumber = 0--reset seek number on video end
	previousUndoTime = 0 --reset previous undotime
	undoTime = 0 --reset undo time
end)

mp.add_key_binding("ctrl+z", "undo", function()
	if (filePath ~= nil) and (seekNumber > 0) and (countTimer > 0.5) then--if seeknumber is more than 1 or equal it means there is undo position (added countTimer more than 5 so ctrl z only works when counter is after NEW seek is saved
		mp.commandv('seek', previousUndoTime, 'absolute', 'exact') --use the seektable for undo using the rules defined above
		mp.osd_message('Undo Last Seek')
	elseif (filePath ~= nil) and (seekNumber > 0) and (countTimer <= 0.5) then--it is seeking if the time is less than 5 or it is 5 just notify users as undo wont be available unless seeking is done
		mp.osd_message('Seeking Still Running')
	elseif (filePath ~= nil) and (seekNumber == 0) then
		mp.osd_message('No Undo Found')
	end
end)
