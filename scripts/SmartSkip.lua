-- Copyright (c) 2023, Eisa AlAwadhi
-- License: BSD 2-Clause License
-- Creator: Eisa AlAwadhi
-- Project: SmartSkip
-- Version: 1.2
-- Date: 23-09-2023

-- Related forked projects:
--  https://github.com/detuur/mpv-scripts/blob/master/skiptosilence.lua
--  https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/autoload.lua
--  https://github.com/mar04/chapters_for_mpv
--  https://github.com/po5/chapterskip/blob/master/chapterskip.lua

local o = {
	-----Silence Skip Settings-----
	silence_audio_level = -40,
	silence_duration = 0.65,
	ignore_silence_duration=5,
	min_skip_duration = 0,
	max_skip_duration = 130,
	keybind_twice_cancel_skip = true,
	silence_skip_to_end = "playlist-next",
	add_chapter_on_skip = true,
	force_mute_on_skip = false,
	-----Smart Skip Settings-----
	last_chapter_skip_behavior=[[ [ ["no-chapters", "silence-skip"], ["internal-chapters", "playlist-next"], ["external-chapters", "silence-skip"] ] ]],
	smart_next_proceed_countdown = true,
	smart_prev_cancel_countdown = true,
	-----Chapters Settings-----
    external_chapters_autoload = true,
    modified_chapters_autosave=[[ ["no-chapters", "external-chapters"] ]],
    global_chapters = true,
    global_chapters_path = "/:dir%mpvconf%/chapters",
    hash_global_chapters = true,
    add_chapter_ask_title = false,
	add_chapter_pause_for_input = false,
    add_chapter_placeholder_title = "Chapter ",
	-----Auto-Skip Settings-----
    autoskip_chapter = true,
	autoskip_countdown = 3,
	autoskip_countdown_bulk = false,
	autoskip_countdown_graceful = false,
    skip_once = false,
	categories=[[ [ ["internal-chapters", "prologue>Prologue/^Intro; opening>^OP/ OP$/^Opening; ending>^ED/ ED$/^Ending; preview>Preview$"], ["external-chapters", "idx->0/2"] ] ]],
	skip=[[ [ ["internal-chapters", "toggle;toggle_idx;opening;ending;preview"], ["external-chapters", "toggle;toggle_idx"] ] ]],
	-----Autoload Settings-----
	autoload_playlist = true,
    autoload_max_entries = 5000,
	autoload_max_dir_stack = 20,
    ignore_hidden = true,
    same_type = false,
	directory_mode = "auto",
    images = true,
    videos = true,
    audio = true,
    additional_image_exts = "",
    additional_video_exts = "",
    additional_audio_exts = "",
	-----OSD Messages Settings-----
	osd_duration = 2500,
	seek_osd = "osd-msg-bar",
	chapter_osd = "osd-msg-bar",
	autoskip_osd = "osd-msg-bar",
	playlist_osd = true,
	osd_msg = true,
	-----Keybind Settings-----
	toggle_autoload_keybind=[[ [""] ]],
	toggle_autoskip_keybind=[[ ["ctrl+."] ]],
	toggle_category_autoskip_keybind=[[ ["alt+."] ]],
	cancel_autoskip_countdown_keybind=[[ ["esc", "n"] ]],
	proceed_autoskip_countdown_keybind=[[ ["enter", "y"] ]],
	add_chapter_keybind=[[ ["n"] ]],
	remove_chapter_keybind=[[ ["alt+n"] ]],
	edit_chapter_keybind=[[ [""] ]],
	write_chapters_keybind=[[ ["ctrl+n"] ]],
	bake_chapters_keybind=[[ [""] ]],
	chapter_next_keybind=[[ ["ctrl+right"] ]],
	chapter_prev_keybind=[[ ["ctrl+left"] ]],
	smart_next_keybind=[[ [">"] ]],
	smart_prev_keybind=[[ ["<"] ]],
	silence_skip_keybind=[[ ["?"] ]],
}

local mp = require 'mp'
local msg = require 'mp.msg'
local utils = require 'mp.utils'
local options = require 'mp.options'
options.read_options(o, nil, function(list)
    split_option_exts(list.additional_video_exts, list.additional_audio_exts, list.additional_image_exts)
    if list.videos or list.additional_video_exts or
        list.audio or list.additional_audio_exts or
        list.images or list.additional_image_exts then
        create_extensions()
    end
    if list.directory_mode then
        validate_directory_mode()
    end
end)

if o.add_chapter_on_skip ~= false and o.add_chapter_on_skip ~= true then o.add_chapter_on_skip = utils.parse_json(o.add_chapter_on_skip) end
if o.modified_chapters_autosave ~= false and o.modified_chapters_autosave ~= true then o.modified_chapters_autosave = utils.parse_json(o.modified_chapters_autosave) end
o.last_chapter_skip_behavior = utils.parse_json(o.last_chapter_skip_behavior)
if utils.parse_json(o.skip) ~= nil then o.skip = utils.parse_json(o.skip) end
if utils.parse_json(o.categories) ~= nil then o.categories = utils.parse_json(o.categories) end
if o.skip_once ~= false and o.skip_once ~= true then o.skip_once = utils.parse_json(o.skip_once) end

if o.global_chapters_path:match('/:dir%%mpvconf%%') then --1.2# add variables for specifying path via user-config
	o.global_chapters_path = o.global_chapters_path:gsub('/:dir%%mpvconf%%', mp.find_config_file('.'))
