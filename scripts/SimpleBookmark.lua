local o = {
---------------------------USER CUSTOMIZATION SETTINGS---------------------------
--These settings are for users to manually change some options.
--Changes are recommended to be made in the script-opts directory. It can also be made here although not recommended.

        -----Script Settings----
        auto_run_list_idle = 'none', --Runs automatically when opening mpv and there is no video / file loaded. You can choose between filters, such as, 'all' to display all the bookmarks, or 'slots' to display the bookmarks filtered with slots, or 'fileonly' to display files saved without time. Or 'timeonly' to display files that have time only. Or 'none' to keep it disabled.
        bookmark_loads_last_idle = true, --When attempting to bookmark, if there is no video / file loaded, it will instead jump to your last bookmarked item
        slots_quicksave_fileonly = true, --When quick saving a bookmark to keybind slot, it will not save position
        slots_empty_auto_create = false, --If the keybind slot is empty, this enables quick bookmarking and adding to slot, Otherwise keybinds are assigned from the bookmark list or via quicksave.
        slots_empty_fileonly = true, --When auto creating slot, it will not save position.
        slots_auto_resume = true, --When loading a slot, it will auto resume to the bookmarked time.
        show_paths = false, --Show file paths instead of media-title
        resume_offset = -0.65, --change to 0 so that bookmark resumes from the exact position, or decrease the value so that it gives you a little preview before loading the resume point
        osd_messages = true, --true is for displaying osd messages when actions occur. Change to false will disable all osd messages generated from this script
		loop_through_list = false, --true is for going up on the first item loops towards the last item and vise-versa. false disables this behavior.
		list_default_sort = 'added-asc', --the default sorting method for the bookmark list. select between 'added-asc', 'added-desc', 'alphanum-asc', 'alphanum-desc'
		mark_bookmark_as_chapter = false, --true is for marking the bookmarked time as a chapter. false disables mark as chapter behavior.
		--filter method description: 'added-asc' is for the newest added bookmark to show first, 'added-desc' for the newest added to show last. 'alphanum-asc' is for A to Z approach with filename and episode number lower first. 'alphanum-desc' is for its Z to A approach.
		
		-----Filter Settings------
		filters_and_sequence = {'all', 'slots', 'protocols', 'fileonly', 'titleonly', 'timeonly', 'keywords'}, --Jump to the following filters and in the shown sequence when navigating via left and right keys. You can change the sequence and delete filters that are not needed.
		keywords_filter_list = {'youtube.com', 'mp4', 'naruto', 'c:\\users\\eisa01\\desktop'}, --Create a filter out of your desired 'keywords', e.g.: youtube.com will filter out the videos from youtube. You can also insert a portion of filename or title, or extension or a full path / portion of a path.
		sort_slots_filter = 'keybind-asc', --Sorts the slots filter. Select between 'none', 'keybind-asc', keybind-desc', 'added-asc', 'added-desc', 'alphanum-asc', 'alphanum-desc'. description: 'none' is for default ordering. 'keybind-asc' is only for slots, it uses A to Z approach but for keybinds. 'keybind-desc' is the same but for Z to A approach.
		sort_fileonly_filter = 'alphanum-asc', --Sorts the fileonly filter. Select between 'none', 'added-asc', 'added-desc', 'alphanum-asc', 'alphanum-desc'.
		sort_protocols_filter = 'none',
		sort_titleonly_filter = 'none',
		sort_timeonly_filter = 'none',
		sort_keywords_filter = 'none',
		loop_through_filters = true, --true is for bypassing the last filter to go to first filter when navigating through filters using arrow keys, and vice-versa. false disables this behavior.
		
        -----Logging Settings-----
        log_path = mp.find_config_file('.'):match('@?(.*/)'), --Change to debug.getinfo(1).source:match('@?(.*/)') for placing it in the same directory of script, OR change to mp.find_config_file('.'):match('@?(.*/)') for mpv portable_config directory OR specify the desired path in quotes, e.g.: 'C:\Users\Eisa01\Desktop\'
        log_file = 'mpvBookmark.log', --name+extension of the file that will be used to store the log data
        date_format = '%d/%m/%y %X', --Date format in the log (see lua date formatting), e.g.:'%d/%m/%y %X' or '%d/%b/%y %X'
        bookmark_time_text = 'time=', --The text that is stored for the video time inside log file. It can also be left blank.
        keybind_slot_text = 'slot=', --The text that is stored for the keybind slot inside log file. It can also be left blank.
        file_title_logging = 'protocols', --Change between 'all', 'protocols, 'none'. This option will store the media title in log file, it is useful for websites / protocols because title cannot be parsed from links alone
        protocols = {'https?://', 'magnet:', 'rtmp:'}, --add below (after a comma) any protocol you want its title to be stored in the log file. This is valid only for (file_title_logging = 'protocols' or file_title_logging = 'all')
        prefer_filename_over_title = 'local', --Prefers to use filename over filetitle. Select between 'local', 'protocols', 'all', and 'none'. 'local' prefer filenames for videos that are not protocols. 'protocols' will prefer filenames for protocols only. 'all' will prefer filename over filetitle for both protocols and not protocols videos. 'none' will always use filetitle instead of filename
        
        -----Boorkmark Menu Settings-----
        text_color = 'ffffff', --Text color for list in BGR hexadecimal
        text_scale = 50, --Font size for the text of bookmark list
        text_border = 0.7, --Black border size for the text of bookmark list
        highlight_color = 'ffbf7f', --Highlight color in BGR hexadecimal
        highlight_scale = 50, --Font size for highlighted text in bookmark list
        highlight_border = 0.7, --Black border size for highlighted text in bookmark list
        header_text = '🔖 Bookmarks [%cursor/%total]', --Text to be shown as header for the bookmark list. %cursor shows the position of highlighted file. %total shows the total amount of bookmarked items.
        header_filter_text = ' (filtered: %filter)', --Text to be shown when applying filter after the header_text, %filter shows the filter name
        header_color = 'ffffaa', --Header color in BGR hexadecimal
        header_scale = 55, --Header text size for the bookmark list
        header_border = 0.8, --Black border size for the Header of bookmark list
        show_item_number = true, --Show the number of each bookmark item before displaying its name and values.
        slice_longfilenames = false, --Change to true or false. Slices long filenames per the amount specified below
        slice_longfilenames_amount = 55, --Amount for slicing long filenames
        time_seperator = ' 🕒 ', --Time seperator that will be used after title / filename for bookmarked time
        slot_seperator = ' ⌨ ', --Slot seperator that will be used after the bookmarked time
        list_show_amount = 10, --Change maximum number to show items at once
        list_sliced_prefix = '...\\h\\N\\N', --The text that indicates there are more items above. \\h\\N\\N is for new line.
        list_sliced_suffix = '...', --The text that indicates there are more items below.
        list_middle_loader = true, --false is for more items to show, then u must reach the end. true is for new items to show after reaching the middle of list.
        bookmark_list_keybind_twice_exits = true, --Will exit the bookmark list when double tapping the bookmark list, even if the list was accessed through a different filter.
        
        -----Keybind Settings-----
        bookmark_list_keybind = {'b', 'B'}, --Keybind that will be used to display the bookmark list
        bookmark_save_keybind = {'ctrl+b', 'ctrl+B'}, --Keybind that will be used to save the video and its time to bookmark file
        bookmark_fileonly_keybind = {'alt+b', 'alt+B'}, --Keybind that will be used to save the video without time to bookmark file
        bookmark_slots_add_load_keybind = {'alt+1', 'alt+2', 'alt+3', 'alt+4', 'alt+5', 'alt+6', 'alt+7', 'alt+8', 'alt+9'}, --Keybind that will be used to bind a bookmark to a key. e.g.: Press alt+1 on a bookmark slot to assign it when list is open, press while list is hidden to load. (A new slot is automatically created for each keybind. e.g: ..'alt+9, alt+0'. Where alt+0 creates a new 10th slot.)
        bookmark_slots_remove_keybind = {'alt+-', 'alt+_'}, --Keybind that is used to remove the highlighted bookmark slot keybind from a bookmark entry when the bookmark list is open.
        bookmark_slots_quicksave_keybind = {'alt+!', 'alt+@', 'alt+#', 'alt+$', 'alt+%', 'alt+^', 'alt+&', 'alt+*', 'alt+)'}, --To save keybind to a slot without opening the bookmark list, to load these bookmarks it uses bookmark_slots_add_load_keybind
        list_move_up_keybind = {'UP', 'WHEEL_UP'}, --Keybind that will be used to navigate up on the bookmark list
        list_move_down_keybind = {'DOWN', 'WHEEL_DOWN'}, --Keybind that will be used to navigate down on the bookmark list
        list_page_up_keybind = {'PGUP'}, --Keybind that will be used to go to the first item for the page shown on the bookmark list
        list_page_down_keybind = {'PGDWN'}, --Keybind that will be used to go to the last item for the page shown on the bookmark list
        list_move_first_keybind = {'HOME'}, --Keybind that will be used to navigate to the first item on the bookmark list
        list_move_last_keybind = {'END'}, --Keybind that will be used to navigate to the last item on the bookmark list
        list_select_keybind = {'ENTER', 'MBTN_MID'}, --Keybind that will be used to load highlighted entry from the bookmark list
        list_close_keybind = {'ESC', 'MBTN_RIGHT'}, --Keybind that will be used to close the bookmark list
        list_delete_keybind = {'DEL'}, --Keybind that will be used to delete the highlighted entry from the bookmark list
        quickselect_0to9_keybind = true, --Keybind entries from 0 to 9 for quick selection when list is open (list_show_amount = 10 is maximum for this feature to work)
        
		-----Filter Keybind Settings-----
		next_filter_sequence_keybind = {'RIGHT', 'MBTN_FORWARD'}, --Keybind that will be used to go to the next available filter based on the configured sequence
		previous_filter_sequence_keybind ={'LEFT', 'MBTN_BACK'}, --Keybind that will be used to go to the previous available filter based on the configured sequence
        list_filter_slots_keybind = {'s', 'S'}, --Keybind to jump to this specific filter
        slots_filter_outside_list = true, --False to access keybind only if bookmark list is open. true for Keybind to access filtered bookmark list immediately without needing to open bookmark list first. 
        list_filter_fileonly_keybind = {'f', 'F'},
        fileonly_filter_outside_list = false,
        list_filter_timeonly_keybind = {''},
        timeonly_filter_outside_list = false,
		list_filter_protocols_keybind = {''},
		protocols_filter_outside_list = false,
		list_filter_titleonly_keybind = {''},
		titleonly_filter_outside_list = false,
		list_filter_keywords_keybind = {''},
		keywords_filter_outside_list = false,

---------------------------END OF USER CUSTOMIZATION SETTINGS---------------------------
}
-- Copyright (c) 2021, Eisa AlAwadhi
-- License: BSD 2-Clause License
-- Creator: Eisa AlAwadhi
-- Project: SimpleBookmark
-- Version: 1.0

