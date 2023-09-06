-- Copyright (c) 2023, Eisa AlAwadhi
-- License: BSD 2-Clause License
-- Creator: Eisa AlAwadhi
-- Project: SmartSkip
-- Version: 0.19
-- Date: 07-09-2023

-- Related forked projects: 
--  https://github.com/detuur/mpv-scripts/blob/master/skiptosilence.lua
--  https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/autoload.lua
--  https://github.com/mar04/chapters_for_mpv
--  https://github.com/po5/chapterskip/blob/master/chapterskip.lua

local o = {
	--skip-silence script user config--
	silence_audio_level = -40,
	silence_duration = 0.65,
	ignore_silence_duration=1,
	min_skip_duration = 0,
	max_skip_duration = 120,
	skip_to_end_behavior = "playlist-next",
	add_chapter_on_skip = true, --1.07# add the following options --- (yes/no) or specify types ["no-chapters", "internal-chapters", "external-chapters"]. e.g.: [[ ["no-chapters", "external-chapters"] ]])
	force_mute_on_skip = false,
	--SmartSkip user config--
	last_chapter_skip_behavior = [[ [ ["no-chapters", "silence-skip"], ["internal-chapters", "playlist-next"], ["external-chapters", "silence-skip"] ] ]],--1.09# Available options [[ [ ["no-chapters", "silence-skip"], ["internal-chapters", "playlist-next"], ["external-chapters", "chapter-next"] ] ]] -- it defaults to silence-skip so if dont define external-chapters it will be silence-skip
	--chapters user config--
    external_chapters_autoload = true, --0.15# rename 
    modified_chapters_autosave = [[ ["no-chapters", "external-chapters"] ]], --1.06# add the following options --- (yes/no) or specify types ["no-chapters", "internal-chapters", "external-chapters"])
    global_chapters = true, -- save all chapter files in a single global directory or next to the playback file
    chapters_dir = mp.command_native({"expand-path", "~~home/chapters"}),
    hash = true, -- hash works only with global_chapters enabled
    add_chapter_ask_title = false, -- ask for title or leave it empty
	add_chapter_pause_for_input = false, -- pause the playback when asking for chapter title
    add_chapter_placeholder_title = "Chapter ", -- placeholder when asking for title of a new chapter
	--chapters auto skip user config--
    autoskip_chapter = false, --(yes/no) or specify types e.g.: [[ ["internal-chapters", "external-chapters"] ]])
    skip_once = true, --(yes/no) or specify types e.g.: [[ ["internal-chapters", "external-chapters"] ]])
	categories = [[ [ ["internal-chapters", "prologue>Prologue/^Intro; opening>OP/ OP$/^Opening; ending>^ED/ ED$/^Ending; preview>Preview$"], ["external-chapters", "idx->0/2"] ] ]], --0.16# write the string for any chapter type, e.g.: categories = "prologue>Prologue/^Intro; opening>OP/ OP$/^Opening; ending>^ED/ ED$/^Ending; preview>Preview$; idx->0/2", or specify categories for each chapter
	skip = [[ [ ["internal-chapters", "opening;ending;preview"], ["external-chapters", "idx-"] ] ]], -- write the string .e.g: skip = "opening;ending", OR define the skip category for each chapter type: [[ [ ["internal-chapters", "prologue;ending"], ["external-chapters", "idx-"] ] ]]
	--autoload user config--
	autoload_playlist = true,
    autoload_max_entries = 5000,
    ignore_hidden = true,
    same_type = false,
    images = true,
    videos = true,
    audio = true,
    additional_image_exts = "",
    additional_video_exts = "",
    additional_audio_exts = "",
	--osd messages--
	seek_osd = "osd-msg-bar", --1.06# added option to display bar if needed for smart skip - Choose between (no-osd/osd-bar/osd-msg/osd-msg-bar) as per mpv.io
	chapter_osd = "osd-msg-bar", --0.19# seperate chapter_osd. Choose between (no-osd/osd-bar/osd-msg/osd-msg-bar) as per mpv.io
	autoskip_osd = "osd-msg-bar", --Choose between (no-osd/osd-bar/osd-msg/osd-msg-bar)
	playlist_osd = true, --1.07# true false to show osd when playlist entry changes --0.19# made it universal
	osd_msg = true, -- all other osd messages
}

local mp = require 'mp'
local msg = require 'mp.msg'
local utils = require 'mp.utils'
local options = require 'mp.options'
options.read_options(o, nil, function(list) --0.16# for autoload
    split_option_exts(list.additional_video_exts, list.additional_audio_exts, list.additional_image_exts)
    if list.videos or list.additional_video_exts or
        list.audio or list.additional_audio_exts or
        list.images or list.additional_image_exts then
        create_extensions()
    end
end)

if o.add_chapter_on_skip ~= false and o.add_chapter_on_skip ~= true then o.add_chapter_on_skip = utils.parse_json(o.add_chapter_on_skip) end --1.07# made it json (added if statement since the configuration accepts true/false also)
if o.modified_chapters_autosave ~= false and o.modified_chapters_autosave ~= true then o.modified_chapters_autosave = utils.parse_json(o.modified_chapters_autosave) end--1.07# made it json (added if statement since the configuration accepts true/false also)
o.last_chapter_skip_behavior = utils.parse_json(o.last_chapter_skip_behavior)
if utils.parse_json(o.skip) ~= nil then o.skip = utils.parse_json(o.skip) end --0.17# only if it is an appropriate json string then convert it into table
if utils.parse_json(o.categories) ~= nil then o.categories = utils.parse_json(o.categories) end --0.17# only if it is an appropriate json string then convert it into table
if o.autoskip_chapter ~= false and o.autoskip_chapter ~= true then o.autoskip_chapter = utils.parse_json(o.autoskip_chapter) end --0.18 yes/no + json for autoskip_chapter
if o.skip_once ~= false and o.skip_once ~= true then o.skip_once = utils.parse_json(o.skip_once) end --0.18 yes/no + json for skip_once