elseif o.global_chapters_path:match('/:dir%%script%%') then
	o.global_chapters_path = o.global_chapters_path:gsub('/:dir%%script%%', debug.getinfo(1).source:match('@?(.*/)'))
elseif o.global_chapters_path:match('/:var%%(.*)%%') then
	local os_variable = o.global_chapters_path:match('/:var%%(.*)%%')
	o.global_chapters_path = o.global_chapters_path:gsub('/:var%%(.*)%%', os.getenv(os_variable))
end

o.toggle_autoload_keybind = utils.parse_json(o.toggle_autoload_keybind)
o.toggle_autoskip_keybind = utils.parse_json(o.toggle_autoskip_keybind)
o.cancel_autoskip_countdown_keybind = utils.parse_json(o.cancel_autoskip_countdown_keybind)
o.proceed_autoskip_countdown_keybind = utils.parse_json(o.proceed_autoskip_countdown_keybind)
o.toggle_category_autoskip_keybind = utils.parse_json(o.toggle_category_autoskip_keybind)
o.add_chapter_keybind = utils.parse_json(o.add_chapter_keybind)
o.remove_chapter_keybind = utils.parse_json(o.remove_chapter_keybind)
o.write_chapters_keybind = utils.parse_json(o.write_chapters_keybind)
o.edit_chapter_keybind = utils.parse_json(o.edit_chapter_keybind)
o.bake_chapters_keybind = utils.parse_json(o.bake_chapters_keybind)
o.chapter_prev_keybind = utils.parse_json(o.chapter_prev_keybind)
o.chapter_next_keybind = utils.parse_json(o.chapter_next_keybind)
o.smart_prev_keybind = utils.parse_json(o.smart_prev_keybind)
o.smart_next_keybind = utils.parse_json(o.smart_next_keybind)
o.silence_skip_keybind = utils.parse_json(o.silence_skip_keybind)

package.path = mp.command_native({"expand-path", "~~/script-modules/?.lua;"}) .. package.path
local user_input_module, input = pcall(require, "user-input-module")

if o.osd_duration == -1 then o.osd_duration = (mp.get_property_number('osd-duration') or 1000) end
local speed_state = 1
local pause_state = false
local mute_state = false
local sub_state = nil
local secondary_sub_state = nil
local vid_state = nil
local skip_flag = false
local window_state = nil
local force_silence_skip = false
local initial_skip_time = 0
local initial_chapter_count = 0
local chapter_state = 'no-chapters'
local file_length = 0
local keep_open_state = "yes"
if mp.get_property("config") ~= "no" then keep_open_state = mp.get_property("keep-open") end
local osd_duration_default = (mp.get_property_number('osd-duration') or 1000)
local autoload_playlist = o.autoload_playlist
local autoskip_chapter = o.autoskip_chapter
local playlist_osd = false
local autoskip_playlist_osd = false
local g_playlist_pos = 0 
local g_opt_categories = o.categories
local g_opt_skip_once = false
o.autoskip_countdown = math.floor(o.autoskip_countdown)
local g_autoskip_countdown = o.autoskip_countdown
local g_autoskip_countdown_flag = false
local categories = {
	toggle = "",
	toggle_idx = "",
}
local autoskip_osd = o.autoskip_osd
if o.autoskip_osd == 'osd-msg-bar' then autoskip_osd = 'osd-bar' end
if o.autoskip_osd == 'osd-msg' then autoskip_osd = 'no-osd' end


-- utility functions --
function has_value(tab, val, array2d)
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

function esc_string(str)
	return str:gsub("([%p])", "%%%1")
end

function prompt_msg(text, duration)
	if not text then return end
	if not duration then duration = o.osd_duration end
    if o.osd_msg then mp.commandv("show-text", text, duration) end
	msg.info(text)
end

function bind_keys(keys, name, func, opts)
	if not keys then
		mp.add_forced_key_binding(keys, name, func, opts)
		return
	end
	
	for i = 1, #keys do
		if i == 1 then 
			mp.add_forced_key_binding(keys[i], name, func, opts)
		else
			mp.add_forced_key_binding(keys[i], name .. i, func, opts)
		end
	end
end

function unbind_keys(keys, name)
	if not keys then
		mp.remove_key_binding(name)
		return
	end
	
	for i = 1, #keys do
		if i == 1 then
			mp.remove_key_binding(name)
		else
			mp.remove_key_binding(name .. i)
		end
	end
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
			prompt_msg('Skipping Cancelled\nSilence less than minimum')
			return true
		end
		if o.max_skip_duration > 0 and skip_duration >= o.max_skip_duration then
			restoreProp(initial_skip_time)
			prompt_msg('Skipping Cancelled\nSilence is more than configured maximum')
			return true
		end
		return false
end

function setKeepOpenState()
	if o.silence_skip_to_end == "playlist-next" then
		mp.set_property("keep-open", "yes")
	else
		mp.set_property("keep-open", "always")
	end
end

function eofHandler(name, val)
    if val and skip_flag then
		if o.silence_skip_to_end == 'playlist-next' then
			restoreProp((mp.get_property_native('duration') or 0))
			if mp.get_property_native('playlist-playing-pos')+1 == mp.get_property_native('playlist-count') then
				prompt_msg('Skipped to end at ' .. mp.get_property_osd('duration'))
			else
				mp.commandv("playlist-next")
			end
		elseif o.silence_skip_to_end == 'cancel' then	
			prompt_msg('Skipping Cancelled\nSilence not detected')
			restoreProp(initial_skip_time)
		elseif o.silence_skip_to_end == 'pause' then
			prompt_msg('Skipped to end at ' .. mp.get_property_osd('duration'))
			restoreProp((mp.get_property_native('duration') or 0), true)
		end
	end