(require 'mp.options').read_options(o)
local utils = require 'mp.utils'
local msg = require 'mp.msg'

local bookmark_log = o.log_path .. o.log_file
local selected = false
local list_contents = {}
local list_start = 0
local list_cursor = 1
local list_drawn = false
local list_pages = {}
local filePath, fileTitle, seekTime
local filterName = 'all'

local slotKeyIndex = 0

function starts_protocol(tab, val)
    for index, value in ipairs(tab) do
        if (val:find(value) == 1) then
            return true
        end
    end
    return false
end

function contain_value (tab, val)
    for index, value in ipairs(tab) do
        if value.match(string.lower(val), string.lower(value)) then --if the value we will input has the specified keywords then catch it
            return true
        end
    end

    return false
end
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function mark_chapter() --Option to mark bookmarked time as chapter
	if not o.mark_bookmark_as_chapter then return end --only if the option is enabled then proceed
	
    local all_chapters = mp.get_property_native("chapter-list")
    local chapter_index = 0
	local chapters_time = {}
		
	get_list_contents()
	for i = 1, #list_contents do
		if list_contents[i].found_path == filePath and tonumber(list_contents[i].found_time) > 0 then --If the played file found in log and there is time stored then added it to table
			table.insert(chapters_time, tonumber(list_contents[i].found_time))
		end
    end
	if not chapters_time[1] then return end --Only if there are chapters then proceed
	
	--Sort chapters from lowest bookmarked time, to highest bookmarked time
	table.sort(chapters_time, function(a, b) return a < b end) --sorts so SimpleBookmark title is sequential
	
	for i = 1, #chapters_time do --For each chapter time found, mark it as a bookmark chapter
		chapter_index = chapter_index + 1 --Increase the current chapter count
		
		all_chapters[chapter_index] = { --Put inside all chapters where current chapter is the title and time of current chapter time
			title = 'SimpleBookmark '..chapter_index,
			time = chapters_time[i]
		}
	end
	
	--Sort chapters from lowest bookmarked time, to highest bookmarked time
	table.sort(all_chapters, function(a, b) return a['time'] < b['time'] end)
	
	--Update the chapters
    mp.set_property_native("chapter-list", all_chapters)