package.path = mp.command_native({"expand-path", "~~/script-modules/?.lua;"}) .. package.path
local user_input_module, input = pcall(require, "user-input-module")

local speed_state = 1
local pause_state = false
local mute_state = false
local sub_state = nil
local secondary_sub_state = nil
local vid_state = nil
local skip_flag = false
local window_state = nil
local force_silence_skip = false --1.10# option to force silence skip instead of missing around with initial chapter count
local initial_skip_time = 0
local initial_chapter_count = 0 --1.07# global variable to identify if initially the file had chapters or it was externally loaded
local chapter_state = 'no-chapters' --1.07# initiate with no-chapters as the default type
local file_length = 0
local keep_open_state = "yes"
if mp.get_property("config") ~= "no" then keep_open_state = mp.get_property("keep-open") end
local autoload_playlist = o.autoload_playlist --0.19# for activate autoload keybind

-- utility functions --
function has_value(tab, val, array2d) --1.07# needed when using arrays for user config
	if not tab then return msg.error('check value passed') end
	if not val then return msg.error('check value passed') end
	if not array2d then
		for index, value in ipairs(tab) do
			if string.lower(value) == string.lower(val) then
				return true
			end
		end
	end
	if array2d then
		for i=1, #tab do
			if tab[i] and string.lower(tab[i][array2d]) == string.lower(val) then
				return true
			end
		end
	end
	
	return false
end

-- skip-silence utility functions --
function restoreProp(timepos,pause)
	if not timepos then timepos = mp.get_property_number("time-pos") end
	if not pause then pause = pause_state end
	
	mp.set_property("vid", vid_state)
	mp.set_property("force-window", window_state)
	mp.set_property_bool("mute", mute_state)
	mp.set_property("speed", speed_state)
	mp.unobserve_property(foundSilence)
	mp.command("no-osd af remove @skiptosilence")
	mp.set_property_bool("pause", pause)
	mp.set_property_number("time-pos", timepos)
	mp.set_property("sub-visibility", sub_state)
	mp.set_property("secondary-sub-visibility", secondary_sub_state)
	timer:kill()
	skip_flag = false
end

function handleMinMaxDuration(timepos)
		if not skip_flag then return end
		if not timepos then timepos = mp.get_property_number("time-pos") end
		
		skip_duration = timepos - initial_skip_time
		if o.min_skip_duration > 0 and skip_duration <= o.min_skip_duration then
			restoreProp(initial_skip_time)
			if o.osd_msg then mp.osd_message('Skipping Cancelled\nSilence less than minimum') end
			msg.info('Skipping Cancelled\nSilence is less than configured minimum')
			return true
		end
		if o.max_skip_duration > 0 and skip_duration >= o.max_skip_duration then
			restoreProp(initial_skip_time)
			if o.osd_msg then mp.osd_message('Skipping Cancelled\nSilence more than maximum') end
			msg.info('Skipping Cancelled\nSilence is more than configured maximum')
			return true
		end
		return false
end

function skippedMessage()
	if o.osd_msg then mp.osd_message("Skipped to silence 🕒 " .. mp.get_property_osd("time-pos")) end --0.19# changed icon 
	msg.info("Skipped to silence at " .. mp.get_property_osd("time-pos"))
end

function setKeepOpenState()
	if o.skip_to_end_behavior == "playlist-next" then
		mp.set_property("keep-open", "yes")
	else
		mp.set_property("keep-open", "always")
	end
end

function eofHandler(name, val)
    if val and skip_flag then
		if o.skip_to_end_behavior == 'playlist-next' then
			restoreProp((mp.get_property_native('duration') or 0))
			if mp.get_property_native('playlist-playing-pos')+1 == mp.get_property_native('playlist-count') then
				if o.osd_msg then mp.osd_message("Skipped to end at " .. mp.get_property_osd("duration")) end
				msg.info("Skipped to end at " .. mp.get_property_osd("duration"))
			else
				mp.commandv("playlist-next") --1.08# added playlist-next here instead of on_unload to solve issue of playlist moving twice
			end
		elseif o.skip_to_end_behavior == 'cancel' then	
			restoreProp(initial_skip_time)
			if o.osd_msg then mp.osd_message('Skipping Cancelled\nSilence not detected') end
			msg.info('Skipping Cancelled\nSilence was not detected and playback reached end')
		elseif o.skip_to_end_behavior == 'pause' then	
			restoreProp((mp.get_property_native('duration') or 0), true)
			if o.osd_msg then mp.osd_message("Skipped to end at " .. mp.get_property_osd("duration")) end
			msg.info("Skipped to end at " .. mp.get_property_osd("duration"))
		end
	end
end