end

-- smart-skip main code --
function smartNext()
	if g_autoskip_countdown_flag and o.smart_next_proceed_countdown then proceed_autoskip(true) return end
	local next_action = "silence-skip"
	local chapters_count = (mp.get_property_number('chapters') or 0)
    local chapter  = (mp.get_property_number('chapter') or 0)
	local current_playlist = (mp.get_property_native('playlist-playing-pos')+1 or 0)
	local total_playlist = (mp.get_property_native('playlist-count') or 0)
	
	if chapter+2 <= chapters_count then
		next_action = 'chapter-next'
	elseif chapter+2 > chapters_count and (initial_chapter_count == 0 or chapters_count == 0 or force_silence_skip) then
		if chapters_count == 0 then force_silence_skip = true end
		next_action = 'silence-skip'
	elseif chapter+1 >= chapters_count then
		for i = 1, #o.last_chapter_skip_behavior do
			if o.last_chapter_skip_behavior[i] and o.last_chapter_skip_behavior[i][1] == chapter_state then
				next_action = o.last_chapter_skip_behavior[i][2]
				break
			end
		end
	end
	
	if next_action == 'playlist-next' and current_playlist == total_playlist then
		next_action = 'chapter-next'
	end
	
	if next_action == 'silence-skip' then
		silenceSkip()
	end
	if next_action == 'chapter-next' then
		mp.set_property('osd-duration', o.osd_duration)
		mp.commandv(o.chapter_osd, 'add', 'chapter', 1)
		mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end)
	end
	if next_action == 'playlist-next' then
		mp.command('playlist_next')
	end
end

function smartPrev()
	if skip_flag then restoreProp(initial_skip_time) return end
	if g_autoskip_countdown_flag and o.smart_prev_cancel_countdown then kill_chapterskip_countdown('osd') return end
	local chapters_count = (mp.get_property_number('chapters') or 0)
    local chapter  = (mp.get_property_number('chapter') or 0)
	local timepos = (mp.get_property_native("time-pos") or 0)

	if chapter-1 < 0 and timepos > 1 and chapters_count == 0 then
		mp.commandv('seek', 0, 'absolute', 'exact')
		
		mp.set_property('osd-duration', o.osd_duration)
		mp.commandv(o.seek_osd, "show-progress")
		mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end)
	elseif chapter-1 < 0 and timepos < 1 then
        mp.command('playlist_prev')
    elseif chapter-1 <= chapters_count then
		mp.set_property('osd-duration', o.osd_duration)
        mp.commandv(o.chapter_osd, 'add', 'chapter', -1)
		mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end)
    end
end

-- chapter-next/prev main code --
function chapterSeek(direction)
	if skip_flag and direction == -1 then restoreProp(initial_skip_time) return end

	local chapters_count = (mp.get_property_number('chapters') or 0)
    local chapter  = (mp.get_property_number('chapter') or 0)
	local timepos = (mp.get_property_native("time-pos") or 0)

    if chapter+direction < 0 and timepos > 1 and chapters_count == 0 then
		mp.commandv('seek', 0, 'absolute', 'exact')
		
		mp.set_property('osd-duration', o.osd_duration)
		mp.commandv(o.seek_osd, "show-progress")
		mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end)
	elseif chapter+direction < 0 and timepos < 1 then
	    mp.command('playlist_prev')
    elseif chapter+direction >= chapters_count then
		mp.command('playlist_next')
    else
        mp.set_property('osd-duration', o.osd_duration)
        mp.commandv(o.chapter_osd, 'add', 'chapter', direction)
		mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end)
    end
end

-- silence skip main code --
function silenceSkip(action)
	if skip_flag then if o.keybind_twice_cancel_skip then restoreProp(initial_skip_time) end return end
	initial_skip_time = (mp.get_property_native("time-pos") or 0)
	if math.floor(initial_skip_time) == math.floor(mp.get_property_native('duration') or 0) then return end	
	local width = mp.get_property_native("osd-width")
	local height = mp.get_property_native("osd-height")
	mp.set_property_native("geometry", ("%dx%d"):format(width, height))
	mp.commandv(o.seek_osd, "show-progress")
	
	mp.command(
		"no-osd af add @skiptosilence:lavfi=[silencedetect=noise=" ..
		o.silence_audio_level .. "dB:d=" .. o.silence_duration .. "]"
	)
	
	mp.observe_property("af-metadata/skiptosilence", "string", foundSilence)
	
	sub_state = mp.get_property("sub-visibility")
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
		if skip_flag then mp.commandv(o.seek_osd, "show-progress") end
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

	mp.add_timeout(0.05, function() prompt_msg('Skipped to silence 🕒 ' .. mp.get_property_osd("time-pos")) end)
	if o.add_chapter_on_skip == true or has_value(o.add_chapter_on_skip, chapter_state) then
		mp.add_timeout(0.05, add_chapter)
	end
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
	if not timepos then timepos = mp.get_property_number("time-pos") end
    local chapter_list = mp.get_property_native("chapter-list")
	
	if #chapter_list > 0 then
		for i = 1, #chapter_list do
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
    local path = mp.get_property("path")
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
	local path = mp.get_property("path")
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
    if not force and not chapters_modified then
        msg.debug("nothing to write")
        return
    end
	if initial_chapter_count == 0 and chapters_count == 0 then return end


    -- figure out the directory
    local chapters_dir
    if o.global_chapters then
        local dir = utils.file_info(o.global_chapters_path)
        if dir then
            if dir.is_dir then
                msg.debug("o.global_chapters_path exists:", o.global_chapters_path)
                chapters_dir = o.global_chapters_path
            else
                msg.error("o.global_chapters_path is not a directory")
                return
            end
        else
            msg.verbose("o.global_chapters_path doesn't exists:", o.global_chapters_path)
            if mkdir(o.global_chapters_path) then
                chapters_dir = o.global_chapters_path
            else
                return
            end
        end
    else
        chapters_dir = utils.split_path(mp.get_property("path"))
    end

    -- and the name
    local name = mp.get_property("filename")
    if o.hash_global_chapters and o.global_chapters then
        name = hash()
        if name == nil then
            msg.warn("hash function failed, fallback to filename")
            name = mp.get_property("filename")
        end
    end

    local chapters_file_path = utils.join_path(chapters_dir, name .. ".ffmetadata")
	--1.09#HERE I SHOULD ADD SOME SORT OF DELETE FUNCTION IN CASE CHAPTER COUNT IS 0
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
            prompt_msg('Chapters written to:' .. chapters_file_path)
        end
        return chapters_file_path
    else
        msg.error("error writing chapters file:", error)
        return
    end