end


function list_sort(tab, sort) --function to sort the list, taking the table, and sort method
	
	if sort == 'added-desc' then
		table.sort(tab, function(a, b) return a['found_line'] > b['found_line'] end)
	elseif sort == 'keybind-asc' and filterName == 'slots' then --Add sorting for slots based on keybind slot
		table.sort(tab, function(a, b) return a['found_slot'] > b['found_slot'] end) --sorts founded_slot inside each table item by asc order
	elseif sort == 'keybind-desc' and filterName == 'slots' then
		table.sort(tab, function(a, b) return a['found_slot'] < b['found_slot'] end) --sorts founded_slot inside each table item by asc order
	elseif sort == 'alphanum-asc' or sort == 'alphanum-desc' then
		local function padnum(d) local dec, n = string.match(d, "(%.?)0*(.+)")
		return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n) end
		if sort == 'alphanum-asc' then --if sort is ascending lower first
			table.sort(tab, function(a,b) return tostring(a['found_path']):gsub("%.?%d+",padnum)..("%3d"):format(#b) > tostring(b['found_path']):gsub("%.?%d+",padnum)..("%3d"):format(#a) end)
		elseif sort == 'alphanum-desc' then --if sort is descending higher first
			table.sort(tab, function(a,b) return tostring(a['found_path']):gsub("%.?%d+",padnum)..("%3d"):format(#b) < tostring(b['found_path']):gsub("%.?%d+",padnum)..("%3d"):format(#a) end)
		end
	end
	
  return tab
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
    
    for i = 1, #keys do
        mp.add_forced_key_binding(keys[i], name .. i, func, opts)
    end
end

function unbind_keys(keys, name)
    if not keys then
        mp.remove_key_binding(name)
        return
    end
    
    for i = 1, #keys do
        mp.remove_key_binding(name .. i)
    end
end

function list_move_up()
    select(-1)
end

function list_move_down()
    select(1)
end

function list_move_first()
    select(1 - list_cursor)
end

function list_move_last()
    select(#list_contents - list_cursor)
end

function list_page_up()
    select(list_start + 1 - list_cursor)
end

function list_page_down()
    if o.list_middle_loader then
        if #list_contents < o.list_show_amount then
            select(#list_contents - list_cursor)
        else
            select(o.list_show_amount + list_start - list_cursor)
        end
    else
        if o.list_show_amount > list_cursor then
            select(o.list_show_amount - list_cursor)
        elseif #list_contents - list_cursor >= o.list_show_amount then
            select(o.list_show_amount)
        else
            select(#list_contents - list_cursor)
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
    if list_cursor ~= #list_contents + 1 then
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
	if not path then return end	--only proceed with function if it was able to get path, means a file is loaded (fixes idle crashes when assigning keybind)
    
	local title = mp.get_property('media-title'):gsub("\"", "")
	
    if starts_protocol(o.protocols, path) and o.prefer_filename_over_title == 'protocols' then
        title = mp.get_property('filename'):gsub("\"", "")
    elseif not starts_protocol(o.protocols, path) and o.prefer_filename_over_title == 'local' then
        title = mp.get_property('filename'):gsub("\"", "")
    elseif o.prefer_filename_over_title == 'all' then
        title = mp.get_property('filename'):gsub("\"", "")
    end
    
    return path, title
end

function get_slot_keybind(keyindex)
    local keybind_return
    
    if o.bookmark_slots_add_load_keybind[keyindex] then
        keybind_return = o.bookmark_slots_add_load_keybind[keyindex]
    else
        keybind_return = o.keybind_slot_text .. keyindex .. ' is NA'
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
    unbind_keys(o.bookmark_slots_remove_keybind, "slot-remove")
	unbind_keys(o.next_filter_sequence_keybind, 'list-filter-next')
	unbind_keys(o.previous_filter_sequence_keybind, 'list-filter-previous')

    if not o.quickselect_0to9_keybind and o.list_show_amount <= 10 then
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
	
	if not o.slots_filter_outside_list then
        unbind_keys(o.list_filter_slots_keybind, 'slots-list')
    end
    if not o.fileonly_filter_outside_list then
        unbind_keys(o.list_filter_fileonly_keybind, 'fileonly-list')
    end
    if not o.timeonly_filter_outside_list then
        unbind_keys(o.list_filter_timeonly_keybind, 'timeonly-list')
    end
	if not o.protocols_filter_outside_list then
		unbind_keys(o.list_filter_protocols_keybind, 'protocols-list')
	end
	if not o.titleonly_filter_outside_list then
		unbind_keys(o.list_filter_titleonly_keybind, 'titleonly-list')
	end
	if not o.keywords_filter_outside_list then
		unbind_keys(o.list_filter_keywords_keybind, 'keywords-list')
	end
	
    mp.set_osd_ass(0, 0, "")
    list_drawn = false
    list_cursor = 1
    list_start = 0
    filterName = 'all'
    list_pages = {}
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
        local tt, p, t, s, d, n, e, l
        if line:match('^.-\"(.-)\"') then --#1.0 If there is a title, then match the parameters after title
			tt = line:match('^.-\"(.-)\"') --To get the title of the file
            n, p = line:match('^.-\"(.-)\" | (.*) | ' .. esc_string(o.bookmark_time_text) .. '(.*)')
        else
            p = line:match('[(.*)%]]%s(.*) | ' .. esc_string(o.bookmark_time_text) .. '(.*)')
            d, n, e = p:match('^(.-)([^\\/]-)%.([^\\/%.]-)%.?$')
        end
        t = line:match(' | ' .. esc_string(o.bookmark_time_text) .. '(%d*%.?%d*)(.*)$')
        s = line:match(' | .* | ' .. esc_string(o.keybind_slot_text) .. '(.*)$')
		l = line
        return {found_path = p, found_time = t, found_name = n, found_slot = s, found_title = tt, found_line = l}
    end)
end

function get_list_contents(filter)
	if not filter then filter = filterName end --If no filter is passed then use the global filterName variable
	
    list_contents = read_log_table()
	if o.list_default_sort ~= 'added-asc' or o.list_default_sort ~= 'none' or o.list_default_sort ~= '' then --If it was not added-asc, or empty or none. Then do sorting for it based on what is passed.
		list_sort(list_contents, o.list_default_sort)
	end
	
    local filtered_table = {}
    
    if filter == 'slots' then
        for i = 1, #list_contents do
            if list_contents[i].found_slot then
                table.insert(filtered_table, list_contents[i])
            end
        end
		
		if o.sort_slots_filter ~= 'added-asc' or o.sort_slots_filter ~= 'none' or o.sort_slots_filter ~= '' then --add sorting for slots if it was defined
			list_sort(filtered_table, o.sort_slots_filter)
		end
		
        list_contents = filtered_table
    end
    if filter == 'fileonly' then
        for i = 1, #list_contents do
            if tonumber(list_contents[i].found_time) == 0 then
                table.insert(filtered_table, list_contents[i])
            end
        end
		
		if o.sort_fileonly_filter ~= 'added-asc' or o.sort_fileonly_filter ~= 'none' or o.sort_fileonly_filter ~= '' then --add sorting if it was defined
			list_sort(filtered_table, o.sort_fileonly_filter)
		end
		
        list_contents = filtered_table
    end
    if filter == 'timeonly' then
        for i = 1, #list_contents do
            if tonumber(list_contents[i].found_time) > 0 then
                table.insert(filtered_table, list_contents[i])
            end
        end
		
		if o.sort_timeonly_filter ~= 'added-asc' or o.sort_timeonly_filter ~= 'none' or o.sort_timeonly_filter ~= '' then --add sorting if it was defined
			list_sort(filtered_table, o.sort_timeonly_filter)
		end
		
        list_contents = filtered_table
    end
	if filter == 'titleonly' then
		for i = 1, #list_contents do
            if list_contents[i].found_title then
                table.insert(filtered_table, list_contents[i])
            end
        end
		
		if o.sort_titleonly_filter ~= 'added-asc' or o.sort_titleonly_filter ~= 'none' or o.sort_titleonly_filter ~= '' then --add sorting if it was defined
			list_sort(filtered_table, o.sort_titleonly_filter)
		end
		
        list_contents = filtered_table
    end
	
	if filter == 'protocols' then
		for i = 1, #list_contents do
            if starts_protocol(o.protocols, list_contents[i].found_path) then --changed so filtering protocols is done here, instead of when reading table lines
                table.insert(filtered_table, list_contents[i])
            end
        end
		
		if o.sort_protocols_filter ~= 'added-asc' or o.sort_protocols_filter ~= 'none' or o.sort_protocols_filter ~= '' then --add sorting if it was defined
			list_sort(filtered_table, o.sort_protocols_filter)
		end
		
        list_contents = filtered_table
    end
	
	if filter == 'keywords' then --Keywords filter based on the user defined keywords
		for i = 1, #list_contents do
            if contain_value(o.keywords_filter_list, list_contents[i].found_line) then --used found_line as there could be title or full path
                table.insert(filtered_table, list_contents[i])
            end
        end
		
		if o.sort_keywords_filter ~= 'added-asc' or o.sort_keywords_filter ~= 'none' or o.sort_keywords_filter ~= '' then --add sorting if it was defined
			list_sort(filtered_table, o.sort_keywords_filter)
		end
		
        list_contents = filtered_table
    end
    
    if not list_contents or not list_contents[1] then
        
        local msg_text
        if filter ~= 'all' then
            msg_text = filter .. " in Bookmark Empty"
        else
            msg_text = "Bookmark Empty"
        end
        msg.info(msg_text)
        if o.osd_messages == true and not list_drawn then
            mp.osd_message(msg_text)
        end
        
        return
    end
end

function write_log(logged_time, keybind_slot)
    if not filePath then return end
        
	if logged_time then
        seekTime = logged_time
    else
        seekTime = (mp.get_property_number('time-pos') or 0)
    end
    
    if seekTime < 0 then seekTime = 0 end
    delete_log_entry()
    if keybind_slot then
        remove_slot_log_entry()
    end
    f = io.open(bookmark_log, "a+")
    if o.file_title_logging == 'all' then
        f:write(("[%s] \"%s\" | %s | %s"):format(os.date(o.date_format), fileTitle, filePath, o.bookmark_time_text .. tostring(seekTime)))
    elseif o.file_title_logging == 'protocols' and (starts_protocol(o.protocols, filePath)) then
        f:write(("[%s] \"%s\" | %s | %s"):format(os.date(o.date_format), fileTitle, filePath, o.bookmark_time_text .. tostring(seekTime)))
    elseif o.file_title_logging == 'protocols' and not (starts_protocol(o.protocols, filePath)) then
        f:write(("[%s] %s | %s"):format(os.date(o.date_format), filePath, o.bookmark_time_text .. tostring(seekTime)))
    else
        f:write(("[%s] %s | %s"):format(os.date(o.date_format), filePath, o.bookmark_time_text .. tostring(seekTime)))
    end
    if keybind_slot then
        f:write(' | ' .. o.keybind_slot_text .. slotKeyIndex)
    end
    f:write('\n')
    f:close()
end

function delete_log_entry()
    local content = read_log(function(line)
        if line:find(esc_string(filePath) .. '(.*)' .. esc_string(o.bookmark_time_text) .. seekTime) then
            return nil
        else
            return line
        end
    end)
    
    f = io.open(bookmark_log, "w+")
    if content then
        for i = 1, #content do
            f:write(("%s\n"):format(content[i]))
        end
    end
    f:close()
end

function remove_slot_log_entry()
    local content = read_log(function(line)
        if line:match(' | .* | ' .. esc_string(o.keybind_slot_text) .. slotKeyIndex) then
            return line:match('(.* | ' .. esc_string(o.bookmark_time_text) .. '%d*%.?%d*)(.*)$')
        else
            return line
        end
    end)
    
    f = io.open(bookmark_log, "w+")
    if content then
        for i = 1, #content do
            f:write(("%s\n"):format(content[i]))
        end
    end
    f:close()
end

function write_log_slot_entry()
    filePath = list_contents[#list_contents - list_cursor + 1].found_path
    fileTitle = list_contents[#list_contents - list_cursor + 1].found_name
    seekTime = tonumber(list_contents[#list_contents - list_cursor + 1].found_time)
    if not filePath or not fileTitle or not seekTime then
        msg.info("Failed to delete")
        return
    end
    write_log(seekTime, true)
    get_list_contents()
    list_move_first()
    msg.info('Added Keybind:\n' .. fileTitle .. o.time_seperator .. format_time(seekTime) .. o.slot_seperator .. get_slot_keybind(slotKeyIndex))
    filePath, fileTitle = get_path()
end

function add_load_slot(key_index)
    if not key_index then return end
    slotKeyIndex = key_index
    
    if list_drawn then
        write_log_slot_entry()
    else
        local slot_taken = false
        get_list_contents()
        for i = 1, #list_contents do
            if tonumber(list_contents[i].found_slot) == slotKeyIndex then
                filePath = list_contents[i].found_path
                fileTitle = list_contents[#list_contents - list_cursor + 1].found_name
                seekTime = tonumber(list_contents[i].found_time)
                slot_taken = true
                break
            end
        end
        if slot_taken then
            mp.commandv('loadfile', filePath)
            if o.slots_auto_resume then
                selected = true
            end
            if o.osd_messages == true then
                mp.osd_message('Loaded slot:' .. o.slot_seperator .. get_slot_keybind(slotKeyIndex) .. '\n' .. fileTitle .. o.time_seperator .. format_time(seekTime))
            end
            msg.info('Loaded slot:' .. o.slot_seperator .. get_slot_keybind(slotKeyIndex) .. '\n' .. fileTitle .. o.time_seperator .. format_time(seekTime))
        else
            if o.slots_empty_auto_create then
                if filePath ~= nil then
                    if o.slots_empty_fileonly then
                        write_log(0, true)
                    else
                        write_log(false, true)
                    end
                    if o.osd_messages == true then
                        mp.osd_message('Bookmarked & Added Keybind:\n' .. fileTitle .. o.time_seperator .. format_time(seekTime) .. o.slot_seperator .. get_slot_keybind(slotKeyIndex))
                    end
                    msg.info('Bookmarked the below & added keybind:\n' .. fileTitle .. o.time_seperator .. format_time(seekTime) .. o.slot_seperator .. get_slot_keybind(slotKeyIndex))
                else
                    if o.osd_messages == true then
                        mp.osd_message('Failed to Bookmark & Auto Create Keybind\nNo Video Found')
                    end
                    msg.info("Failed to bookmark & auto create keybind, no video found")
                end
            else
                if o.osd_messages == true then
                    mp.osd_message('No Bookmark Slot For' .. o.slot_seperator .. get_slot_keybind(slotKeyIndex) .. ' Yet')
                end
                msg.info('No bookmark slot has been assigned for' .. o.slot_seperator .. get_slot_keybind(slotKeyIndex) .. ' keybind yet')
            end
        end
    end
    slotKeyIndex = 0
end

function quicksave_slot(key_index)
    if not key_index then return end
    slotKeyIndex = key_index
    
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
                mp.osd_message('Bookmarked & Added Keybind:\n' .. fileTitle .. o.time_seperator .. format_time(seekTime) .. o.slot_seperator .. get_slot_keybind(slotKeyIndex))
            end
            msg.info('Bookmarked the below & added keybind:\n' .. fileTitle .. o.time_seperator .. format_time(seekTime) .. o.slot_seperator .. get_slot_keybind(slotKeyIndex))
        else
            if o.osd_messages == true then
                mp.osd_message('Failed to Bookmark & Auto Create Keybind\nNo Video Found')
            end
            msg.info("Failed to bookmark & auto create keybind, no video found")
        end
    end
    slotKeyIndex = 0
end

function draw_list()
    local osd_msg = ''
	local osd_index = ''	
	local osd_key = ''
	local key = 0
    local osd_text = string.format("{\\fscx%f}{\\fscy%f}{\\bord%f}{\\1c&H%s}", o.text_scale, o.text_scale, o.text_border, o.text_color)
    local osd_highlight = string.format("{\\fscx%f}{\\fscy%f}{\\bord%f}{\\1c&H%s}", o.highlight_scale, o.highlight_scale, o.highlight_border, o.highlight_color)
    local osd_header = string.format("{\\fscx%f}{\\fscy%f}{\\bord%f}{\\1c&H%s}", o.header_scale, o.header_scale, o.header_border, o.header_color)
    local osd_msg_end = "{\\1c&HFFFFFF}"
    
    if o.header_text ~= '' then
        osd_msg = osd_msg .. osd_header .. parse_header(o.header_text)
        
        if filterName ~= 'all' and o.header_filter_text ~= '' then
            osd_msg = osd_msg .. parse_header_filter(o.header_filter_text)
        end
        
        osd_msg = osd_msg .. "\\h\\N\\N" .. osd_msg_end
    end
    
    if o.list_middle_loader then
        list_start = list_cursor - math.floor(o.list_show_amount / 2)
    else
        list_start = list_cursor - o.list_show_amount
    end
	
    local showall = false
    local showrest = false
    if list_start < 0 then list_start = 0 end
    if #list_contents <= o.list_show_amount then
        list_start = 0
        showall = true
    end
    if list_start > math.max(#list_contents - o.list_show_amount - 1, 0) then
        list_start = #list_contents - o.list_show_amount
        showrest = true
    end
    if list_start > 0 and not showall then
        osd_msg = osd_msg .. o.list_sliced_prefix .. osd_msg_end
    end
    for i = list_start, list_start + o.list_show_amount - 1, 1 do
        if i == #list_contents then break end
        
        if o.show_paths then
            p = list_contents[#list_contents - i].found_path or list_contents[#list_contents - i].found_name or ""
        else
            p = list_contents[#list_contents - i].found_name or list_contents[#list_contents - i].found_path or ""
        end
        
        if o.slice_longfilenames and p:len() > o.slice_longfilenames_amount then
            p = p:sub(1, o.slice_longfilenames_amount) .. "..."
        end
        
        if o.quickselect_0to9_keybind and o.list_show_amount <= 10 then
            key = 1 + key
            if key == 10 then key = 0 end
            osd_key = '(' .. key .. ')  '
        end
        
        if o.show_item_number then
            osd_index = (i + 1) .. '. '
        end
        
        if i + 1 == list_cursor then
            osd_msg = osd_msg .. osd_highlight .. osd_key .. osd_index .. p
        else
            osd_msg = osd_msg .. osd_text .. osd_key .. osd_index .. p
        end
        
        if tonumber(list_contents[#list_contents - i].found_time) > 0 then
            osd_msg = osd_msg .. o.time_seperator .. format_time(list_contents[#list_contents - i].found_time)
        end
        
        if list_contents[#list_contents - i].found_slot then
            osd_msg = osd_msg .. o.slot_seperator .. get_slot_keybind(tonumber(list_contents[#list_contents - i].found_slot))
        end
        
        osd_msg = osd_msg .. '\\h\\N\\N' .. osd_msg_end

        if i == list_start + o.list_show_amount - 1 and not showall and not showrest then
            osd_msg = osd_msg .. o.list_sliced_suffix
        end
		
    end
    mp.set_osd_ass(0, 0, osd_msg)
end

function delete()
    filePath = list_contents[#list_contents - list_cursor + 1].found_path
    fileTitle = list_contents[#list_contents - list_cursor + 1].found_name
    seekTime = tonumber(list_contents[#list_contents - list_cursor + 1].found_time)
    if not filePath and not seekTime then
        msg.info("Failed to delete")
        return
    end
    delete_log_entry()
    msg.info("Deleted \"" .. filePath .. "\" | " .. format_time(seekTime))
    filePath, fileTitle = get_path()
end

function list_slot_remove()
    if not list_drawn then return end
    slotKeyIndex = tonumber(list_contents[#list_contents - list_cursor + 1].found_slot)
    if not slotKeyIndex then
        msg.info("Failed to remove")
        return
    end
    remove_slot_log_entry()
    msg.info('Removed Keybind: ' .. get_slot_keybind(slotKeyIndex))
end

function select(pos)
    if not list_contents or not list_contents[1] then
        unbind()
        return
    end
    
    local list_cursor_temp = list_cursor + pos
    if list_cursor_temp > 0 and list_cursor_temp <= #list_contents then
        list_cursor = list_cursor_temp
    end
	
	if o.loop_through_list then --If loop through filters is enabled, then do the following
		if list_cursor_temp > #list_contents then --If we are attempting to bypass the amount of list_contents then go to the first item
			list_cursor = 1
		elseif list_cursor_temp < 1 then --If we are attempting to go less than the first item, then go to list_contents amount which is the last item
			list_cursor = #list_contents
		end
	end
	
    draw_list()
end

function select_filter_sequence(pos)
	if not list_drawn then return end
	local curr_pos
	local target_pos
	
	for i=1, #o.filters_and_sequence do
		if filterName == o.filters_and_sequence[i] then --Get the current position from the filters array, and based on position move next or back
			curr_pos = i
		end
	end
	--Code to ignore the empty filters and proceed to the next available filter
	if curr_pos and pos >-1 then --If giving a positive number, then the position need to step up
		for i=curr_pos, #o.filters_and_sequence do
			get_list_contents(o.filters_and_sequence[i+pos]) --Check if the target position list is empty starting from current position until the end of filter list
			if list_contents[1] then -- If it found target position then we can set it for target_pos and break loop, otherwise target_pos will remain nile
				target_pos = i+pos
				break
			end
		end
	elseif curr_pos and pos < 0 then --If giving a negative number, then the position will need to be decreased
		for i=curr_pos, 0, -1 do
			get_list_contents(o.filters_and_sequence[i+pos]) --Check if the target position list is empty starting from current position until the end of filter list
			if list_contents[1] then -- If it found target position then we can set it for target_pos and break loop, otherwise target_pos will remain nile
				target_pos = i+pos
				break
			end
		end
	end
	--End of ignore the empty filters
	
	--Code to handle reaching the end, either to loop or to stop
		if target_pos then 
			if not o.loop_through_filters then --Makes 
				if target_pos > #o.filters_and_sequence then return end --If target attempts to exceed the filter count then stop
				if target_pos < 1 then return end --If target attempts to be less than the count then stop
			else
				if target_pos > #o.filters_and_sequence then target_pos = 1 end -- If target attempts to exceed then start from the begining
				if target_pos < 1 then target_pos = #o.filters_and_sequence end -- If targets attempts to be less than the count then start from the end
			end
			display_list(o.filters_and_sequence[target_pos])
		end
	--End of handle reaching the end
end

function list_filter_next()
	select_filter_sequence(1)
end
function list_filter_previous()
	select_filter_sequence(-1)
end

function load(list_cursor)
    unbind()
    seekTime = tonumber(list_contents[#list_contents - list_cursor + 1].found_time) + o.resume_offset
    if (seekTime < 0) then
        seekTime = 0
    end
    mp.commandv('loadfile', list_contents[#list_contents - list_cursor + 1].found_path)
    selected = true
end

function bookmark_save()
    if filePath ~= nil then
        write_log(false, false)
        if list_drawn then
            get_list_contents()
            select(0)
        end
        if o.osd_messages == true then
            mp.osd_message('Bookmarked:\n' .. fileTitle .. o.time_seperator .. format_time(seekTime))
        end
        msg.info('Added the below to bookmarks\n' .. fileTitle .. o.time_seperator .. format_time(seekTime))
    elseif filePath == nil and o.bookmark_loads_last_idle then
        get_list_contents()
        load(1)
        if o.osd_messages == true then
            mp.osd_message('Loaded Last Bookmark File:\n' .. list_contents[#list_contents].found_name .. o.time_seperator .. format_time(seekTime))
        end
        msg.info('Loaded the last bookmarked file shown below into mpv:\n' .. list_contents[#list_contents].found_name .. o.time_seperator .. format_time(seekTime))
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
            mp.osd_message('Bookmarked File Only:\n' .. fileTitle)
        end
        msg.info('Added the below to bookmarks\n' .. fileTitle)
    elseif filePath == nil and o.bookmark_loads_last_idle then
        get_list_contents()
        load(1)
        if o.osd_messages == true then
            mp.osd_message('Loaded Last Bookmark File:\n' .. list_contents[#list_contents].found_name .. o.time_seperator .. format_time(seekTime))
        end
        msg.info('Loaded the last bookmarked file shown below into mpv:\n' .. list_contents[#list_contents].found_name .. o.time_seperator .. format_time(seekTime))
    else
        if o.osd_messages == true then
            mp.osd_message('Failed to Bookmark\nNo Video Found')
        end
        msg.info("Failed to bookmark, no video found")
    end
end

function get_list_keybinds()
    bind_keys(o.list_move_up_keybind, 'move-up', list_move_up, 'repeatable')
    bind_keys(o.list_move_down_keybind, 'move-down', list_move_down, 'repeatable')
    bind_keys(o.list_move_first_keybind, 'move-first', list_move_first, 'repeatable')
    bind_keys(o.list_move_last_keybind, 'move-last', list_move_last, 'repeatable')
    bind_keys(o.list_page_up_keybind, 'page-up', list_page_up, 'repeatable')
    bind_keys(o.list_page_down_keybind, 'page-down', list_page_down, 'repeatable')
    bind_keys(o.list_select_keybind, 'list-select', list_select)
    bind_keys(o.list_delete_keybind, 'list-delete', list_delete)
    bind_keys(o.bookmark_slots_remove_keybind, 'slot-remove', function()list_slot_remove()get_list_contents() if list_cursor ~= #list_contents + 1 then select(0) else select(-1) end end)
    bind_keys(o.list_close_keybind, 'list-close', unbind)
	bind_keys(o.next_filter_sequence_keybind, 'list-filter-next', list_filter_next)
	bind_keys(o.previous_filter_sequence_keybind, 'list-filter-previous', list_filter_previous)
	
    if o.quickselect_0to9_keybind and o.list_show_amount <= 10 then
        mp.add_forced_key_binding("1", "recent-1", function()load(list_start + 1) end)
        mp.add_forced_key_binding("2", "recent-2", function()load(list_start + 2) end)
        mp.add_forced_key_binding("3", "recent-3", function()load(list_start + 3) end)
        mp.add_forced_key_binding("4", "recent-4", function()load(list_start + 4) end)
        mp.add_forced_key_binding("5", "recent-5", function()load(list_start + 5) end)
        mp.add_forced_key_binding("6", "recent-6", function()load(list_start + 6) end)
        mp.add_forced_key_binding("7", "recent-7", function()load(list_start + 7) end)
        mp.add_forced_key_binding("8", "recent-8", function()load(list_start + 8) end)
        mp.add_forced_key_binding("9", "recent-9", function()load(list_start + 9) end)
        mp.add_forced_key_binding("0", "recent-0", function()load(list_start + 10) end)
    end
	
	if not o.slots_filter_outside_list then
        bind_keys(o.list_filter_slots_keybind, 'slots-list', function()display_list('slots') end)
    end
    if not o.fileonly_filter_outside_list then
        bind_keys(o.list_filter_fileonly_keybind, 'fileonly-list', function()display_list('fileonly') end)
    end
    if not o.timeonly_filter_outside_list then
        bind_keys(o.list_filter_timeonly_keybind, 'timeonly-list', function()display_list('timeonly') end)
    end
    if not o.timeonly_filter_outside_list then
		bind_keys(o.list_filter_timeonly_keybind, 'timeonly-list', function()display_list('timeonly') end)
	end
	if not o.protocols_filter_outside_list then
		bind_keys(o.list_filter_protocols_keybind, 'protocols-list', function()display_list('protocols') end)
	end
	if not o.titleonly_filter_outside_list then
		bind_keys(o.list_filter_titleonly_keybind, 'titleonly-list', function()display_list('titleonly') end)
	end
	if not o.keywords_filter_outside_list then
		bind_keys(o.list_filter_keywords_keybind, 'keywords-list', function()display_list('keywords') end)
	end
end

function display_list(filter)
    if not filter then filter = 'all' end
    local prev_filter = filterName --Get previous filterName

	filterName = filter --Now update filterName to get passed one
    local trigger_close_list = false
    local trigger_initial_list = false
    local page_change_event = false
    table.insert(list_pages, {filter, list_cursor})
	
    if #list_pages > 1 then
        if list_pages[#list_pages - 1][1] == filter and filter == 'all' and o.bookmark_list_keybind_twice_exits then
            trigger_close_list = true
        elseif list_pages[#list_pages - 1][1] == filter and list_pages[1][1] == filter then
            trigger_close_list = true
        elseif list_pages[#list_pages - 1][1] == filter then
            trigger_initial_list = true
        end
        
        if list_pages[#list_pages - 1][1] ~= filter then
            page_change_event = true
        end
    end
    
    if page_change_event then
        list_pages[#list_pages - 1][2] = list_cursor
        list_cursor = 1
        for i = #list_pages, 1, -1 do
            if list_pages[i - 1] and list_pages[i - 1][1] == filter then
                list_cursor = list_pages[i - 1][2]
                break
            end
        end
    end
    
    if trigger_initial_list then
        display_list(list_pages[1][1])
        return
    end
	
	if trigger_close_list then
		unbind()
		return
	end
    
    get_list_contents()
    if not list_contents or not list_contents[1] then
        if not list_drawn then --Only if list is not drawn then unbind
			unbind()
		else --Only if list is drawn then go to previous filter
			display_list(prev_filter) --Remain in the same page
		end
		return
    end
    
    draw_list()
    list_drawn = true
    get_list_keybinds()
end

if o.auto_run_list_idle == 'all'
	or o.auto_run_list_idle == 'slots' 
	or o.auto_run_list_idle == 'protocols'
	or o.auto_run_list_idle == 'fileonly'
	or o.auto_run_list_idle == 'titleonly'
	or o.auto_run_list_idle == 'timeonly' then
    mp.observe_property("idle-active", "bool", function(_, v)
        if v then display_list(o.auto_run_list_idle) end
    end)
end

mp.register_event('start-file', function()
end)

mp.register_event('file-loaded', function()
    unbind()
    filePath, fileTitle = get_path()
	mark_chapter() --Marks the chapter if enabled
	
    if (selected == true and seekTime ~= nil) then
        mp.commandv('seek', seekTime, 'absolute', 'exact')
        selected = false
    end
end)


bind_keys(o.bookmark_list_keybind, 'bookmark-list', display_list)
bind_keys(o.bookmark_save_keybind, 'bookmark-save', bookmark_save)
bind_keys(o.bookmark_fileonly_keybind, 'bookmark-fileonly', bookmark_fileonly_save)

for i = 1, #o.bookmark_slots_add_load_keybind do
    mp.add_forced_key_binding(o.bookmark_slots_add_load_keybind[i], 'slot-' .. i, function()add_load_slot(i) end)
end

for i = 1, #o.bookmark_slots_quicksave_keybind do
    mp.add_forced_key_binding(o.bookmark_slots_quicksave_keybind[i], 'slot-save-' .. i, function()quicksave_slot(i) end)
end

if o.slots_filter_outside_list then
    bind_keys(o.list_filter_slots_keybind, 'slots-list', function()display_list('slots') end)
end
if o.fileonly_filter_outside_list then
    bind_keys(o.list_filter_fileonly_keybind, 'fileonly-list', function()display_list('fileonly') end)
end
if o.timeonly_filter_outside_list then
    bind_keys(o.list_filter_timeonly_keybind, 'timeonly-list', function()display_list('timeonly') end)
end
if o.protocols_filter_outside_list then
    bind_keys(o.list_filter_protocols_keybind, 'protocols-list', function()display_list('protocols') end)
end
if o.titleonly_filter_outside_list then
    bind_keys(o.list_filter_titleonly_keybind, 'titleonly-list', function()display_list('titleonly') end)
end
if o.keywords_filter_outside_list then
    bind_keys(o.list_filter_keywords_keybind, 'keywords-list', function()display_list('keywords') end)
end