-- smart-skip main code --
function smartNext() --1.09# change smartNext behavior
	local next_action = "silence-skip" --1.09# initiate as silence skip to be default
	local chapters_count = (mp.get_property_number('chapters') or 0)
    local chapter  = (mp.get_property_number('chapter') or 0)
	local current_playlist = (mp.get_property_native('playlist-playing-pos')+1 or 0)
	local total_playlist = (mp.get_property_native('playlist-count') or 0)
	
	if chapter+2 <= chapters_count then --1.09# if there is next chapter then go to next chapter
		next_action = 'chapter-next'
	elseif chapter+2 > chapters_count and (initial_chapter_count == 0 or chapters_count == 0 or force_silence_skip) then --1.10 instead of checking with chapter-next, made it the opposite, also added force_silence_skip
		if chapters_count == 0 then force_silence_skip = true end --1.10# use force_silence_skip instead
		next_action = 'silence-skip'
	elseif chapter+1 >= chapters_count then --1.09# if we exceed last chapter, get next_action based on chapter_state (external-chapters causing issues I need to delete the file when it is 0, while autosaving)
		for i = 1, #o.last_chapter_skip_behavior do --1.09# find the next_action 
			if o.last_chapter_skip_behavior[i] and o.last_chapter_skip_behavior[i][1] == chapter_state then --0.17# prevents possible crash
				next_action = o.last_chapter_skip_behavior[i][2]
				break
			end
		end
	end
	
	if next_action == 'playlist-next' and current_playlist == total_playlist then --1.10# if playlist-next is found and we are on the last chapter, then change it chapter-next
		next_action = 'chapter-next'
	end
	
	if next_action == 'silence-skip' then
		silenceSkip()
	end
	if next_action == 'chapter-next' then
		mp.commandv(o.chapter_osd, 'add', 'chapter', 1)
	end
	if next_action == 'playlist-next' then
		mp.command('playlist_next')
	end
end

function smartPrev() --1.10# changed to smartPrev to only handle cases where previous chapter / playlist is needed
	if skip_flag then restoreProp(initial_skip_time) return end --1.11# cancel skip to silence if its on-going
	local chapters_count = (mp.get_property_number('chapters') or 0)
    local chapter  = (mp.get_property_number('chapter') or 0)
	local timepos = (mp.get_property_native("time-pos") or 0)

	if chapter-1 < 0 and timepos > 1 and chapters_count == 0 then --1.11# made the if statement more clear
		mp.commandv('seek', 0, 'absolute', 'exact')
		mp.commandv(o.seek_osd, "show_progress")
	elseif chapter-1 < 0 and timepos < 1 then --1.10# only go to previous playlist if its less than 1 second, otherwise chapter will trigger (perhaps add a check to exit function doing nothing when in first playlist entry)
        mp.command('playlist_prev')
    elseif chapter-1 <= chapters_count then --1.10# if there is previous chapter then go to it
        mp.commandv(o.chapter_osd, 'add', 'chapter', -1) --added OSD bar in addition to msg
    end
end

-- chapter-next/prev main code --
function chapterSeek(direction) --0.14# change variables to be same as smartPrev 
	local chapters_count = (mp.get_property_number('chapters') or 0)
    local chapter  = (mp.get_property_number('chapter') or 0)
	local timepos = (mp.get_property_native("time-pos") or 0)

    if chapter+direction < 0 and timepos > 1 and chapters_count == 0 then --1.11# allows chapterSeek to go to begining of file even if no chapter and before first chapter
		mp.commandv('seek', 0, 'absolute', 'exact')
		mp.commandv(o.seek_osd, "show_progress")	
	elseif chapter+direction < 0 and timepos < 1 then --1.11# only if at the begining of the file then go back to previous playlist
	    mp.command('playlist_prev')
    elseif chapter+direction >= chapters_count then
		mp.command('playlist_next')
    else
        mp.commandv(o.seek_osd, 'add', 'chapter', direction) --added OSD bar in addition to msg --0.16 changed to o.seek_osd
    end
end

-- silence skip main code --
function silenceSkip(action)
	if skip_flag then return end
	initial_skip_time = (mp.get_property_native("time-pos") or 0)
	if math.floor(initial_skip_time) == math.floor(mp.get_property_native('duration') or 0) then return end	
	local width = mp.get_property_native("osd-width")
	local height = mp.get_property_native("osd-height")
	mp.set_property_native("geometry", ("%dx%d"):format(width, height))
	mp.commandv(o.seek_osd, "show_progress")
	
	mp.command(
		"no-osd af add @skiptosilence:lavfi=[silencedetect=noise=" ..
		o.silence_audio_level .. "dB:d=" .. o.silence_duration .. "]"
	)
	
	mp.observe_property("af-metadata/skiptosilence", "string", foundSilence)
	
	sub_state = mp.get_property("sub-visibility") --1.08# change with sub-visibility instead of sid, fixes subtitle causes crash if autoload script is there
	mp.set_property("sub-visibility", "no")
	secondary_sub_state = mp.get_property("secondary-sub-visibility")
	mp.set_property("secondary-sub-visibility", "no")
	window_state = mp.get_property("force-window")
	mp.set_property("force-window", "yes")
	vid_state = mp.get_property("vid")
	mp.set_property("vid", "no")
	mute_state = mp.get_property_native("mute")
    if o.force_mute_on_skip then
        mp.set_property_bool("mute", true)
    end
	pause_state = mp.get_property_native("pause")
	mp.set_property_bool("pause", false)
	speed_state = mp.get_property_native("speed")
	mp.set_property("speed", 100)
	setKeepOpenState()
	skip_flag = true
	
	timer = mp.add_periodic_timer(0.5, function()
		local video_time = (mp.get_property_native("time-pos") or 0)
		handleMinMaxDuration(video_time)
		if skip_flag then mp.commandv(o.seek_osd, "show_progress") end
	end)
end