end

function load_chapters()
    local path = mp.get_property("path")
    local expected_chapters_file = utils.join_path(utils.split_path(path), mp.get_property("filename") .. ".ffmetadata")

    msg.debug("looking for:", expected_chapters_file)

    local file = utils.file_info(expected_chapters_file)
	
    if file then
        msg.debug("found in the local directory, loading..")
        mp.set_property("file-local-options/chapters-file", expected_chapters_file)
		chapter_state = 'external-chapters'
        return
    end

    if not o.global_chapters then
        msg.debug("not in local, global chapters not enabled, aborting search")
        return
    end

    msg.debug("looking in the global directory")

    if o.hash_global_chapters then
        local hashed_path = hash()
        if hashed_path then
            expected_chapters_file = utils.join_path(o.global_chapters_path, hashed_path .. ".ffmetadata")
        else
            msg.debug("hash function failed, fallback to path")
            expected_chapters_file = utils.join_path(o.global_chapters_path, mp.get_property("filename") .. ".ffmetadata")
        end
    else
        expected_chapters_file = utils.join_path(o.global_chapters_path, mp.get_property("filename") .. ".ffmetadata")
    end

    msg.debug("looking for:", expected_chapters_file)

    file = utils.file_info(expected_chapters_file)

    if file then
        msg.debug("found in the global directory, loading..")
        mp.set_property("file-local-options/chapters-file", expected_chapters_file)
		chapter_state = 'external-chapters'
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
		prompt_msg('file written to ' .. output_path)
    else
        msg.error("failed to write file:\n", process.stderr)
    end
end

--modified fork of autoload script--
function toggle_autoload()
	if autoload_playlist == true then
		prompt_msg('○ Auto-Load Disabled')
		autoload_playlist = false
	elseif autoload_playlist == false then 
		prompt_msg('● Auto-Load Enabled')
		autoload_playlist = true
	end
	if autoload_playlist then find_and_add_entries() end
end

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

function validate_directory_mode()
    if o.directory_mode ~= "recursive" and o.directory_mode ~= "lazy" and o.directory_mode ~= "ignore" then
        o.directory_mode = nil
    end
end
validate_directory_mode()

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

table.append = function(t1, t2)
    local t1_size = #t1
    for i = 1, #t2 do
        t1[t1_size + i] = t2[i]
    end
end

-- alphanum sorting for humans in Lua
-- http://notebook.kulchenko.com/algorithms/alphanumeric-natural-sorting-for-humans-in-lua

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
local added_entries = {}
local autoloaded_dir = nil

function scan_dir(path, current_file, dir_mode, separator, dir_depth, total_files, extensions)
    if dir_depth == o.autoload_max_dir_stack then
        return
    end
    msg.trace("scanning: " .. path)
    local files = utils.readdir(path, "files") or {}
    local dirs = dir_mode ~= "ignore" and utils.readdir(path, "dirs") or {}
    local prefix = path == "." and "" or path
    table.filter(files, function (v)
        -- The current file could be a hidden file, ignoring it doesn't load other
        -- files from the current directory.
        if (o.ignore_hidden and not (prefix .. v == current_file) and string.match(v, "^%.")) then
            return false
        end
        local ext = get_extension(v)
        if ext == nil then
            return false
        end
        return extensions[string.lower(ext)]
    end)
    table.filter(dirs, function(d)
        return not ((o.ignore_hidden and string.match(d, "^%.")))
    end)
    alphanumsort(files)
    alphanumsort(dirs)

    for i, file in ipairs(files) do
        files[i] = prefix .. file
    end

    table.append(total_files, files)
    if dir_mode == "recursive" then
        for _, dir in ipairs(dirs) do
            scan_dir(prefix .. dir .. separator, current_file, dir_mode,
                     separator, dir_depth + 1, total_files, extensions)
        end
    else
        for i, dir in ipairs(dirs) do
            dirs[i] = prefix .. dir
        end
        table.append(total_files, dirs)
    end
end

