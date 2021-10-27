local o = {
----------------------------USER CUSTOMIZATION SETTINGS-----------------------------------
--These settings are for users to manually change some options.
--Changes are recommended to be made in the script-opts directory. It can also be made here although not recommended.

    -- Script Settings
    auto_run_idle = false, --Runs automatically when opening mpv and there is no video / file loaded. 
	bookmark_loads_last_idle = true, --When attempting to bookmark, if there is no video / file loaded, it will instead jump to your last bookmarked item
	slots_quicksave_fileonly = true, --When quick saving a bookmark to keybind slot, it will not save position
	slots_empty_auto_create = false, --If the keybind slot is empty, this enables quick bookmarking and adding to slot, Otherwise keybinds are assigned from the bookmark list or via quicksave.
	slots_empty_fileonly = true, --When auto creating slot, it will not save position.
	slots_auto_resume = true, --When loading a slot, it will auto resume to the bookmarked time.
    show_paths = false, --Show file paths instead of media-title
    resume_offset = -0.65, --change to 0 so that bookmark resumes from the exact position, or decrease the value so that it gives you a little preview before loading the resume point
    osd_messages = true, --true is for displaying osd messages when actions occur. Change to false will disable all osd messages generated from this script
    
    -- Logging Settings
    log_path = mp.find_config_file('.'):match('@?(.*/)'), --Change to debug.getinfo(1).source:match('@?(.*/)') for placing it in the same directory of script, OR change to mp.find_config_file('.'):match('@?(.*/)') for mpv portable_config directory OR specify the desired path in quotes, e.g.: 'C:\Users\Eisa01\Desktop\'
    log_file = 'mpvBookmark.log', --name+extension of the file that will be used to store the log data	
	date_format = '%d/%m/%y %X', --Date format in the log (see lua date formatting), e.g.:'%d/%m/%y %X' or '%d/%b/%y %X'
    bookmark_time_text = 'time=', --The text that is stored for the video time inside log file. It can also be left blank.
	keybind_slot_text = 'slot=', --The text that is stored for the keybind slot inside log file. It can also be left blank.
    file_title_logging = 'protocols', --Change between 'all', 'protocols, 'none'. This option will store the media title in log file, it is useful for websites / protocols because title cannot be parsed from links alone	
    protocols = { --add below (after a comma) any protocol you want its title to be stored in the log file. This is valid only for (file_title_logging = 'protocols')
        'https?://' ,'magnet:', 'rtmp:'
    },
    prefer_filename_over_title = 'local', --Prefers to use filename over filetitle. Select between 'local', 'protocols', 'all', and 'none'. 'local' prefer filenames for videos that are not protocols. 'protocols' will prefer filenames for protocols only. 'all' will prefer filename over filetitle for both protocols and not protocols videos. 'none' will always use filetitle instead of filename
	
    -- Boorkmark Menu Settings
    text_color = 'ffffff', --Text color for list in BGR hexadecimal
    text_scale = 50, --Font size for the text of bookmark list
    text_border = 0.7, --Black border size for the text of bookmark list
    highlight_color = 'ffbf7f', --Highlight color in BGR hexadecimal
    highlight_scale = 50, --Font size for highlighted text in bookmark list
    highlight_border = 0.7 , --Black border size for highlighted text in bookmark list
    header_text = '🔖 Bookmarks [%cursor/%total]', --Text to be shown as header for the bookmark list. %cursor shows the position of highlighted file. %total shows the total amount of bookmarked items.
	header_filter_text = ' (filtered: %filter)', --Text to be shown when applying filter after the header_text, %filter shows the filter name
    header_color = 'ffffaa', --Header color in BGR hexadecimal
    header_scale = 55, --Header text size for the bookmark list
    header_border = 0.8, --Black border size for the Header of bookmark list
    show_item_number = true, --Show the number of each bookmark item before displaying its name and values.
    slice_longfilenames = false, --Change to true or false. Slices long filenames per the amount specified below
    slice_longfilenames_amount = 55, --Amount for slicing long filenames
    time_seperator=' 🕒 ', --Time seperator that will be used after title / filename for bookmarked time
	slot_seperator=' ⌨ ', --Slot seperator that will be used after the bookmarked time
    list_show_amount = 10, --Change maximum number to show items at once
    list_sliced_prefix = '...\\h\\N\\N', --The text that indicates there are more items above. \\h\\N\\N is for new line.
    list_sliced_suffix = '...', --The text that indicates there are more items below.
	list_middle_loader = true, --False for more items to show, then u must reach the end. Change to true so that new items show after reaching the middle of list.
    -- Keybind Settings
    bookmark_list_keybind ={ 'b', 'B'}, --Keybind that will be used to display the bookmark list
    bookmark_save_keybind ={ 'ctrl+b', 'ctrl+B' }, --Keybind that will be used to save the video and its time to bookmark file
	bookmark_fileonly_keybind ={ 'alt+b', 'alt+B' }, --Keybind that will be used to save the video without time to bookmark file
	bookmark_slots_add_load_keybind={ 'alt+1', 'alt+2', 'alt+3', 'alt+4', 'alt+5', 'alt+6', 'alt+7', 'alt+8', 'alt+9' },--Keybind that will be used to bind a bookmark to a key. e.g.: Press alt+1 on a bookmark slot to assign it, press while list is hidden to load. A new slot is automatically created for each keybind.
	bookmark_slots_remove_keybind ={ 'alt+-', 'alt+_' }, --Keybind that is used to remove the highlighted bookmark slot keybind from a bookmark entry
	bookmark_slots_quicksave_keybind ={ 'alt+!', 'alt+@', 'alt+#', 'alt+$', 'alt+%', 'alt+^', 'alt+&', 'alt+*', 'alt+)' }, --ِTo save keybind to a slot without opening the bookmark list, to load these bookmarks it uses bookmark_slots_add_load_keybind
	list_filter_slots_keybind ={ 's', 'S'}, --Keybind to filter out the bookmarked slots
	slots_filter_outside_list = true, --Keybind to work even when outside bookmark list, this immediately opens the bookmark list and filters the keybind slots without having to open bookmark list first.
	--list_sort_slots_keybind = 's S', --Keybind to sort by the bookmarked slots first (confused between this and above or both)
    list_move_up_keybind ={ 'UP', 'WHEEL_UP' }, --Keybind that will be used to navigate up on the bookmark list
    list_move_down_keybind ={ 'DOWN', 'WHEEL_DOWN' }, --Keybind that will be used to navigate down on the bookmark list
    list_page_up_keybind ={ 'PGUP', 'LEFT' }, --Keybind that will be used to go to the first item for the page shown on the bookmark list
    list_page_down_keybind ={ 'PGDWN', 'RIGHT' }, --Keybind that will be used to go to the last item for the page shown on the bookmark list
    list_move_first_keybind ={ 'HOME' }, --Keybind that will be used to navigate to the first item on the bookmark list
    list_move_last_keybind ={ 'END' }, --Keybind that will be used to navigate to the last item on the bookmark list
    list_select_keybind ={ 'ENTER', 'MBTN_MID' }, --Keybind that will be used to load highlighted entry from the bookmark list
    list_close_keybind ={ 'ESC', 'MBTN_RIGHT' }, --Keybind that will be used to close the bookmark list
    list_delete_keybind ={ 'DEL' }, --Keybind that will be used to delete the highlighted entry from the bookmark list
    quickselect_0to9_keybind = true, --Keybind entries from 0 to 9 for quick selection when list is open (list_show_amount = 10 is maximum for this feature to work)	
---------------------------END OF USER CUSTOMIZATION SETTINGS---------------------
}
-- Copyright (c) 2021, Eisa AlAwadhi
-- License: BSD 2-Clause License