function foundSilence(name, value)
	if value == "{}" or value == nil then
		return
	end
	
	timecode = tonumber(string.match(value, "%d+%.?%d+"))
	if timecode == nil or timecode < initial_skip_time + o.ignore_silence_duration then
		return
	end
	
	if handleMinMaxDuration(timecode) then return end
	
	restoreProp(timecode)

	mp.add_timeout(0.05, skippedMessage)
	if o.add_chapter_on_skip == true or has_value(o.add_chapter_on_skip, chapter_state) then --1.07# if the chapter_on_skip is the same as chapter_state (using array) or if its enabled then add chapter
		mp.add_timeout(0.05, add_chapter) --0.15# fix: timepos is wrong when found_silence triggers add_chapter, timecode sometimes is wrong so I need to wait at least 0.05 and run the add_chapter function which will also get timepos
	end --1.06# utilize the add_chapter function --1.07# fix bug wrong place adding chapter by using timecode
	skip_flag = false
end

-- modified fork of chapters_for_mpv --
--[[
Copyright (c) 2023 Mariusz Libera <mariusz.libera@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]


-- to debug run mpv with arg: --msg-level=SmartSkip=debug
-- to test o.run mpv with arg: --script-opts=SmartSkip-OPTION=VALUE



local chapters_modified = false

msg.debug("options:", utils.to_string(options))


-- CHAPTER MANIPULATION --------------------------------------------------------


function change_title_callback(user_input, err, chapter_index)
    if user_input == nil or err ~= nil then
        msg.warn("no chapter title provided:", err)
        return
    end

    local chapter_list = mp.get_property_native("chapter-list")

    if chapter_index > mp.get_property_number("chapter-list/count") then
        msg.warn("can't set chapter title")
        return
    end

    chapter_list[chapter_index].title = user_input

    mp.set_property_native("chapter-list", chapter_list)
    chapters_modified = true
end


function edit_chapter()
    local mpv_chapter_index = mp.get_property_number("chapter")
    local chapter_list = mp.get_property_native("chapter-list")

    if mpv_chapter_index == nil or mpv_chapter_index == -1 then
        msg.verbose("no chapter selected, nothing to edit")
        return
    end

    if not user_input_module then
        msg.error("no mpv-user-input, can't get user input, install: https://github.com/CogentRedTester/mpv-user-input")
        return
    end
    input.get_user_input(change_title_callback, {
        request_text = "title of the chapter:",
        default_input = chapter_list[mpv_chapter_index + 1].title,
        cursor_pos = #(chapter_list[mpv_chapter_index + 1].title) + 1,
    }, mpv_chapter_index + 1)

    if o.add_chapter_pause_for_input then
        mp.set_property_bool("pause", true)
        mp.osd_message(" ", 0.1)
    end
end


function add_chapter(timepos)
	if not timepos then timepos = mp.get_property_number("time-pos") end --1.07# ability to add timepos
    local chapter_list = mp.get_property_native("chapter-list")
	
	if #chapter_list > 0 then --0.14# only if there are chapters then do the loop
		for i = 1, #chapter_list do --0.14# check if any chapter is the same time as this to ignore it
			if math.floor(chapter_list[i].time) == math.floor(timepos) then
				msg.debug("failed to add chapter, chapter exists in same position")
				return
			end
		end
	end
	
    local chapter_index = (mp.get_property_number("chapter") or -1) + 2

    table.insert(chapter_list, chapter_index, {title = "", time = timepos})

    msg.debug("inserting new chapter at ", chapter_index, " chapter_", " time: ", timepos)

    mp.set_property_native("chapter-list", chapter_list)
    chapters_modified = true

    if o.add_chapter_ask_title then
        if not user_input_module then
            msg.error("no mpv-user-input, can't get user input, install: https://github.com/CogentRedTester/mpv-user-input")
            return
        end
        -- ask user for chapter title
        input.get_user_input(change_title_callback, {
            request_text = "title of the chapter:",
            default_input = o.placeholder_title .. chapter_index,
            cursor_pos = #(o.placeholder_title .. chapter_index) + 1,
        }, chapter_index)

        if o.add_chapter_pause_for_input then
            mp.set_property_bool("pause", true)
            -- FIXME: for whatever reason osd gets hidden when we pause the
            -- playback like that, workaround to make input prompt appear
            -- right away without requiring mouse or keyboard action
            mp.osd_message(" ", 0.1)
        end
    end
end


function remove_chapter()
    local chapter_count = mp.get_property_number("chapter-list/count")

    if chapter_count < 1 then
        msg.verbose("no chapters to remove")
        return
    end

    local chapter_list = mp.get_property_native("chapter-list")
    -- +1 because mpv indexes from 0, lua from 1
    local current_chapter = mp.get_property_number("chapter") + 1

    table.remove(chapter_list, current_chapter)
    msg.debug("removing chapter", current_chapter)

    mp.set_property_native("chapter-list", chapter_list)
    chapters_modified = true
end


-- UTILITY FUNCTIONS -----------------------------------------------------------


function detect_os()
    if package.config:sub(1,1) == "/" then
        return "unix"
    else
        return "windows"
    end
end


-- for unix use only
-- returns a table of command path and varargs, or nil if command was not found
function command_exists(command, ...)
    msg.debug("looking for command:", command)
    -- msg.debug("args:", )
    local process = mp.command_native({
        name = "subprocess",
        capture_stdout = true,
        capture_stderr = true,
        playback_only = false,
        args = {"sh", "-c", "command -v -- " .. command}
    })

    if process.status == 0 then
        local command_path = process.stdout:gsub("\n", "")
        msg.debug("command found:", command_path)
        return {command_path, ...}
    else
        msg.debug("command not found:", command)
        return nil
    end
end

function mkdir(path)
    local args = nil

    if detect_os() == "unix" then
        args = {"mkdir", "-p", "--", path}
    else
        args = {"powershell", "-NoProfile", "-Command", "mkdir", path}
    end

    local process = mp.command_native({
        name = 'subprocess',
        playback_only = false,
        capture_stdout = true,
        capture_stderr = true,
        args = args,
    })

    if process.status == 0 then
        msg.debug("mkdir success:", path)
        return true
    else
        msg.error("mkdir failure:", path)
        return false
    end
end


-- returns md5 hash of the full path of the current media file
function hash()
    local path = mp.get_property("path") --0.14# changed from get_fullpath function as it used to cause issues
    if path == nil then
        msg.debug("something is wrong with the path, can't get full_path, can't hash it")
        return
    end

    msg.debug("hashing:", path)

    local cmd = {
        name = 'subprocess',
        capture_stdout = true,
        playback_only = false,
    }
    local args = nil

    if detect_os() == "unix" then
        local md5 = command_exists("md5sum") or command_exists("md5") or command_exists("openssl", "md5 | cut -d ' ' -f 2")
        if md5 == nil then
            msg.warn("no md5 command found, can't generate hash")
            return
        end
        md5 = table.concat(md5, " ")
        cmd["stdin_data"] = path
        args = {"sh", "-c", md5 .. " | cut -d ' ' -f 1 | tr '[:lower:]' '[:upper:]'" }
    else --windows
        -- https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash?view=powershell-7.3
        local hash_command ="$s = [System.IO.MemoryStream]::new(); $w = [System.IO.StreamWriter]::new($s); $w.write(\"" .. path .. "\"); $w.Flush(); $s.Position = 0; Get-FileHash -Algorithm MD5 -InputStream $s | Select-Object -ExpandProperty Hash"
        args = {"powershell", "-NoProfile", "-Command", hash_command}
    end
    cmd["args"] = args
    msg.debug("hash cmd:", utils.to_string(cmd))
    local process = mp.command_native(cmd)

    if process.status == 0 then
        local hash = process.stdout:gsub("%s+", "")
        msg.debug("hash:", hash)
        return hash
    else
        msg.warn("hash function failed")
        return
    end
end

function construct_ffmetadata()
	local path = mp.get_property("path") --0.14# changed from get_fullpath function as it used to cause issues
    if path == nil then
        msg.debug("something is wrong with the path, can't get full_path")
        return
    end
	
    local chapter_count = mp.get_property_number("chapter-list/count")
    local all_chapters = mp.get_property_native("chapter-list")

    local ffmetadata = ";FFMETADATA1\n;file=" .. path

    for i, c in ipairs(all_chapters) do
        local c_title = c.title
        local c_start = c.time * 1000000000
        local c_end

        if i < chapter_count then
            c_end = all_chapters[i+1].time * 1000000000
        else
            c_end = (mp.get_property_number("duration") or c.time) * 1000000000
        end

        msg.debug(i, "c_title", c_title, "c_start:", c_start, "c_end", c_end)

        ffmetadata = ffmetadata .. "\n[CHAPTER]\nSTART=" .. c_start .. "\nEND=" .. c_end .. "\ntitle=" .. c_title
    end

    return ffmetadata
end


-- FILE IO ---------------------------------------------------------------------


-- args:
--      osd - if true, display an osd message
--      force -- if true write chapters file even if there are no changes
-- on success returns path of the chapters file, nil on failure
function write_chapters(...)
	local chapters_count = (mp.get_property_number('chapters') or 0)
	local osd, force = ...
    if not force and not chapters_modified then --0.12# added or so that if there was no chapters and there are still no chapters then do not autosave
        msg.debug("nothing to write")
        return
    end
	if initial_chapter_count == 0 and chapters_count == 0 then return end --0.14# changed it again to be seperate


    -- figure out the directory
    local chapters_dir
    if o.global_chapters then
        local dir = utils.file_info(o.chapters_dir)
        if dir then
            if dir.is_dir then
                msg.debug("o.chapters_dir exists:", o.chapters_dir)
                chapters_dir = o.chapters_dir
            else
                msg.error("o.chapters_dir is not a directory")
                return
            end
        else
            msg.verbose("o.chapters_dir doesn't exists:", o.chapters_dir)
            if mkdir(o.chapters_dir) then
                chapters_dir = o.chapters_dir
            else
                return
            end
        end
    else
        chapters_dir = utils.split_path(mp.get_property("path"))
    end

    -- and the name
    local name = mp.get_property("filename")
    if o.hash and o.global_chapters then
        name = hash()
        if name == nil then
            msg.warn("hash function failed, fallback to filename")
            name = mp.get_property("filename")
        end
    end

    local chapters_file_path = utils.join_path(chapters_dir, name .. ".ffmetadata")
	--1.09#EISA HERE, I SHOULD ADD SOME SORT OF DELETE FUNCTION IN CASE CHAPTER COUNT IS 0
    msg.debug("opening for writing:", chapters_file_path)
    local chapters_file = io.open(chapters_file_path, "w")
    if chapters_file == nil then
        msg.error("could not open chapter file for writing")
        return
    end

    local success, error = chapters_file:write(construct_ffmetadata())
    chapters_file:close()

    if success then
        if osd then
            mp.osd_message("Chapters written to:" .. chapters_file_path, 3)
        end
        return chapters_file_path
    else
        msg.error("error writing chapters file:", error)
        return
    end
end


-- priority:
-- 1. chapters file in the same directory as the playing file
-- 2. hashed version of the chapters file in the global directory
-- 3. path based version of the chapters file in the global directory
function load_chapters()
    local path = mp.get_property("path")
    local expected_chapters_file = utils.join_path(utils.split_path(path), mp.get_property("filename") .. ".ffmetadata")

    msg.debug("looking for:", expected_chapters_file)

    local file = utils.file_info(expected_chapters_file)
	
    if file then
        msg.debug("found in the local directory, loading..")
        mp.set_property("file-local-options/chapters-file", expected_chapters_file)
		chapter_state = 'external-chapters' --1.07# add chapter_state
        return
    end

    if not o.global_chapters then
        msg.debug("not in local, global chapters not enabled, aborting search")
        return
    end

    msg.debug("looking in the global directory")

    if o.hash then
        local hashed_path = hash()
        if hashed_path then
            expected_chapters_file = utils.join_path(o.chapters_dir, hashed_path .. ".ffmetadata")
        else
            msg.debug("hash function failed, fallback to path")
            expected_chapters_file = utils.join_path(o.chapters_dir, mp.get_property("filename") .. ".ffmetadata")
        end
    else
        expected_chapters_file = utils.join_path(o.chapters_dir, mp.get_property("filename") .. ".ffmetadata")
    end

    msg.debug("looking for:", expected_chapters_file)

    file = utils.file_info(expected_chapters_file)

    if file then
        msg.debug("found in the global directory, loading..")
        mp.set_property("file-local-options/chapters-file", expected_chapters_file)
		chapter_state = 'external-chapters' --1.07# add chapter_state
        return
    end

    msg.debug("chapters file not found")
end


function bake_chapters()
    if mp.get_property_number("chapter-list/count") == 0 then
        msg.verbose("no chapters present")
        return
    end

    local chapters_file_path = write_chapters(false, true)
    if not chapters_file_path then
        msg.error("no chapters file")
        return
    end

    local filename = mp.get_property("filename")
    local output_name

    -- extract file extension
    local reverse_dot_index = filename:reverse():find(".", 1, true)
    if reverse_dot_index == nil then
        msg.warning("file has no extension, fallback to .mkv")
        output_name = filename .. ".chapters.mkv"
    else
        local dot_index = #filename + 1 - reverse_dot_index
        local ext = filename:sub(dot_index + 1)
        msg.debug("ext:", ext)
        if ext ~= "mkv" and ext ~= "mp4" and ext ~= "webm" then
            msg.debug("fallback to .mkv")
            ext = "mkv"
        end
        output_name = filename:sub(1, dot_index) .. "chapters." .. ext
    end

    local file_path = mp.get_property("path")
    local output_path = utils.join_path(utils.split_path(file_path), output_name)

    local args = {"ffmpeg", "-y", "-i", file_path, "-i", chapters_file_path, "-map_metadata", "1", "-codec", "copy", output_path}

    msg.debug("args:", utils.to_string(args))

    local process = mp.command_native({
        name = 'subprocess',
        playback_only = false,
        capture_stdout = true,
        capture_stderr = true,
        args = args
    })

    if process.status == 0 then
        mp.osd_message("file written to " .. output_path, 3)
    else
        msg.error("failed to write file:\n", process.stderr)
    end
end

--modified fork of autoload script--
function Set (t)
    local set = {}
    for _, v in pairs(t) do set[v] = true end
    return set
end

function SetUnion (a,b)
    for k in pairs(b) do a[k] = true end
    return a
end

function Split (s)
    local set = {}
    for v in string.gmatch(s, '([^,]+)') do set[v] = true end
    return set
end

EXTENSIONS_VIDEO = Set {
    '3g2', '3gp', 'avi', 'flv', 'm2ts', 'm4v', 'mj2', 'mkv', 'mov',
    'mp4', 'mpeg', 'mpg', 'ogv', 'rmvb', 'webm', 'wmv', 'y4m'
}

EXTENSIONS_AUDIO = Set {
    'aiff', 'ape', 'au', 'flac', 'm4a', 'mka', 'mp3', 'oga', 'ogg',
    'ogm', 'opus', 'wav', 'wma'
}

EXTENSIONS_IMAGES = Set {
    'avif', 'bmp', 'gif', 'j2k', 'jp2', 'jpeg', 'jpg', 'jxl', 'png',
    'svg', 'tga', 'tif', 'tiff', 'webp'
}

function split_option_exts(video, audio, image)
    if video then o.additional_video_exts = Split(o.additional_video_exts) end
    if audio then o.additional_audio_exts = Split(o.additional_audio_exts) end
    if image then o.additional_image_exts = Split(o.additional_image_exts) end
end
split_option_exts(true, true, true)

function create_extensions()
    EXTENSIONS = {}
    if o.videos then SetUnion(SetUnion(EXTENSIONS, EXTENSIONS_VIDEO), o.additional_video_exts) end
    if o.audio then SetUnion(SetUnion(EXTENSIONS, EXTENSIONS_AUDIO), o.additional_audio_exts) end
    if o.images then SetUnion(SetUnion(EXTENSIONS, EXTENSIONS_IMAGES), o.additional_image_exts) end
end
create_extensions()

function add_files(files)
    local oldcount = mp.get_property_number("playlist-count", 1)
    for i = 1, #files do
        mp.commandv("loadfile", files[i][1], "append")
        mp.commandv("playlist-move", oldcount + i - 1, files[i][2])
    end
end

function get_extension(path)
    match = string.match(path, "%.([^%.]+)$" )
    if match == nil then
        return "nomatch"
    else
        return match
    end
end

table.filter = function(t, iter)
    for i = #t, 1, -1 do
        if not iter(t[i]) then
            table.remove(t, i)
        end
    end
end

function alphanumsort(filenames)
    local function padnum(n, d)
        return #d > 0 and ("%03d%s%.12f"):format(#n, n, tonumber(d) / (10 ^ #d))
            or ("%03d%s"):format(#n, n)
    end

    local tuples = {}
    for i, f in ipairs(filenames) do
        tuples[i] = {f:lower():gsub("0*(%d+)%.?(%d*)", padnum), f}
    end
    table.sort(tuples, function(a, b)
        return a[1] == b[1] and #b[2] < #a[2] or a[1] < b[1]
    end)
    for i, tuple in ipairs(tuples) do filenames[i] = tuple[2] end
    return filenames
end

local autoloaded = nil

function get_playlist_filenames(playlist)
    local filenames = {}
    for i = 1, #playlist do
        local _, file = utils.split_path(playlist[i].filename)
        filenames[file] = true
    end
    return filenames
end

function toggle_autoload() --0.19# add option to toggle autoload for enable / disabled
	if autoload_playlist == true then
		autoload_playlist = false
		if o.osd_msg then mp.osd_message('Disabled autoload') end
		msg.info('Disabled autoload')
	elseif autoload_playlist == false then 
		autoload_playlist = true
		if o.osd_msg then mp.osd_message('Enabled autoload') end
		msg.info('Enabled autoload')
	end
	if autoload_playlist then find_and_add_entries() end
end

function find_and_add_entries()
    local path = mp.get_property("path", "")
    local dir, filename = utils.split_path(path)
    msg.trace(("dir: %s, filename: %s"):format(dir, filename))
    if not autoload_playlist then --0.19# changed to global variable since I added toggle option
        msg.verbose("stopping: autoload_playlist is disabled")
        return
    elseif #dir == 0 then
        msg.verbose("stopping: not a local path")
        return
    end

    pl_count = mp.get_property_number("playlist-count", 1)
    this_ext = get_extension(filename)
    -- check if this is a manually made playlist
    if (pl_count > 1 and autoloaded == nil) or
       (pl_count == 1 and EXTENSIONS[string.lower(this_ext)] == nil) then
        msg.verbose("stopping: manually made playlist")
        return
    else
        autoloaded = true
    end

    if o.same_type then
        if EXTENSIONS_VIDEO[string.lower(this_ext)] ~= nil then
            EXTENSIONS_TARGET = EXTENSIONS_VIDEO
        elseif EXTENSIONS_AUDIO[string.lower(this_ext)] ~= nil then
            EXTENSIONS_TARGET = EXTENSIONS_AUDIO
        else
            EXTENSIONS_TARGET = EXTENSIONS_IMAGES
        end
    else
        EXTENSIONS_TARGET = EXTENSIONS
    end

    local pl = mp.get_property_native("playlist", {})
    local pl_current = mp.get_property_number("playlist-pos-1", 1)
    msg.trace(("playlist-pos-1: %s, playlist: %s"):format(pl_current,
        utils.to_string(pl)))

    local files = utils.readdir(dir, "files")
    if files == nil then
        msg.verbose("no other files in directory")
        return
    end
    table.filter(files, function (v, k)
        -- The current file could be a hidden file, ignoring it doesn't load other
        -- files from the current directory.
        if (o.ignore_hidden and not (v == filename) and string.match(v, "^%.")) then
            return false
        end
        local ext = get_extension(v)
        if ext == nil then
            return false
        end
        return EXTENSIONS_TARGET[string.lower(ext)]
    end)
    alphanumsort(files)

    if dir == "." then
        dir = ""
    end

    -- Find the current pl entry (dir+"/"+filename) in the sorted dir list
    local current
    for i = 1, #files do
        if files[i] == filename then
            current = i
            break
        end
    end
    if current == nil then
        return
    end
    msg.trace("current file position in files: "..current)

    local append = {[-1] = {}, [1] = {}}
    local filenames = get_playlist_filenames(pl)
    for direction = -1, 1, 2 do -- 2 iterations, with direction = -1 and +1
        for i = 1, o.autoload_max_entries do
            local pos = current + i * direction
            local file = files[pos]
            if file == nil or file[1] == "." then
                break
            end

            local filepath = dir .. file
            -- skip files already in playlist
            if not filenames[file] then
                if direction == -1 then
                    msg.info("Prepending " .. file)
                    table.insert(append[-1], 1, {filepath, pos - 1})
                else
                    msg.info("Adding " .. file)
                    if pl_count > 1 then
                        table.insert(append[1], {filepath, pos - 1})
                    else
                        mp.commandv("loadfile", filepath, "append")
                    end
                end
            end
        end
        if pl_count == 1 and direction == -1 and #append[-1] > 0 then
            for i = 1, #append[-1] do
                mp.commandv("loadfile", append[-1][i][1], "append")
            end
            mp.commandv("playlist-move", 0, current)
        end
    end

    if pl_count > 1 then
        add_files(append[1])
        add_files(append[-1])
    end
end

--modified fork of chapterskip.lua--

local categories = {}

function matches(i, title)
	local opt_skip = o.skip --0.17# initiate opt_skip as o.skip, however if it was table then find the appropriate value based on chapter
	if type(o.skip) == 'table' then --0.17# if it is table then find the appropriate value based on chapter
		for i=1, #o.skip do
			if o.skip[i] and o.skip[i][1] == chapter_state then --0.17# set the value for the defined chapter
				opt_skip = o.skip[i][2]
				break
			end
		end
	end

    for category in string.gmatch(opt_skip, " *([^;]*[^; ]) *") do
        if categories[category:lower()] then
            if string.find(category:lower(), "^idx%-") == nil then
                if title then
                    for pattern in string.gmatch(categories[category:lower()], "([^/]+)") do
                        if string.match(title, pattern) then
                            return true
                        end
                    end
                end
            else
                for pattern in string.gmatch(categories[category:lower()], "([^/]+)") do
                    if tonumber(pattern) == i then
                        return true
                    end
                end
            end
        end
    end
end

local skipped = {}
local parsed = {}

function chapterskip(_, current)
	if chapter_state == 'no-chapters' then return end --0.17#FINALLY: solve crash because of the table, basically only proceed with this function to skip_chapters if its not defined as no-chapters.
    if not o.autoskip_chapter then return end
	if o.autoskip_chapter ~= false and o.autoskip_chapter ~= true and not has_value(o.autoskip_chapter, chapter_state) then return end --0.18 allow yes/no + json for specific chapters
	
	local opt_categories = o.categories --0.17 initiate as opt_categories
	if type(o.categories) == 'table' then --0.17# if it is table then find the appropriate value based on chapter
		for i=1, #o.categories do
			if o.categories[i] and o.categories[i][1] == chapter_state then --0.17# set the value for the defined chapter, causes crash because this function could run before chapter_state is set to internal or external (look at FINALLY: for the fix)
				opt_categories = o.categories[i][2]
				break
			end
		end
	end
	
    for category in string.gmatch(opt_categories, "([^;]+)") do
        name, patterns = string.match(category, " *([^+>]*[^+> ]) *[+>](.*)")
        if name then
            categories[name:lower()] = patterns
        elseif not parsed[category] then
            mp.msg.warn("Improper category definition: " .. category)
        end
        parsed[category] = true
    end
    local chapters = mp.get_property_native("chapter-list")
    local skip = false
	local opt_skip_once = false --0.18# initiate as false to be default state
	if o.skip_once == true or o.skip_once == false then --0.18# if its enabled or disabled then set it as that
		opt_skip_once = o.skip_once
	elseif has_value(o.skip_once, chapter_state) then --0.18# if it is found for a specific chapter then enable it for only the specific chapter
		opt_skip_once = true;
	end
    for i=0, #chapters do --0.16 convert to standard for loop
		if (not opt_skip_once or not skipped[i]) and i == 0 and chapters[i+1] and matches(i, chapters[i+1].title) then --0.16 handle index = 0 (idx->0), this will only run if index is 0 and then it will proceed like it was originally. ALSO (chaptersi+1) will also handle it so this works only if there chapter-next detected.
		    if i == current + 1 or skip == i - 1 then
                if skip then
                    skipped[skip] = true
                end
                skip = i
            end
        elseif (not opt_skip_once or not skipped[i]) and chapters[i] and matches(i, chapters[i].title) then --0.16 check if chapter iternation exists first to not crash
            if i == current + 1 or skip == i - 1 then
                if skip then
                    skipped[skip] = true
                end
                skip = i
            end
        elseif skip then
			mp.commandv(o.autoskip_osd, 'add', 'chapter', 1) --0.19# instead of skipping to time, just skip the chapter - Also show osd message to demonstrate that autoskip triggered
            skipped[skip] = true
            return
        end
    end
    if skip then
        if mp.get_property_native("playlist-count") == mp.get_property_native("playlist-pos-1") then
            return mp.set_property("time-pos", mp.get_property_native("duration"))
        end
        mp.commandv("playlist-next")
    end
end

-- HOOKS --------------------------------------------------------------------
if user_input_module then mp.add_hook("on_unload", 50, function () input.cancel_user_input() end) end -- chapters.lua
mp.register_event("start-file", find_and_add_entries) -- autoload.lua
mp.observe_property("chapter", "number", chapterskip) -- chapterskip.lua
mp.register_event("file-loaded", function() skipped = {} end) -- chapterskip.lua


-- smart skip events / properties / hooks --

mp.register_event('file-loaded', function()
	file_length = (mp.get_property_native('duration') or 0)
	if o.playlist_osd then mp.command("show-text '[${playlist-pos-1}/${playlist-count}] ${filename}'") end --1.10# adds playlist_osd
	force_silence_skip = false --1.10# reset force silence skip
	initial_chapter_count = mp.get_property_number("chapter-list/count")
	if initial_chapter_count > 0 and chapter_state ~= 'external-chapters' then chapter_state = 'internal-chapters' end --1.07# only set internal chapters if external-chapters were not loaded and the chapters count is more than 0
end)

mp.add_hook("on_load", 50, function()
	if o.external_chapters_autoload then load_chapters() end --0.15# renamed
end)

mp.observe_property('pause', 'bool', function(name, value)
	if value and skip_flag then
		restoreProp(initial_skip_time, true)
	end
end)

mp.add_hook('on_unload', 9, function()
	if o.modified_chapters_autosave == true or has_value(o.modified_chapters_autosave, chapter_state) then write_chapters(false) end --1.07# moved auto_save chapters here since I revert no_chapters here
	mp.set_property("keep-open", keep_open_state)
	chapter_state = 'no-chapters' --1.07# revert chapter state
end)

mp.observe_property('eof-reached', 'bool', eofHandler)

-- BINDINGS --------------------------------------------------------------------

mp.add_key_binding("", "toggle-autoload", toggle_autoload)
mp.add_key_binding("n", "add-chapter", add_chapter)
mp.add_key_binding("alt+n", "remove-chapter", remove_chapter)
mp.add_key_binding("ctrl+n", "write-chapters", function () write_chapters(true) end)
mp.add_key_binding("", "edit-chapter", edit_chapter)
mp.add_key_binding("", "bake-chapters", bake_chapters)
mp.add_key_binding("ctrl+left", "chapter-prev", function() chapterSeek(-1) end)
mp.add_key_binding("ctrl+right", "chapter-next", function() chapterSeek(1) end)
mp.add_key_binding("<", "smart-prev", smartPrev)
mp.add_key_binding(">", "smart-next", smartNext)
mp.add_key_binding("?", "silence-skip", silenceSkip)