function find_and_add_entries()
    local path = mp.get_property("path", "")
    local dir, filename = utils.split_path(path)
    msg.trace(("dir: %s, filename: %s"):format(dir, filename))
    if not autoload_playlist then
        msg.verbose("stopping: autoload_playlist is disabled")
        return
    elseif #dir == 0 then
        msg.verbose("stopping: not a local path")
        return
    end

    local pl_count = mp.get_property_number("playlist-count", 1)
    this_ext = get_extension(filename)
    -- check if this is a manually made playlist
    if (pl_count > 1 and autoloaded == nil) or
       (pl_count == 1 and EXTENSIONS[string.lower(this_ext)] == nil) then
        msg.verbose("stopping: manually made playlist")
        return
    else
        if pl_count == 1 then
            autoloaded = true
            autoloaded_dir = dir
            added_entries = {}
        end
    end

    local extensions = {}
    if o.same_type then
        if EXTENSIONS_VIDEO[string.lower(this_ext)] ~= nil then
            extensions = EXTENSIONS_VIDEO
        elseif EXTENSIONS_AUDIO[string.lower(this_ext)] ~= nil then
            extensions = EXTENSIONS_AUDIO
        else
            extensions = EXTENSIONS_IMAGES
        end
    else
        extensions = EXTENSIONS
    end

    local pl = mp.get_property_native("playlist", {})
    local pl_current = mp.get_property_number("playlist-pos-1", 1)
    msg.trace(("playlist-pos-1: %s, playlist: %s"):format(pl_current,
        utils.to_string(pl)))

    local files = {}
    do
        local dir_mode = o.directory_mode or mp.get_property("directory-mode", "lazy")
        local separator = mp.get_property_native("platform") == "windows" and "\\" or "/"
        scan_dir(autoloaded_dir, path, dir_mode, separator, 0, files, extensions)
    end

    if next(files) == nil then
        msg.verbose("no other files or directories in directory")
        return
    end

    -- Find the current pl entry (dir+"/"+filename) in the sorted dir list
    local current
    for i = 1, #files do
        if files[i] == path then
            current = i
            break
        end
    end
    if current == nil then
        return
    end
    msg.trace("current file position in files: "..current)

    -- treat already existing playlist entries, independent of how they got added
    -- as if they got added by autoload
    for _, entry in ipairs(pl) do
        added_entries[entry.filename] = true
    end

    local append = {[-1] = {}, [1] = {}}
    for direction = -1, 1, 2 do -- 2 iterations, with direction = -1 and +1
        for i = 1, o.autoload_max_entries do
            local pos = current + i * direction
            local file = files[pos]
            if file == nil or file[1] == "." then
                break
            end

            -- skip files that are/were already in the playlist
            if not added_entries[file] then
                if direction == -1 then
                    msg.info("Prepending " .. file)
                    table.insert(append[-1], 1, {file, pl_current + i * direction + 1})
                else
                    msg.info("Adding " .. file)
                    if pl_count > 1 then
                        table.insert(append[1], {file, pl_current + i * direction - 1})
                    else
                        mp.commandv("loadfile", file, "append")
                    end
                end
            end
            added_entries[file] = true
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

function matches(i, title)
	local opt_skip = o.skip
	if type(o.skip) == 'table' then
		for i=1, #o.skip do
			if o.skip[i] and o.skip[i][1] == chapter_state then
				opt_skip = o.skip[i][2]
				break
			end
		end
	end

    for category in string.gmatch(opt_skip, " *([^;]*[^; ]) *") do
		if categories[category:lower()] then
            if category:lower() == "idx-" or category:lower() == "toggle_idx" then
			   for pattern in string.gmatch(categories[category:lower()], "([^/]+)") do
                    if tonumber(pattern) == i then
                        return true
                    end
                end
			else
                if title then
                    for pattern in string.gmatch(categories[category:lower()], "([^/]+)") do
                        if string.match(title, pattern) then
                            return true
                        end
                    end
                end
            end
		end
    end
end

local skipped = {}
local parsed = {}

function prep_chapterskip_var()
	if chapter_state == 'no-chapters' then return end
	g_opt_categories = o.categories
	
	g_opt_skip_once = false
	if o.skip_once == true or o.skip_once == false then
		g_opt_skip_once = o.skip_once
	elseif has_value(o.skip_once, chapter_state) then
		g_opt_skip_once = true;
	end
	
	if type(o.categories) == 'table' then
		for i=1, #o.categories do
			if o.categories[i] and o.categories[i][1] == chapter_state then
				g_opt_categories = o.categories[i][2]
				break
			end
		end
	end
	
	for category in string.gmatch(g_opt_categories, "([^;]+)") do
        local name, patterns = string.match(category, " *([^+>]*[^+> ]) *[+>](.*)")
        if name then
            categories[name:lower()] = patterns
        elseif not parsed[category] then
            mp.msg.warn("Improper category definition: " .. category)
        end
        parsed[category] = true
    end
end

function start_chapterskip_countdown(text, duration)
	g_autoskip_countdown_flag = true
    g_autoskip_countdown = g_autoskip_countdown - 1
	
	if o.autoskip_countdown_graceful and (g_autoskip_countdown <= 0) then kill_chapterskip_countdown(); mp.osd_message('',0) return end
	
	if (g_autoskip_countdown < 0) then kill_chapterskip_countdown(); mp.osd_message('',0) return end
	
	text = text:gsub("%%countdown%%", g_autoskip_countdown)
	prompt_msg(text, 2000)
end