-- Creator: Eisa AlAwadhi
-- Project: SimpleBookmark
-- Version: 1.0

(require 'mp.options').read_options(o)
local utils = require 'mp.utils'
local msg = require 'mp.msg'
--1.0# global variables
local bookmark_log = o.log_path .. o.log_file
local selected = false --1.0# initiate the selected flag, defaults to false

local list_contents = {}
local list_start = 0
local list_cursor = 1
local list_drawn = false

local list_drawn_count = 0
local list_bookmark_first = false
local list_filter_first = false

local filePath, fileTitle, seekTime, filterName

local slotKeyIndex = 0

function starts_protocol (tab, val)
    for index, value in ipairs(tab) do
        if (val:find(value) == 1) then
            return true
        end
    end
    return false
end

function format_time(duration)
    local total_seconds = math.floor(duration)
    local hours = (math.floor(total_seconds / 3600))
    total_seconds = (total_seconds % 3600)
    local minutes = (math.floor(total_seconds / 60))
    local seconds = (total_seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds) 
end

function parse_header(string)
    return string:gsub("%%total", #list_contents)
                :gsub("%%cursor", list_cursor)
                -- undo name escape
                :gsub("%%%%", "%%")
end

function parse_header_filter(string)
	return string:gsub("%%filter", filterName)
			-- undo name escape
			:gsub("%%%%", "%%")
end

function bind_keys(keys, name, func, opts)
    if not keys then
		mp.add_forced_key_binding(keys, name, func, opts)
		return
    end
	
    for i=1, #keys do --1.02# changed to support arrays
		mp.add_forced_key_binding(keys[i], name..i, func, opts)
    end
end

function unbind_keys(keys, name)
    if not keys then
		mp.remove_key_binding(name)
		return
    end
	
	for i=1, #keys do --1.02# changed to support arrays
		mp.remove_key_binding(name..i)
    end
end

function list_move_up()
    select(-1)
end

function list_move_down()
    select(1)
end

function list_move_first()
    select(1-list_cursor)
end

function list_move_last()
    select(#list_contents-list_cursor)
end

function list_page_up()
    select(list_start+1 - list_cursor) --1.0# Go to the first seen entry
end

function list_page_down()
	if o.list_middle_loader then
		if #list_contents < o.list_show_amount then --1.01# If it is less than the show amount go to the last item
			select(#list_contents-list_cursor)
		else --1.01# Otherwise proceed like normal
			select(o.list_show_amount + list_start - list_cursor) --1.0# Move to the last shown entry
		end
	else
		if o.list_show_amount > list_cursor then--1.0# At the begining move to 10
			select(o.list_show_amount - list_cursor)
		elseif #list_contents-list_cursor >= o.list_show_amount then --1.0# If the remaining is larger or equal to page value then move the amount number
			select(o.list_show_amount)
		else --1.0# if the desired amount, does not exist just go to end
			select(#list_contents-list_cursor)
		end
	end
end

function list_select()
    load(list_cursor)
end

function list_delete()
    delete()
    get_list_contents()
    if not list_contents or not list_contents[1] then
        unbind()
        return
    end
	if list_cursor ~= #list_contents+1 then --1.0# needed if statement to specially handle the deleting last item
		select(0)
	else
		select(-1)
	end
end

function esc_string(str)
    return str:gsub("([%p])", "%%%1")
end

function get_path()
    local path = mp.get_property('path')
	local title = mp.get_property('media-title'):gsub("\"", "")
	
	if starts_protocol(o.protocols, path) and o.prefer_filename_over_title == 'protocols' then
		title = mp.get_property('filename'):gsub("\"", "")
	elseif not starts_protocol(o.protocols, path) and o.prefer_filename_over_title == 'local' then
		title = mp.get_property('filename'):gsub("\"", "")
	elseif o.prefer_filename_over_title == 'all' then
		title = mp.get_property('filename'):gsub("\"", "")
	end
	
    if not path then return end
    return path, title
end

function get_slot_keybind(keyindex) --1.02# function to return the keybind using the slotKeyIndex
	local keybind_return
	
	if o.bookmark_slots_add_load_keybind[keyindex] then
		keybind_return = o.bookmark_slots_add_load_keybind[keyindex]
	else
		keybind_return = o.keybind_slot_text..keyindex..' is NA'
	end
	
	return keybind_return
end

function unbind()
    unbind_keys(o.list_move_up_keybind, "move-up")
    unbind_keys(o.list_move_down_keybind, "move-down")
    unbind_keys(o.list_move_first_keybind, "move-first")
    unbind_keys(o.list_move_last_keybind, "move-last")
    unbind_keys(o.list_page_up_keybind, "page-up")
    unbind_keys(o.list_page_down_keybind, "page-down")
    unbind_keys(o.list_select_keybind, "list-select")
    unbind_keys(o.list_delete_keybind, "list-delete")
    unbind_keys(o.list_close_keybind, "list-close")
	if not o.slots_filter_outside_list then --1.03# only enable going to slots-list from outside the list, if enabled in settings
		unbind_keys(o.list_filter_slots_keybind, 'slots-list')
	end
	if o.quickselect_0to9_keybind and o.list_show_amount <= 10 then
		mp.remove_key_binding("recent-1")
		mp.remove_key_binding("recent-2")
		mp.remove_key_binding("recent-3")
		mp.remove_key_binding("recent-4")
		mp.remove_key_binding("recent-5")
		mp.remove_key_binding("recent-6")
		mp.remove_key_binding("recent-7")
		mp.remove_key_binding("recent-8")
		mp.remove_key_binding("recent-9")
		mp.remove_key_binding("recent-0")
	end	
    mp.set_osd_ass(0, 0, "")
    list_drawn = false
    list_cursor = 1
    list_start = 0
	filterName = nil
	list_drawn_count = 0
	list_bookmark_first = false
	list_filter_first = false	
end

function read_log(func)
    local f = io.open(bookmark_log, "r")
    if not f then return end
    list_contents = {}
    for line in f:lines() do
        table.insert(list_contents, (func(line)))
    end
    f:close()
    return list_contents
end

function read_log_table()
    return read_log(function(line)
        local p, t, s, d, n, e
        if line:match('^.-\"(.-)\"') then --#1.0 If there is a title, then match the parameters after title
            n, p = line:match('^.-\"(.-)\" | (.*) | '..esc_string(o.bookmark_time_text)..'(.*)') --#1.02 Get the name, and path updated to support slots
        else
            p = line:match('[(.*)%]]%s(.*) | '..esc_string(o.bookmark_time_text)..'(.*)') --1.0# Get the content thats square brackets and until time reached			
            d, n, e = p:match('^(.-)([^\\/]-)%.([^\\/%.]-)%.?$')--1.0# Finds directory, name, and extension (I only need name). I might need rest in the future
        end
		t = line:match(' | '..esc_string(o.bookmark_time_text)..'(%d*%.?%d*)(.*)$') --Get the time, also the rest in the next sequence, this is perfect as it works also if bookmark_time_text left blank
		s = line:match(' | .* | '..esc_string(o.keybind_slot_text)..'(.*)$')
        return {found_path = p, found_time = t, found_name = n, found_slot = s}
    end)
end

function get_list_contents()
	list_contents = read_log_table() --Gets list content and show error message if empty	
	if filterName == 'slots' then
		local filtered_table = {} -- create a new empty table
		for i=1, #list_contents do -- 1.01# Loop through list_contents, and if there is slot, then 
            if list_contents[i].found_slot then
				table.insert(filtered_table, list_contents[i])
			end
		end
		list_contents = filtered_table
	end
	
	if not list_contents or not list_contents[1] then
	
		local msg_text
		if filterName then
			msg_text = filterName.." in Bookmark Empty"
		else 
			msg_text = "Bookmark Empty"
		end
		
		msg.info(msg_text)
		if o.osd_messages == true then
			mp.osd_message(msg_text)
		end
		
		return
	end
end 

-- Write path to log on file end
-- removing duplicates along the way
function write_log(logged_time, keybind_slot)
    if not filePath then return end

	if logged_time then --If updating an entry or something, like adding keybind_slot then do not update seekTime 
		seekTime = logged_time
	else
		seekTime = (mp.get_property_number('time-pos') or 0)
	end
	
	if seekTime < 0 then seekTime = 0 end --Handle if time became negative or something
	delete_log_entry() --1.01#Call delete before adding, to remove duplicate entries (we need to use flag to round it, causes problems now, maybe in future, this is needed for keybind_slot also so it doesnt create it as duplicate)
	f = io.open(bookmark_log, "a+")
	if o.file_title_logging == 'all' then
		f:write(("[%s] \"%s\" | %s | %s"):format(os.date(o.date_format), fileTitle, filePath, o.bookmark_time_text..tostring(seekTime)))
	elseif o.file_title_logging == 'protocols' and (starts_protocol(o.protocols, filePath)) then
		f:write(("[%s] \"%s\" | %s | %s"):format(os.date(o.date_format), fileTitle, filePath, o.bookmark_time_text..tostring(seekTime)))
	elseif o.file_title_logging == 'protocols' and not (starts_protocol(o.protocols, filePath)) then
		f:write(("[%s] %s | %s"):format(os.date(o.date_format), filePath, o.bookmark_time_text..tostring(seekTime)))
	else
		f:write(("[%s] %s | %s"):format(os.date(o.date_format), filePath, o.bookmark_time_text..tostring(seekTime)))
	end
	if keybind_slot then
		f:write(' | '..o.keybind_slot_text..slotKeyIndex)
	end
	f:write('\n')
    f:close()
end

function delete_log_entry()
    local content = read_log(function(line)
        if line:find(esc_string(filePath)..'(.*)'..esc_string(o.bookmark_time_text)..seekTime) then --1.0# if it finds the filePath and the time, then do not bookmark it so we avoid duplicates (goes through the list and deletes duplicates by returning them as nil instead of line)
			return nil
        else
            return line
        end
    end)
	
    f = io.open(bookmark_log, "w+")
    if content then
        for i=1, #content do
            f:write(("%s\n"):format(content[i]))
        end
    end
	f:close()
end

function remove_slot_log_entry()
    local content = read_log(function(line)
        if line:match(' | .* | '..esc_string(o.keybind_slot_text)..slotKeyIndex) then --1.02# if it finds the current keyindex, then remove it from everywhere it found it.
			return line:match('(.* | '..esc_string(o.bookmark_time_text)..'%d*%.?%d*)(.*)$')--Get everything until time, the rest put it in the next sequence
        else
            return line
        end
    end)
	
    f = io.open(bookmark_log, "w+")
    if content then
        for i=1, #content do
            f:write(("%s\n"):format(content[i]))
        end
    end
	f:close()
end

function write_log_slot_entry()
	filePath = list_contents[#list_contents-list_cursor+1].found_path
	fileTitle = list_contents[#list_contents-list_cursor+1].found_name --1.02# to fix the title issue when it is logged
	seekTime = tonumber(list_contents[#list_contents-list_cursor+1].found_time)
	if not filePath or not fileTitle or not seekTime then
		msg.info("Failed to delete")
		return
	end
	remove_slot_log_entry() --Deletes old slot enty from log
	write_log(seekTime, true)
	get_list_contents()
	list_move_first()
	msg.info('Added Keybind:\n'..fileTitle..o.time_seperator..format_time(seekTime)..o.slot_seperator..get_slot_keybind(slotKeyIndex))
	filePath, fileTitle = get_path() --Revert filePath and fileTitle to current playing (fixes bug that bookmarks doesnt know whether to load or add bokmark)
end

function add_load_slot(key_index)
	if not key_index then return end --1.01# just in case something happened, only proceed if keybind was passed
	slotKeyIndex = key_index --1.02# receive the keyindex so that we get the current pressed key that will be added to the log

	if list_drawn then
		write_log_slot_entry()
    else
		local slot_taken = false --Need to create it so I can do a different action when keybind slot is not taken
		get_list_contents() --Get the contents of list
		for i=1, #list_contents do -- 1.01# Loop through and list_contents
            if tonumber(list_contents[i].found_slot) == slotKeyIndex then --1.02# If the pressed key_index is found then update the global variables
				filePath = list_contents[i].found_path
				fileTitle = list_contents[#list_contents-list_cursor+1].found_name				
				seekTime = tonumber(list_contents[i].found_time)
				slot_taken = true
				break --break loop if found, no need to continue
			end
        end
		if slot_taken then
			mp.commandv('loadfile', filePath) --Load the updated global variable
			if o.slots_auto_resume then --1.0# to only resume when a file is selected and option is enabled in user settings
				selected = true
			end
			if o.osd_messages == true then
				mp.osd_message('Loaded slot:'..o.slot_seperator..get_slot_keybind(slotKeyIndex)..'\n'..fileTitle..o.time_seperator..format_time(seekTime))
			end
			msg.info('Loaded slot:'..o.slot_seperator..get_slot_keybind(slotKeyIndex)..'\n'..fileTitle..o.time_seperator..format_time(seekTime))
		else
			if o.slots_empty_auto_create then -- Add bookmark point
				if filePath ~= nil then
					if o.slots_empty_fileonly then
						write_log(0, true)
					else
						write_log(false, true)
					end
					if o.osd_messages == true then
						mp.osd_message('Bookmarked & Added Keybind:\n'..fileTitle..o.time_seperator..format_time(seekTime)..o.slot_seperator..get_slot_keybind(slotKeyIndex))
					end
					msg.info('Bookmarked the below & added keybind:\n'..fileTitle..o.time_seperator..format_time(seekTime)..o.slot_seperator..get_slot_keybind(slotKeyIndex))
				else
					if o.osd_messages == true then
						mp.osd_message('Failed to Bookmark & Auto Create Keybind\nNo Video Found')
					end
					msg.info("Failed to bookmark & auto create keybind, no video found")
				end
			else
				if o.osd_messages == true then
					mp.osd_message('No Bookmark Slot For'..o.slot_seperator..get_slot_keybind(slotKeyIndex)..' Yet')
				end
				msg.info('No bookmark slot has been assigned for'..o.slot_seperator..get_slot_keybind(slotKeyIndex)..' keybind yet')
			end
		end
	end
	slotKeyIndex = 0 --revert slotKeyIndex
end

function quicksave_slot(key_index)
	if not key_index then return end --1.01# just in case something happened, only proceed if keybind was passed
	slotKeyIndex = key_index --1.02# receive the keyindex so that we get the current pressed key that will be added to the log

	if list_drawn then
		write_log_slot_entry()
    else
		if filePath ~= nil then
			if o.slots_quicksave_fileonly then
				write_log(0, true)
			else
				write_log(false, true)
			end
			if o.osd_messages == true then
				mp.osd_message('Bookmarked & Added Keybind:\n'..fileTitle..o.time_seperator..format_time(seekTime)..o.slot_seperator..get_slot_keybind(slotKeyIndex))
			end
			msg.info('Bookmarked the below & added keybind:\n'..fileTitle..o.time_seperator..format_time(seekTime)..o.slot_seperator..get_slot_keybind(slotKeyIndex))
		else
			if o.osd_messages == true then
				mp.osd_message('Failed to Bookmark & Auto Create Keybind\nNo Video Found')
			end
			msg.info("Failed to bookmark & auto create keybind, no video found")
		end
	end
	slotKeyIndex = 0 --revert slotKeyIndex
end

-- Display list on OSD and terminal
function draw_list()
    --1.0# font and color options for text, highlighted text, and header 
	local key = 0--for 0to9 quickselect
    local osd_msg = ''
    local osd_text = string.format("{\\fscx%f}{\\fscy%f}{\\bord%f}{\\1c&H%s}", o.text_scale, o.text_scale, o.text_border, o.text_color)
    local osd_highlight = string.format("{\\fscx%f}{\\fscy%f}{\\bord%f}{\\1c&H%s}", o.highlight_scale, o.highlight_scale, o.highlight_border, o.highlight_color)
    local osd_header = string.format("{\\fscx%f}{\\fscy%f}{\\bord%f}{\\1c&H%s}", o.header_scale, o.header_scale,o.header_border, o.header_color)
    local osd_msg_end = "{\\1c&HFFFFFF}"
	
    if o.header_text ~= '' then --1.0# 
        osd_msg = osd_msg..osd_header..parse_header(o.header_text)
		
		if filterName and o.header_filter_text ~= '' then
			osd_msg = osd_msg..parse_header_filter(o.header_filter_text)
		end
		
		osd_msg = osd_msg.."\\h\\N\\N"..osd_msg_end
    end
    
    local osd_key = ''--1.0#Parameters for optional stuff so that if the optional value is not defined, it wont append osd_key

    if o.list_middle_loader then --1.0# To start showing items from middle
		list_start = list_cursor - math.floor(o.list_show_amount/2)
	else --1.0# Else it will start showing after reaching the bottom
		list_start = list_cursor - o.list_show_amount
	end
    local showall = false
    local showrest = false
    if list_start<0 then list_start=0 end
    if #list_contents <= o.list_show_amount then
        list_start=0
        showall=true
    end
    if list_start > math.max(#list_contents-o.list_show_amount-1, 0) then
        list_start=#list_contents-o.list_show_amount
        showrest=true
    end
    if list_start > 0 and not showall then 
        osd_msg = osd_msg..o.list_sliced_prefix..osd_msg_end 
    end
    for i=list_start,list_start+o.list_show_amount-1,1 do
        if i == #list_contents then break end
        --1.0#My Stuff before outputting text
        if o.show_paths then
            p = list_contents[#list_contents-i].found_path or list_contents[#list_contents-i].found_name or ""
        else
            p = list_contents[#list_contents-i].found_name or list_contents[#list_contents-i].found_path or ""
        end

        if o.slice_longfilenames and p:len()>o.slice_longfilenames_amount then --1.0# slices long names as per setting
            p = p:sub(1, o.slice_longfilenames_amount).."..."
        end

        if o.quickselect_0to9_keybind and o.list_show_amount <= 10 then --1.0# Only show 0-9 keybinds if enabled
			key = 1 + key
			if key == 10 then key = 0 end
            osd_key = '('..key..')  '
        end

        if o.show_item_number then
            osd_index = (i+1)..'. '
        end
        --1.0# End of my Stuff before outputting text
        if i+1 == list_cursor then
			osd_msg = osd_msg..osd_highlight..osd_key..osd_index..p
        else
			osd_msg = osd_msg..osd_text..osd_key..osd_index..p
        end
		
		--Append time and slot if available
		if tonumber(list_contents[#list_contents-i].found_time) > 0 then
			osd_msg = osd_msg..o.time_seperator..format_time(list_contents[#list_contents-i].found_time)
		end
		
		if list_contents[#list_contents-i].found_slot then -- If a slot exists, then append keybind
			osd_msg = osd_msg..o.slot_seperator..get_slot_keybind(tonumber(list_contents[#list_contents-i].found_slot))
		end
		
		osd_msg = osd_msg..'\\h\\N\\N'..osd_msg_end
		
        if i == list_start+o.list_show_amount-1 and not showall and not showrest then
            osd_msg = osd_msg..o.list_sliced_suffix
        end
    end
    mp.set_osd_ass(0, 0, osd_msg)
end

-- Delete selected entry from the log
function delete()
    filePath = list_contents[#list_contents-list_cursor+1].found_path
	fileTitle = list_contents[#list_contents-list_cursor+1].found_name
    seekTime = tonumber(list_contents[#list_contents-list_cursor+1].found_time)
    if not filePath and not seekTime then
        msg.info("Failed to delete")
        return
    end
    delete_log_entry()
    msg.info("Deleted \""..filePath.."\" | "..format_time(seekTime))
    filePath, fileTitle = get_path()
end

--Removes keybind slot from the log
function list_slot_remove()
    slotKeyIndex = tonumber(list_contents[#list_contents-list_cursor+1].found_slot)
    if not slotKeyIndex then
        msg.info("Failed to remove")
        return
    end
    remove_slot_log_entry()
    msg.info('Removed Keybind: '..get_slot_keybind(slotKeyIndex))
end

-- Handle up/down keys
function select(pos)
	if not list_contents or not list_contents[1] then --If there is no content, then dont do select
        unbind()
        return
    end
	
    local list_cursor_temp = list_cursor + pos --1.0#Gets the cursor position
    if list_cursor_temp > 0 and list_cursor_temp <= #list_contents then 
        list_cursor = list_cursor_temp
    end
    draw_list()
end

-- Load file and remove binds
function load(list_cursor)
    unbind()
    seekTime = tonumber(list_contents[#list_contents-list_cursor+1].found_time) + o.resume_offset
    if (seekTime < 0) then
        seekTime = 0
    end
    mp.commandv('loadfile', list_contents[#list_contents-list_cursor+1].found_path)
    selected = true --1.0# to only resume when a file is selected
end

function bookmark_save()
    if filePath ~= nil then
        write_log(false, false)
		if list_drawn then
			get_list_contents()
			select(0)
		end
		if o.osd_messages == true then
			mp.osd_message('Bookmarked:\n'..fileTitle..o.time_seperator..format_time(seekTime))
		end
        msg.info('Added the below to bookmarks\n'..fileTitle..o.time_seperator..format_time(seekTime))
    elseif filePath == nil and o.bookmark_loads_last_idle then
		get_list_contents()
		load(1)
		if o.osd_messages == true then
			mp.osd_message('Loaded Last Bookmark File:\n'..list_contents[#list_contents].found_name..o.time_seperator..format_time(seekTime))
		end
		msg.info('Loaded the last bookmarked file shown below into mpv:\n'..list_contents[#list_contents].found_name..o.time_seperator..format_time(seekTime))
	else
        if o.osd_messages == true then
            mp.osd_message('Failed to Bookmark\nNo Video Found')
        end
        msg.info("Failed to bookmark, no video found")
    end
end

function bookmark_fileonly_save()
    if filePath ~= nil then
        write_log(0, false)
		if list_drawn then
			get_list_contents()
			select(0)
		end
		if o.osd_messages == true then
			mp.osd_message('Bookmarked File Only:\n'..fileTitle)
		end
        msg.info('Added the below to bookmarks\n'..fileTitle)
	elseif filePath == nil and o.bookmark_loads_last_idle then
		get_list_contents()
		load(1)
		if o.osd_messages == true then
			mp.osd_message('Loaded Last Bookmark File:\n'..list_contents[#list_contents].found_name..o.time_seperator..format_time(seekTime))
		end
		msg.info('Loaded the last bookmarked file shown below into mpv:\n'..list_contents[#list_contents].found_name..o.time_seperator..format_time(seekTime))
    else
        if o.osd_messages == true then
            mp.osd_message('Failed to Bookmark\nNo Video Found')
        end
        msg.info("Failed to bookmark, no video found")
    end
end

-- Display list and add keybinds
function display_list(filter)
	list_drawn_count = list_drawn_count + 1
	filterName = filter --Update global variable of filterName, it will remain nil, if filter is not passed
	
	if list_drawn_count == 1 and not filter then
		list_bookmark_first = true
	end
	
	if list_drawn_count == 1 and filter then
		list_filter_first = true
	end
	
	if list_drawn_count == 2 and not filter and list_bookmark_first then
		unbind()
		return
	end
	
	if list_drawn_count == 2 and filter and list_filter_first then
		unbind()
		return
	end
	
	if list_drawn_count == 3 and list_bookmark_first then --On the third press return to list bookmark list if we access through bookmark first
		list_bookmark_first = false 
		list_drawn_count = 0
		display_list()
		return
	end
	
	if list_drawn_count == 3 and list_filter_first and not filter then --On the third press return to list
		unbind()
		return
	end
	
	if list_drawn_count == 3 and list_filter_first and filter then --On the third press return to filter list list if we accessed through filter first
		list_filter_first = false
		list_drawn_count = 0
		display_list(filter)
		return
	end
	
	
	get_list_contents()
	if not list_contents or not list_contents[1] then
        unbind()
        return
    end
	
	draw_list()
    list_drawn = true
	
    bind_keys(o.list_move_up_keybind, "move-up", list_move_up, 'repeatable')
    bind_keys(o.list_move_down_keybind, "move-down", list_move_down, 'repeatable')
    bind_keys(o.list_move_first_keybind, "move-first", list_move_first, 'repeatable')
    bind_keys(o.list_move_last_keybind, "move-last", list_move_last, 'repeatable')
	bind_keys(o.list_page_up_keybind, "page-up", list_page_up, 'repeatable')
    bind_keys(o.list_page_down_keybind, "page-down", list_page_down, 'repeatable')
    bind_keys(o.list_select_keybind, "list-select", list_select)
    bind_keys(o.list_delete_keybind, "list-delete", list_delete)
    bind_keys(o.bookmark_slots_remove_keybind, "slot-remove", function() list_slot_remove() get_list_contents() select(0) end)
    bind_keys(o.list_close_keybind, "list-close", unbind)
	
	if not o.slots_filter_outside_list then --1.03# only enable going to slots-list from outside the list, if enabled in settings
		bind_keys(o.list_filter_slots_keybind, 'slots-list', function() display_list('slots') end)
	end
    if o.quickselect_0to9_keybind and o.list_show_amount <= 10 then --1.0# Only show 0-9 keybinds if enabled
        mp.add_forced_key_binding("1", "recent-1", function() load(list_start+1) end)
        mp.add_forced_key_binding("2", "recent-2", function() load(list_start+2) end)
        mp.add_forced_key_binding("3", "recent-3", function() load(list_start+3) end)
        mp.add_forced_key_binding("4", "recent-4", function() load(list_start+4) end)
        mp.add_forced_key_binding("5", "recent-5", function() load(list_start+5) end)
        mp.add_forced_key_binding("6", "recent-6", function() load(list_start+6) end)
        mp.add_forced_key_binding("7", "recent-7", function() load(list_start+7) end)
        mp.add_forced_key_binding("8", "recent-8", function() load(list_start+8) end)
        mp.add_forced_key_binding("9", "recent-9", function() load(list_start+9) end)
        mp.add_forced_key_binding("0", "recent-0", function() load(list_start+10) end)
    end
end

if o.auto_run_idle then
    mp.observe_property("idle-active", "bool", function(_, v)
        if v then display_list() end
    end)
end

mp.register_event("file-loaded", function()
    unbind()
    filePath, fileTitle = get_path()
    if (selected == true and seekTime ~= nil) then --1.0# After selecting bookmark, if there is seekTime then go to it
        mp.commandv('seek', seekTime, 'absolute', 'exact')
        selected = false --1.0# Reset the selected flag
    end
end)


bind_keys(o.bookmark_list_keybind, 'bookmark-list', display_list)
bind_keys(o.bookmark_save_keybind, 'bookmark-save', bookmark_save)
bind_keys(o.bookmark_fileonly_keybind, 'bookmark-fileonly', bookmark_fileonly_save)

if o.slots_filter_outside_list then --1.03# only enable going to slots-list from outside the list, if enabled in settings
	bind_keys(o.list_filter_slots_keybind, 'slots-list', function() display_list('slots') end)
end

for i=1, #o.bookmark_slots_add_load_keybind do --1.02#Finally a way to find my keypress, simply make a loop for all the keybinds, then send the keybind to the function
	mp.add_forced_key_binding(o.bookmark_slots_add_load_keybind[i], 'slot-'..i, function() add_load_slot(i) end)
end

for i=1, #o.bookmark_slots_quicksave_keybind do --1.02#Same as the above but to force keybinding a slot
	mp.add_forced_key_binding(o.bookmark_slots_quicksave_keybind[i], 'slot-save-'..i, function() quicksave_slot(i) end)
end