function kill_chapterskip_countdown(action)
	if not g_autoskip_countdown_flag then return end
	if action == 'osd' and o.autoskip_osd ~= 'no-osd' then
		prompt_msg('○ Auto-Skip Cancelled')
	end
	if g_autoskip_timer ~= nil then
		g_autoskip_timer:kill()
	end
	unbind_keys(o.cancel_autoskip_countdown_keybind, 'cancel-autoskip-countdown')
	unbind_keys(o.proceed_autoskip_countdown_keybind, 'proceed-autoskip-countdown')
	g_autoskip_countdown = o.autoskip_countdown
	g_autoskip_countdown_flag = false
end

function chapterskip(_, current, countdown)
	if chapter_state == 'no-chapters' then return end
    if not autoskip_chapter then return end
	if g_autoskip_countdown_flag then kill_chapterskip_countdown('osd') end
	if not countdown then countdown = o.autoskip_countdown end

	local chapters = mp.get_property_native("chapter-list")
    local skip = false
	local consecutive_i = 0
	
    for i=0, #chapters do
		if (not g_opt_skip_once or not skipped[i]) and i == 0 and chapters[i+1] and matches(i, chapters[i+1].title) then
		    if i == current + 1 or skip == i - 1 then
                if skip then
                    skipped[skip] = true
                end
                skip = i
				consecutive_i = consecutive_i+1
            end
        elseif (not g_opt_skip_once or not skipped[i]) and chapters[i] and matches(i, chapters[i].title) then
            if i == current + 1 or skip == i - 1 then
                if skip then
                    skipped[skip] = true
                end
                skip = i
				consecutive_i = consecutive_i+1
            end
        elseif skip and countdown <= 0 then
			mp.set_property('osd-duration', o.osd_duration)
			mp.commandv(autoskip_osd, "show-progress")
			mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end)
			
			if o.autoskip_osd == 'osd-msg-bar' or o.autoskip_osd == 'osd-msg' then
				if consecutive_i > 1 then
					local autoskip_osd_string = ''
					for j=consecutive_i, 1, -1  do
						local chapter_title = ''
						if chapters[i-j] then chapter_title = chapters[i-j].title end
						autoskip_osd_string=(autoskip_osd_string..'\n  ➤ Chapter ('..i-j..') '..chapter_title)
					end
					prompt_msg('● Auto-Skip'..autoskip_osd_string)
				else
					prompt_msg('➤ Auto-Skip: Chapter '.. mp.command_native({'expand-text', '${chapter}'}))
				end
			end
			mp.set_property("time-pos", chapters[i].time)
            skipped[skip] = true
            return
        elseif skip and countdown > 0 then
			g_autoskip_countdown_flag = true
			bind_keys(o.cancel_autoskip_countdown_keybind, "cancel-autoskip-countdown", function() kill_chapterskip_countdown('osd') return end)
			
			local autoskip_osd_string = ''
			local autoskip_graceful_osd = ''
			if o.autoskip_countdown_graceful then autoskip_graceful_osd = 'Press Keybind to:\n' end
			if o.autoskip_osd == 'osd-msg-bar' or o.autoskip_osd == 'osd-msg' then
				if consecutive_i > 1 and o.autoskip_countdown_bulk then
					local autoskip_osd_string = ''
					for j=consecutive_i, 1, -1  do
						local chapter_title = ''
						if chapters[i-j] then chapter_title = chapters[i-j].title end
						autoskip_osd_string=(autoskip_osd_string..'\n  ▷ Chapter ('..i-j..') '..chapter_title)
					end
					prompt_msg(autoskip_graceful_osd..'○ Auto-Skip'..' in "'..o.autoskip_countdown..'"'..autoskip_osd_string, 2000)
					g_autoskip_timer = mp.add_periodic_timer(1, function () 
						start_chapterskip_countdown(autoskip_graceful_osd..'○ Auto-Skip'..' in "%countdown%"'..autoskip_osd_string, 2000)
					end)
				else
					prompt_msg(autoskip_graceful_osd..'▷ Auto-Skip in "'..o.autoskip_countdown..'": Chapter '.. mp.command_native({'expand-text', '${chapter}'}), 2000)
					g_autoskip_timer = mp.add_periodic_timer(1, function () 
						start_chapterskip_countdown(autoskip_graceful_osd..'▷ Auto-Skip in "%countdown%": Chapter '.. mp.command_native({'expand-text', '${chapter}'}), 2000)
					end)
				end
			end
			function proceed_autoskip(force)
				if not g_autoskip_countdown_flag then kill_chapterskip_countdown() return end
				if g_autoskip_countdown > 1 and not force then return end
				
				mp.set_property('osd-duration', o.osd_duration)
				mp.commandv(autoskip_osd, "show-progress")
				mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end)
				if o.autoskip_osd == 'osd-msg-bar' or o.autoskip_osd == 'osd-msg' then
					if consecutive_i > 1 and o.autoskip_countdown_bulk then
						local autoskip_osd_string = ''
						for j=consecutive_i, 1, -1  do
							local chapter_title = ''
							if chapters[i-j] then chapter_title = chapters[i-j].title end
							autoskip_osd_string=(autoskip_osd_string..'\n  ➤ Chapter ('..i-j..') '..chapter_title)
						end
						prompt_msg('● Auto-Skip'..autoskip_osd_string)
					else
						prompt_msg('➤ Auto-Skip: Chapter '.. mp.command_native({'expand-text', '${chapter}'}))
					end
				end
				if consecutive_i > 1 and o.autoskip_countdown_bulk then
					mp.set_property("time-pos", chapters[i].time)
				else
					mp.commandv('no-osd', 'add', 'chapter', 1)
				end
				skipped[skip] = true
				kill_chapterskip_countdown()
			end
			bind_keys(o.proceed_autoskip_countdown_keybind, "proceed-autoskip-countdown", function() proceed_autoskip(true) return end)
			if o.autoskip_countdown_graceful then return end
			mp.add_timeout(countdown, proceed_autoskip)
            return
        end
    end
    if skip and countdown <= 0 then
        if mp.get_property_native("playlist-count") == mp.get_property_native("playlist-pos-1") then
            return mp.set_property("time-pos", mp.get_property_native("duration"))
        end
        mp.commandv("playlist-next")
		if o.autoskip_osd ~= 'no-osd' then autoskip_playlist_osd = true end
    elseif skip and countdown > 0 then
		g_autoskip_countdown_flag = true
		bind_keys(o.cancel_autoskip_countdown_keybind, "cancel-autoskip-countdown", function() kill_chapterskip_countdown('osd') return end)
		
		if o.autoskip_osd == 'osd-msg-bar' or o.autoskip_osd == 'osd-msg' then 
			local autoskip_graceful_osd = ''
			if o.autoskip_countdown_graceful then autoskip_graceful_osd = 'Press Keybind to:\n' end
			if consecutive_i > 1 and o.autoskip_countdown_bulk then
				local i = (mp.get_property_number('chapters')+1 or 0)
				local autoskip_osd_string = ''
				for j=consecutive_i, 1, -1  do
					local chapter_title = ''
					if chapters[i-j] then chapter_title = chapters[i-j].title end
					autoskip_osd_string=(autoskip_osd_string..'\n  ▷ Chapter ('..i-j..') '..chapter_title)
				end
				prompt_msg(autoskip_graceful_osd..'○ Auto-Skip'..' in "'..o.autoskip_countdown..'"'..autoskip_osd_string, 2000)
				g_autoskip_timer = mp.add_periodic_timer(1, function ()
					start_chapterskip_countdown(autoskip_graceful_osd..'○ Auto-Skip'..' in "%countdown%"'..autoskip_osd_string, 2000)
				end)
			else
				prompt_msg(autoskip_graceful_osd..'▷ Auto-Skip in "'..o.autoskip_countdown..'": Chapter '.. mp.command_native({'expand-text', '${chapter}'}), 2000)
				g_autoskip_timer = mp.add_periodic_timer(1, function () 
					start_chapterskip_countdown(autoskip_graceful_osd..'▷ Auto-Skip in "%countdown%": Chapter '.. mp.command_native({'expand-text', '${chapter}'}), 2000)
				end)
			end
		end
		function proceed_autoskip(force)
			if not g_autoskip_countdown_flag then return end
			if g_autoskip_countdown > 1 and not force then return end

			mp.set_property('osd-duration', o.osd_duration)
			mp.commandv(autoskip_osd, "show-progress")
			mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end)
			if consecutive_i > 1 and o.autoskip_countdown_bulk then
				if mp.get_property_native("playlist-count") == mp.get_property_native("playlist-pos-1") then
					return mp.set_property("time-pos", mp.get_property_native("duration"))
				end
				mp.commandv("playlist-next")
			else
				local current_chapter = (mp.get_property_number("chapter") + 1 or 0)
				local chapters_count = (mp.get_property_number('chapters') or 0)
				
				if current_chapter == chapters_count then
					if mp.get_property_native("playlist-count") == mp.get_property_native("playlist-pos-1") then
						return mp.set_property("time-pos", mp.get_property_native("duration"))
					end
					mp.commandv("playlist-next")
				else
					mp.commandv('no-osd', 'add', 'chapter', 1)
				end
			end
			if o.autoskip_osd ~= 'no-osd' then autoskip_playlist_osd = true end
			kill_chapterskip_countdown()
		end
		bind_keys(o.proceed_autoskip_countdown_keybind, "proceed-autoskip-countdown", function() proceed_autoskip(true) return end)
		if o.autoskip_countdown_graceful then return end
		mp.add_timeout(countdown, proceed_autoskip)
    end
end

function toggle_autoskip()
	if autoskip_chapter == true then
		prompt_msg('○ Auto-Skip Disabled')
		autoskip_chapter = false
		if g_autoskip_countdown_flag then kill_chapterskip_countdown() end
	elseif autoskip_chapter == false then
		prompt_msg('● Auto-Skip Enabled')
		autoskip_chapter = true
	end
end

function toggle_category_autoskip()
	if chapter_state == 'no-chapters' then return end
	if not mp.get_property_number("chapter") then return end
	local chapters = mp.get_property_native("chapter-list")
	local current_chapter = (mp.get_property_number("chapter") + 1 or 0)
	
	local chapter_title = tostring(current_chapter)
	if current_chapter > 0 and chapters[current_chapter].title and chapters[current_chapter].title ~= '' then
		chapter_title = chapters[current_chapter].title
	end

	local found_i = 0
	if matches(current_chapter, chapter_title) then
		for category in string.gmatch(g_opt_categories, "([^;]+)") do
			local name, patterns = string.match(category, " *([^+>]*[^+> ]) *[+>](.*)")

			for pattern in string.gmatch(patterns, "([^/]+)") do
				if string.match(chapter_title:lower(), pattern:lower()) then
					g_opt_categories = g_opt_categories:gsub(esc_string(pattern)..'/?', "")
					found_i = found_i + 1
				end
			end
		end
		
		for category in string.gmatch(g_opt_categories, "([^;]+)") do
			local name, patterns = string.match(category, " *([^+>]*[^+> ]) *[+>](.*)")
			if name then
				categories[name:lower()] = patterns
			elseif not parsed[category] then
				mp.msg.warn("Improper category definition: " .. category)
			end
			parsed[category] = true
		end
		
		if type(o.categories) == 'table' then
			for i=1, #o.categories do
				if o.categories[i] and o.categories[i][1] == chapter_state then
					o.categories[i][2] = g_opt_categories
					break
				end
			end
		else
			o.categories = g_opt_categories
		end
	end
	if current_chapter > 0 and chapters[current_chapter].title and chapters[current_chapter].title ~= '' then
		if found_i > 0 or string.match(categories.toggle, esc_string(chapter_title)) then
			prompt_msg('○ Removed from Auto-Skip\n  ▷ Chapter: '..chapter_title)
			categories.toggle = categories.toggle:gsub(esc_string("^"..chapter_title.."/"), "")
			if g_autoskip_countdown_flag then kill_chapterskip_countdown() end
		else
			prompt_msg('● Added to Auto-Skip\n  ➔ Chapter: '..chapter_title)
			categories.toggle = categories.toggle.."^"..chapter_title.."/"
		end
	else
		if found_i > 0 or string.match(categories.toggle_idx, esc_string(chapter_title)) then
			prompt_msg('○ Removed from Auto-Skip\n  ▷ Chapter: '..chapter_title)
			categories.toggle_idx = categories.toggle_idx:gsub(esc_string(chapter_title.."/"), "")
			if g_autoskip_countdown_flag then kill_chapterskip_countdown() end
		else
			prompt_msg('● Added to Auto-Skip\n  ➔ Chapter: '..chapter_title)
			categories.toggle_idx = categories.toggle_idx..chapter_title.."/"
		end
	end
end

-- HOOKS --------------------------------------------------------------------
if user_input_module then mp.add_hook("on_unload", 50, function () input.cancel_user_input() end) end -- chapters.lua
mp.register_event("start-file", find_and_add_entries) -- autoload.lua
mp.observe_property("chapter", "number", chapterskip) -- chapterskip.lua

-- smart skip events / properties / hooks --

mp.register_event('file-loaded', function()
	file_length = (mp.get_property_native('duration') or 0)
	if o.playlist_osd and g_playlist_pos > 0 then playlist_osd = true end
	if playlist_osd and not autoskip_playlist_osd then
		prompt_msg('['..mp.command_native({'expand-text', '${playlist-pos-1}'})..'/'..mp.command_native({'expand-text', '${playlist-count}'})..'] '..mp.command_native({'expand-text', '${filename}'}))
	end
	if autoskip_playlist_osd then
		prompt_msg('➤ Auto-Skip\n['..mp.command_native({'expand-text', '${playlist-pos-1}'})..'/'..mp.command_native({'expand-text', '${playlist-count}'})..'] '..mp.command_native({'expand-text', '${filename}'}))
	end
	playlist_osd = false
	autoskip_playlist_osd = false
	force_silence_skip = false
	skipped = {}
	initial_chapter_count = mp.get_property_number("chapter-list/count")
	if initial_chapter_count > 0 and chapter_state ~= 'external-chapters' then chapter_state = 'internal-chapters' end
	prep_chapterskip_var()
end)

mp.add_hook("on_load", 50, function()
	if o.external_chapters_autoload then load_chapters() end
end)

mp.observe_property('pause', 'bool', function(name, value)
	if value and skip_flag then
		restoreProp(initial_skip_time, true)
	end
	if g_autoskip_countdown_flag then kill_chapterskip_countdown('osd') end
end)

mp.add_hook('on_unload', 9, function()
	if o.modified_chapters_autosave == true or has_value(o.modified_chapters_autosave, chapter_state) then write_chapters(false) end
	mp.set_property("keep-open", keep_open_state)
	chapter_state = 'no-chapters'
	g_playlist_pos = (mp.get_property_native('playlist-playing-pos')+1 or 0)
	kill_chapterskip_countdown()
end)

mp.register_event('seek', function()
	if g_autoskip_countdown_flag then kill_chapterskip_countdown('osd') end
end)

mp.observe_property('eof-reached', 'bool', eofHandler)

-- BINDINGS --------------------------------------------------------------------

bind_keys(o.toggle_autoload_keybind, 'toggle-autoload', toggle_autoload)
bind_keys(o.toggle_autoskip_keybind, "toggle-autoskip", toggle_autoskip)
bind_keys(o.toggle_category_autoskip_keybind, "toggle-category-autoskip", toggle_category_autoskip)
bind_keys(o.add_chapter_keybind, "add-chapter", add_chapter)
bind_keys(o.remove_chapter_keybind, "remove-chapter", remove_chapter)
bind_keys(o.write_chapters_keybind, "write-chapters", function () write_chapters(true) end)
bind_keys(o.edit_chapter_keybind, "edit-chapter", edit_chapter)
bind_keys(o.bake_chapters_keybind, "bake-chapters", bake_chapters)
bind_keys(o.chapter_prev_keybind, "chapter-prev", function() chapterSeek(-1) end)
bind_keys(o.chapter_next_keybind, "chapter-next", function() chapterSeek(1) end)
bind_keys(o.smart_prev_keybind, "smart-prev", smartPrev)
bind_keys(o.smart_next_keybind, "smart-next", smartNext)
bind_keys(o.silence_skip_keybind, "silence-skip", silenceSkip)
