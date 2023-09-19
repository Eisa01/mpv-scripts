-- Copyright (c) 2023, Eisa AlAwadhi
-- License: BSD 2-Clause License
-- Creator: Eisa AlAwadhi
-- Project: SmartSkip
-- Version: 1.16
-- Date: 19-09-2023

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
	keybind_twice_cancel_skip = true, --1.02# (yes/no) press keybind again silence-skip is active to cancel
	skip_to_end_behavior = "playlist-next",
	add_chapter_on_skip = true, --1.07# add the following options --- (yes/no) or specify types ["no-chapters", "internal-chapters", "external-chapters"]. e.g.: [[ ["no-chapters", "external-chapters"] ]])
	force_mute_on_skip = false,
	--SmartSkip user config--
	last_chapter_skip_behavior=[[ [ ["no-chapters", "silence-skip"], ["internal-chapters", "playlist-next"], ["external-chapters", "silence-skip"] ] ]],--1.09# Available options [[ [ ["no-chapters", "silence-skip"], ["internal-chapters", "playlist-next"], ["external-chapters", "chapter-next"] ] ]] -- it defaults to silence-skip so if dont define external-chapters it will be silence-skip
	--chapters user config--
    external_chapters_autoload = true, --0.15# rename
    modified_chapters_autosave=[[ ["no-chapters", "external-chapters"] ]], --1.06# add the following options --- (yes/no) or specify types ["no-chapters", "internal-chapters", "external-chapters"])
    global_chapters = true, -- save all chapter files in a single global directory or next to the playback file
    chapters_dir = mp.command_native({"expand-path", "~~home/chapters"}),
    hash = true, -- hash works only with global_chapters enabled
    add_chapter_ask_title = false, -- ask for title or leave it empty
	add_chapter_pause_for_input = false, -- pause the playback when asking for chapter title
    add_chapter_placeholder_title = "Chapter ", -- placeholder when asking for title of a new chapter
	--chapters auto skip user config--
    autoskip_chapter = true, --(yes/no) -- removed option for based on chapters
	autoskip_countdown = 3, --(number) in seconds, countdown before initiating autoskip
	autoskip_countdown_bulk = true, --(yes/no) coundown seperately for each consecutive chapter or bulk them together in 1 countdown
	autoskip_countdown_graceful = false, --(yes/no) only sends the notification without forcing autoskip
    skip_once = false, --(yes/no) or specify types e.g.: [[ ["internal-chapters", "external-chapters"] ]])
	categories=[[ [ ["internal-chapters", "prologue>Prologue/^Intro; opening>^OP/ OP$/^Opening; ending>^ED/ ED$/^Ending; preview>Preview$"], ["external-chapters", "idx->0/2"] ] ]], --0.16# write the string for any chapter type, e.g.: categories = "prologue>Prologue/^Intro; opening>OP/ OP$/^Opening; ending>^ED/ ED$/^Ending; preview>Preview$; idx->0/2", or specify categories for each chapter.
	skip=[[ [ ["internal-chapters", "opening;ending;preview;toggle;toggle_idx"], ["external-chapters", "toggle;toggle_idx;opening;idx-"] ] ]], -- write the string .e.g: skip = "opening;ending", OR define the skip category for each chapter type: [[ [ ["internal-chapters", "prologue;ending"], ["external-chapters", "idx-"] ] ]]. idx- followed by the chapter index to autoskip based on index. toggle is for categories toggled during playback.
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
	osd_duration = 2500, --duration for the osd message in milliseconds, applies to all osd_messages, -1 reverts to --osd-duration
	--keybinds--
	toggle_autoload_keybind=[[ [""] ]],
	toggle_autoskip_keybind=[[ ["ctrl+."] ]],
	cancel_autoskip_countdown_keybind=[[ ["esc", "n"] ]],
	proceed_autoskip_countdown_keybind=[[ ["enter", "y"] ]],
	toggle_category_autoskip_keybind=[[ ["alt+."] ]],
	add_chapter_keybind=[[ ["n"] ]],
	remove_chapter_keybind=[[ ["alt+n"] ]],
	write_chapters_keybind=[[ ["ctrl+n"] ]],
	edit_chapter_keybind=[[ [""] ]],
	bake_chapters_keybind=[[ [""] ]],
	chapter_prev_keybind=[[ ["ctrl+left"] ]],
	chapter_next_keybind=[[ ["ctrl+right"] ]],
	smart_prev_keybind=[[ ["<"] ]],
	smart_next_keybind=[[ [">"] ]],
	silence_skip_keybind=[[ ["?"] ]],
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
if o.skip_once ~= false and o.skip_once ~= true then o.skip_once = utils.parse_json(o.skip_once) end --0.18 yes/no + json for skip_once

o.toggle_autoload_keybind = utils.parse_json(o.toggle_autoload_keybind)
o.toggle_autoskip_keybind = utils.parse_json(o.toggle_autoskip_keybind)
o.cancel_autoskip_countdown_keybind = utils.parse_json(o.cancel_autoskip_countdown_keybind)
o.proceed_autoskip_countdown_keybind = utils.parse_json(o.proceed_autoskip_countdown_keybind)
o.toggle_category_autoskip_keybind = utils.parse_json(o.toggle_category_autoskip_keybind)
o.add_chapter_keybind = utils.parse_json(o.add_chapter_keybind)
o.remove_chapter_keybind = utils.parse_json(o.remove_chapter_keybind) --1.14# added remove_chapter again, mistakenly it was removed
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

if o.osd_duration == -1 then o.osd_duration = (mp.get_property_number('osd-duration') or 1000) end --1.05# actually -1 should automatically get osd-duration, however perhaps when not using show-text it might not be the case, well nothing to lose by having this.
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
local osd_duration_default = (mp.get_property_number('osd-duration') or 1000) --1.05# get the default osd_duration to revert
local autoload_playlist = o.autoload_playlist --0.19# for activate autoload keybind
local autoskip_chapter = o.autoskip_chapter --1.0# to make autoskip_chapter toggle-able
local playlist_osd = false --1.01# for fixing universal playlist-osd
local autoskip_playlist_osd = false --1.01# for custom autoskip_playlist_osd
local g_playlist_pos = 0 --1.01# detect change in playlist to show osd
local g_opt_categories = o.categories --1.05 change to global variable initiate as opt_categories
local g_opt_skip_once = false --1.05# change to global variable and call once only on file load
o.autoskip_countdown = math.floor(o.autoskip_countdown) --1.14# floor it so that countdown is restricted to be by seconds
local g_autoskip_countdown = o.autoskip_countdown --1.07# initiate as the user configured
local g_autoskip_countdown_flag = false --1.09# initiate the flag as false
local categories = { --1.02# added default as a pre-defined category
	toggle = "",
	toggle_idx = "",
}

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

function esc_string(str)
	return str:gsub("([%p])", "%%%1")
end

function prompt_msg(text, duration) --1.05# convert osd_messages into function
	if not text then return end --1.05# text is mandotary
	if not duration then duration = o.osd_duration end --1.05# initiate with osd_duration as default
    if o.osd_msg then mp.commandv("show-text", text, duration) end
	msg.info(text)
end

function bind_keys(keys, name, func, opts) --1.11# for bind keys in user settings
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

function unbind_keys(keys, name) --1.11# for unbind keys that are defined in user settings
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
				prompt_msg('Skipped to end at ' .. mp.get_property_osd('duration'))
			else
				mp.commandv("playlist-next")
			end
		elseif o.skip_to_end_behavior == 'cancel' then	
			prompt_msg('Skipping Cancelled\nSilence not detected')
			restoreProp(initial_skip_time)
		elseif o.skip_to_end_behavior == 'pause' then
			prompt_msg('Skipped to end at ' .. mp.get_property_osd('duration'))
			restoreProp((mp.get_property_native('duration') or 0), true)
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
		mp.set_property('osd-duration', o.osd_duration) --1.05# change osd bar duration (needs to change the universal osd-duration)
		mp.commandv(o.chapter_osd, 'add', 'chapter', 1)
		mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end) --1.05# revert the change to osd, required mp.add_timeout to give show-progress time to execute (at least requires 0.058 here) - putting it at 0.07 just to be safe
	end
	if next_action == 'playlist-next' then
		mp.command('playlist_next')
	end
end

function smartPrev() --1.10# changed to smartPrev to only handle cases where previous chapter / playlist is needed
	if skip_flag then restoreProp(initial_skip_time) return end --0.11# cancel skip to silence if its on-going
	local chapters_count = (mp.get_property_number('chapters') or 0)
    local chapter  = (mp.get_property_number('chapter') or 0)
	local timepos = (mp.get_property_native("time-pos") or 0)

	if chapter-1 < 0 and timepos > 1 and chapters_count == 0 then --0.11# made the if statement more clear
		mp.commandv('seek', 0, 'absolute', 'exact')
		
		mp.set_property('osd-duration', o.osd_duration) --1.05# change osd bar duration (needs to change the universal osd-duration)
		mp.commandv(o.seek_osd, "show-progress")
		mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end) --1.05# revert the change to osd, required mp.add_timeout to give show-progress time to execute (at least requires 0.058 here) - putting it at 0.07 just to be safe
	elseif chapter-1 < 0 and timepos < 1 then --1.10# only go to previous playlist if its less than 1 second, otherwise chapter will trigger (perhaps add a check to exit function doing nothing when in first playlist entry)
        mp.command('playlist_prev')
    elseif chapter-1 <= chapters_count then --1.10# if there is previous chapter then go to it
		mp.set_property('osd-duration', o.osd_duration) --1.05# change osd bar duration (needs to change the universal osd-duration)
        mp.commandv(o.chapter_osd, 'add', 'chapter', -1) --added OSD bar in addition to msg
		mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end) --1.05# revert the change to osd, required mp.add_timeout to give show-progress time to execute (at least requires 0.058 here) - putting it at 0.07 just to be safe
    end
end

-- chapter-next/prev main code --
function chapterSeek(direction) --0.14# change variables to be same as smartPrev
	if skip_flag and direction == -1 then restoreProp(initial_skip_time) return end --1.02# cancel skip to silence if its on-going when going back

	local chapters_count = (mp.get_property_number('chapters') or 0)
    local chapter  = (mp.get_property_number('chapter') or 0)
	local timepos = (mp.get_property_native("time-pos") or 0)

    if chapter+direction < 0 and timepos > 1 and chapters_count == 0 then --0.11# allows chapterSeek to go to begining of file even if no chapter and before first chapter
		mp.commandv('seek', 0, 'absolute', 'exact')
		
		mp.set_property('osd-duration', o.osd_duration) --1.05# change osd bar duration (needs to change the universal osd-duration)
		mp.commandv(o.seek_osd, "show-progress")
		mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end) --1.05# revert the change to osd, required mp.add_timeout to give show-progress time to execute (at least requires 0.058 here) - putting it at 0.07 just to be safe
	elseif chapter+direction < 0 and timepos < 1 then --0.11# only if at the begining of the file then go back to previous playlist
	    mp.command('playlist_prev')
    elseif chapter+direction >= chapters_count then
		mp.command('playlist_next')
    else
        mp.set_property('osd-duration', o.osd_duration) --1.05# change osd bar duration (needs to change the universal osd-duration)
        mp.commandv(o.chapter_osd, 'add', 'chapter', direction) --1.05# changed to chapter_osd msg
		mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end) --1.05# revert the change to osd, required mp.add_timeout to give show-progress time to execute (at least requires 0.058 here) - putting it at 0.07 just to be safe

    end
end

-- silence skip main code --
function silenceSkip(action)
	if skip_flag then if o.keybind_twice_cancel_skip then restoreProp(initial_skip_time) end return end --1.02# added option to cancel by pressing keybind again
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

	mp.add_timeout(0.05, function() prompt_msg('Skipped to silence 🕒 ' .. mp.get_property_osd("time-pos")) end) --1.05# no need for custom function anymore, just ust prompt_msg
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
            prompt_msg('Chapters written to:' .. chapters_file_path)
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
		prompt_msg('file written to ' .. output_path)
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
		prompt_msg('○ Auto-Load Disabled')
		autoload_playlist = false
	elseif autoload_playlist == false then 
		prompt_msg('● Auto-Load Enabled')
		autoload_playlist = true
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
		if categories[category:lower()] then --1.16# made it the opposite to handle index first, and used == instead of find
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

function prep_chapterskip_var() --1.05# to identify the chapter category of autoskip only once
	if chapter_state == 'no-chapters' then return end
	g_opt_categories = o.categories --1.05# update every time on load to reset into originally defined categories
	
	g_opt_skip_once = false --0.18# initiate as false to be default state --1.05 after every file load 
	if o.skip_once == true or o.skip_once == false then --0.18# if its enabled or disabled then set it as that
		g_opt_skip_once = o.skip_once
	elseif has_value(o.skip_once, chapter_state) then --0.18# if it is found for a specific chapter then enable it for only the specific chapter
		g_opt_skip_once = true;
	end
	
	if type(o.categories) == 'table' then --0.17# if it is table then find the appropriate value based on chapter
		for i=1, #o.categories do
			if o.categories[i] and o.categories[i][1] == chapter_state then --0.17# set the value for the defined chapter, causes crash because this function could run before chapter_state is set to internal or external (look at FINALLY: for the fix)
				g_opt_categories = o.categories[i][2]
				break
			end
		end
	end
	
	for category in string.gmatch(g_opt_categories, "([^;]+)") do
        local name, patterns = string.match(category, " *([^+>]*[^+> ]) *[+>](.*)") --1.15# added local
        if name then
            categories[name:lower()] = patterns
        elseif not parsed[category] then
            mp.msg.warn("Improper category definition: " .. category)
        end
        parsed[category] = true
    end
	--1.06# no need for return
end

function start_chapterskip_countdown(text, duration)
	g_autoskip_countdown_flag = true
    g_autoskip_countdown = g_autoskip_countdown - 1
	
	if o.autoskip_countdown_graceful and (g_autoskip_countdown <= 0) then kill_chapterskip_countdown(); mp.osd_message('',0) return end --1.14# for graceful kill it when it reaches 0
	
	if (g_autoskip_countdown < 0) then kill_chapterskip_countdown(); mp.osd_message('',0) return end --1.0# if countdown reaches 0 then force kill it and clear osd message --1.14(this has to be < 0 so that when it reaches 0 if we put the countdown as 1 it works)
	
	text = text:gsub("%%countdown%%", g_autoskip_countdown)
	prompt_msg(text, 2000) --1.14# make it two seconds instead of 1 since it will be replaced anyway
end

function kill_chapterskip_countdown(action)
	if not g_autoskip_countdown_flag then return end --1.11# only execute if autoskip is ongoing
	if action == 'osd' and o.autoskip_osd ~= 'no-osd' then
		prompt_msg('○ Auto-Skip Cancelled') --1.10# replace with prompt message function
	end
	if g_autoskip_timer ~= nil then --1.07# reset 
		g_autoskip_timer:kill()
	end
	unbind_keys(o.cancel_autoskip_countdown_keybind, 'cancel-autoskip-countdown')
	unbind_keys(o.proceed_autoskip_countdown_keybind, 'proceed-autoskip-countdown')
	g_autoskip_countdown = o.autoskip_countdown --1.07# reset countdown
	g_autoskip_countdown_flag = false --1.07# reset flag
end

function chapterskip(_, current, countdown) --1.12# change countdown to be part of the function
	if chapter_state == 'no-chapters' then return end --0.17#FINALLY: solve crash because of the table, basically only proceed with this function to skip_chapters if its not defined as no-chapters.
    if not autoskip_chapter then return end --1.0# changed to global variable for toggle-able
	if g_autoskip_countdown_flag then kill_chapterskip_countdown('osd') end --1.10# kill countdown if it exists when entering new chapter (no need to return which fixes issue for consecutive chapters)
	if not countdown then countdown = o.autoskip_countdown end --1.12# change countdown to be part of the function

	local chapters = mp.get_property_native("chapter-list")
    local skip = false
	local consecutive_i = 0 --1.06# initiate to track consecutive chapters
	
    for i=0, #chapters do --0.16 convert to standard for loop
		if (not g_opt_skip_once or not skipped[i]) and i == 0 and chapters[i+1] and matches(i, chapters[i+1].title) then --0.16 handle index = 0 (idx->0), this will only run if index is 0 and then it will proceed like it was originally. ALSO (chaptersi+1) will also handle it so this works only if there chapter-next detected.
		    if i == current + 1 or skip == i - 1 then
                if skip then
                    skipped[skip] = true
                end
                skip = i
				consecutive_i = consecutive_i+1 --1.06# track consecutive chapters
            end
        elseif (not g_opt_skip_once or not skipped[i]) and chapters[i] and matches(i, chapters[i].title) then --0.16 check if chapter iternation exists first to not crash
            if i == current + 1 or skip == i - 1 then
                if skip then
                    skipped[skip] = true
                end
                skip = i
				consecutive_i = consecutive_i+1 --1.06# track consecutive chapters
            end
        elseif skip and countdown <= 0 then --1.07# proceed with normal chapterSkip only if no countdown is defined
			local autoskip_osd = o.autoskip_osd --1.01# show custom osd-msg-bar instead of default
			if o.autoskip_osd == 'osd-msg-bar' then autoskip_osd = 'osd-bar' end --1.01# change it only to bar and show the custom osd message
			if o.autoskip_osd == 'osd-msg' then autoskip_osd = 'no-osd' end --1.01# change it to no-osd for osd-msg so it shows the custom message
			
			mp.set_property('osd-duration', o.osd_duration) --1.05# change osd bar duration (needs to change the universal osd-duration)
			mp.commandv(autoskip_osd, "show-progress") --1.04# use it only for osd, for the text I am using custom show-text 
			mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end) --1.05# revert the change to osd, required mp.add_timeout to give show-progress time to execute -- at least requires 0 here putting it at 0.07 just to be safe
			
			if o.autoskip_osd == 'osd-msg-bar' or o.autoskip_osd == 'osd-msg' then
				if consecutive_i > 1 then
					local autoskip_osd_string = '' --1.06# initiate autoskip chapter osd as empty string
					for j=consecutive_i, 1, -1  do --1.06# do a reverse loop to get the index from smallest to biggest
						local chapter_title = '' --1.09# handle if chapter title is not available
						if chapters[i-j] then chapter_title = chapters[i-j].title end --1.09# if chapter exists then get chapter_title
						autoskip_osd_string=(autoskip_osd_string..'\n  ➤ Chapter ('..i-j..') '..chapter_title) --1.06# print the index of chapter along with title and put it into autoskip osd string
					end
					prompt_msg('● Auto-Skip'..autoskip_osd_string)
				else
					prompt_msg('➤ Auto-Skip: Chapter '.. mp.command_native({'expand-text', '${chapter}'})) --1.01# this has to be above skipping chapter because I want to show the name of the chapter before skipping
				end
			end
			mp.set_property("time-pos", chapters[i].time) --1.04# Fixes bug of not skipping consecutive chapters
            skipped[skip] = true
            return
        elseif skip and countdown > 0 then
			g_autoskip_countdown_flag = true --1.09# immediately initiate it as true
			bind_keys(o.cancel_autoskip_countdown_keybind, "cancel-autoskip-countdown", function() kill_chapterskip_countdown('osd') return end) --1.11# immediately bind keys
			bind_keys(o.proceed_autoskip_countdown_keybind, "proceed-autoskip-countdown", function() --1.12# function to immediately proceed with autoskip
				kill_chapterskip_countdown()
				if consecutive_i > 1 and o.autoskip_countdown_bulk then --1.12# if it is bulk then the rerun function of chapterSkip with timer 0
					chapterskip(_,current,0)
					return
				else --1.12# otherwise run the action of skipping successfully
					prompt_msg('➤ Auto-Skip: Chapter '.. mp.command_native({'expand-text', '${chapter}'}))
					mp.set_property("time-pos", chapters[i-consecutive_i+1].time)
					skipped[skip] = true
					return
				end
			end)
			
			local autoskip_osd_string = ''
			local autoskip_graceful_osd = '' --1.14# graceful osd
			if o.autoskip_countdown_graceful then autoskip_graceful_osd = 'Press Keybind to:\n' end --1.14# add the graceful osd if its available
			if o.autoskip_osd == 'osd-msg-bar' or o.autoskip_osd == 'osd-msg' then --1.07# show osd message before timer
				if consecutive_i > 1 and o.autoskip_countdown_bulk then
					local autoskip_osd_string = '' --1.06# initiate autoskip chapter osd as empty string
					for j=consecutive_i, 1, -1  do --1.06# do a reverse loop to get the index from smallest to biggest
						local chapter_title = '' --1.09# handle if chapter title is not available
						if chapters[i-j] then chapter_title = chapters[i-j].title end --1.09# if chapter exists then get chapter_title
						autoskip_osd_string=(autoskip_osd_string..'\n  ▷ Chapter ('..i-j..') '..chapter_title) --1.06# print the index of chapter along with title and put it into autoskip osd string
					end
					prompt_msg(autoskip_graceful_osd..'○ Auto-Skip'..' in "'..o.autoskip_countdown..'"'..autoskip_osd_string, 2000) --1.09# increase to 2000ms since it will be replaced anyway
					g_autoskip_timer = mp.add_periodic_timer(1, function () 
						start_chapterskip_countdown(autoskip_graceful_osd..'○ Auto-Skip'..' in "%countdown%"'..autoskip_osd_string, 2000) --1.09# increase to 2000ms since it will be replaced anyway
					end)
				else
					prompt_msg(autoskip_graceful_osd..'▷ Auto-Skip in "'..o.autoskip_countdown..'": Chapter '.. mp.command_native({'expand-text', '${chapter}'}), 2000) --1.09# increase to 2000ms since it will be replaced anyway
					g_autoskip_timer = mp.add_periodic_timer(1, function () 
						start_chapterskip_countdown(autoskip_graceful_osd..'▷ Auto-Skip in "%countdown%": Chapter '.. mp.command_native({'expand-text', '${chapter}'}), 2000) --1.09# increase to 2000ms since it will be replaced anyway
					end)
				end
			end
			if o.autoskip_countdown_graceful then return end --1.14# if it is graceful then return before starting function that will skip
			mp.add_timeout(countdown, function() --1.09# start of countdown function
				if not g_autoskip_countdown_flag then kill_chapterskip_countdown() return end --1.09# only proceed if autoskip is there
				if g_autoskip_countdown > 1 then return end --1.09# if it is more than 1 then exit the function
				
				local autoskip_osd = o.autoskip_osd
				if o.autoskip_osd == 'osd-msg-bar' then autoskip_osd = 'osd-bar' end
				if o.autoskip_osd == 'osd-msg' then autoskip_osd = 'no-osd' end
				
				mp.set_property('osd-duration', o.osd_duration)
				mp.commandv(autoskip_osd, "show-progress")
				mp.add_timeout(0.07, function () mp.set_property('osd-duration', osd_duration_default) end)
				if o.autoskip_osd == 'osd-msg-bar' or o.autoskip_osd == 'osd-msg' then
					if consecutive_i > 1 and o.autoskip_countdown_bulk then
						local autoskip_osd_string = ''
						for j=consecutive_i, 1, -1  do
							local chapter_title = '' --1.09# handle if chapter title is not available
							if chapters[i-j] then chapter_title = chapters[i-j].title end --1.09# if chapter exists then get chapter_title
							autoskip_osd_string=(autoskip_osd_string..'\n  ➤ Chapter ('..i-j..') '..chapter_title) --1.07# needed again since this uses a filled arrow for better osd
						end
						prompt_msg('● Auto-Skip'..autoskip_osd_string)
					else
						prompt_msg('➤ Auto-Skip: Chapter '.. mp.command_native({'expand-text', '${chapter}'}))
					end
				end
				if consecutive_i > 1 and o.autoskip_countdown_bulk then --1.07#skip bulk if enabled
					mp.set_property("time-pos", chapters[i].time)
				else --1.07# otherwise skip one by one
					mp.set_property("time-pos", chapters[i-consecutive_i+1].time)
				end
				skipped[skip] = true
				kill_chapterskip_countdown()
			end)
            return
        end
    end
    if skip and countdown <= 0 then --1.07# proceed with normal chapterSkip only if no countdown is defined
        if mp.get_property_native("playlist-count") == mp.get_property_native("playlist-pos-1") then
            return mp.set_property("time-pos", mp.get_property_native("duration"))
        end
        mp.commandv("playlist-next")
		if o.autoskip_osd ~= 'no-osd' then autoskip_playlist_osd = true end
    elseif skip and countdown > 0 then
		g_autoskip_countdown_flag = true --1.09# immediately initiate it as true
		bind_keys(o.cancel_autoskip_countdown_keybind, "cancel-autoskip-countdown", function() kill_chapterskip_countdown('osd') return end) --1.11# immediately bind keys
		bind_keys(o.proceed_autoskip_countdown_keybind, "proceed-autoskip-countdown", function() --1.12# function to immediately proceed with autoskip
			kill_chapterskip_countdown()
			chapterskip(_,current,0)
			return
		end)
		if o.autoskip_osd == 'osd-msg-bar' or o.autoskip_osd == 'osd-msg' then 
			local autoskip_graceful_osd = '' --1.14# graceful osd
			if o.autoskip_countdown_graceful then autoskip_graceful_osd = 'Press Keybind to:\n' end --1.14# add the graceful osd if its available
			if consecutive_i > 1 and o.autoskip_countdown_bulk then --1.13 fix for notification not showing consecutive if end of playback is detected
				local i = (mp.get_property_number('chapters')+1 or 0) --1.13# since this is after the loop is completed, instead of the i we will use the chapters_count+1
				local autoskip_osd_string = '' --1.06# initiate autoskip chapter osd as empty string
				for j=consecutive_i, 1, -1  do --1.06# do a reverse loop to get the index from smallest to biggest
					local chapter_title = '' --1.09# handle if chapter title is not available
					if chapters[i-j] then chapter_title = chapters[i-j].title end --1.09# if chapter exists then get chapter_title
					autoskip_osd_string=(autoskip_osd_string..'\n  ▷ Chapter ('..i-j..') '..chapter_title) --1.06# print the index of chapter along with title and put it into autoskip osd string
				end
				prompt_msg(autoskip_graceful_osd..'○ Auto-Skip'..' in "'..o.autoskip_countdown..'"'..autoskip_osd_string, 2000) --1.09# increase to 2000ms since it will be replaced anyway
				g_autoskip_timer = mp.add_periodic_timer(1, function ()
					start_chapterskip_countdown(autoskip_graceful_osd..'○ Auto-Skip'..' in "%countdown%"'..autoskip_osd_string, 2000) --1.09# increase to 2000ms since it will be replaced anyway --1.14# added graceful osd
				end)
			else
				prompt_msg(autoskip_graceful_osd..'▷ Auto-Skip in "'..o.autoskip_countdown..'": Chapter '.. mp.command_native({'expand-text', '${chapter}'}), 2000) --1.09# increase to 2000ms since it will be replaced anyway --1.14# added graceful osd
				g_autoskip_timer = mp.add_periodic_timer(1, function () 
					start_chapterskip_countdown(autoskip_graceful_osd..'▷ Auto-Skip in "%countdown%": Chapter '.. mp.command_native({'expand-text', '${chapter}'}), 2000) --1.09# increase to 2000ms since it will be replaced anyway
				end)
			end
		end
		if o.autoskip_countdown_graceful then return end --1.14# if it is graceful then return before starting function that will skip
		mp.add_timeout(countdown, function() --1.09# start of countdown function
			if not g_autoskip_countdown_flag then return end --1.09# only proceed if autoskip is there
			if g_autoskip_countdown > 1 then return end --1.09# if it is more than 1 then exit the function
			
			if mp.get_property_native("playlist-count") == mp.get_property_native("playlist-pos-1") then
				return mp.set_property("time-pos", mp.get_property_native("duration"))
			end
			mp.commandv("playlist-next")
			if o.autoskip_osd ~= 'no-osd' then autoskip_playlist_osd = true end
			kill_chapterskip_countdown()
		end)
    end
end

function toggle_autoskip() --1.0# add option to toggle autoskip
	if autoskip_chapter == true then
		prompt_msg('○ Auto-Skip Disabled')
		autoskip_chapter = false
		if g_autoskip_countdown_flag then kill_chapterskip_countdown() end --1.15# kill countdown if its on-going while disabling
	elseif autoskip_chapter == false then
		prompt_msg('● Auto-Skip Enabled')
		autoskip_chapter = true
	end
end

function toggle_category_autoskip() --1.02# option to add / remove categories from autoskip
	if chapter_state == 'no-chapters' then return end --1.02# exit if there are no chapters
	if not mp.get_property_number("chapter") then return end --1.02# if unable to get any chapter index then return
	local chapters = mp.get_property_native("chapter-list")
	local current_chapter = (mp.get_property_number("chapter") + 1 or 0) --1.05# to not cause crash when looking for chapters_index
	
	--1.09# handle if no chapter title is available by using index
	local chapter_title = tostring(current_chapter) --1.09# initiate chapter_title as the index of current_title
	if current_chapter > 0 and chapters[current_chapter].title and chapters[current_chapter].title ~= '' then --1.09# replace the chapter_title with title if it is found and not empty
		chapter_title = chapters[current_chapter].title
	end

	local found_i = 0 --1.15# init the variable
	if matches(current_chapter, chapter_title) then --1.15# only if it is triggered for skip using user config do the following
		for category in string.gmatch(g_opt_categories, "([^;]+)") do --1.15# check user config and remove when toggling
			local name, patterns = string.match(category, " *([^+>]*[^+> ]) *[+>](.*)")

			for pattern in string.gmatch(patterns, "([^/]+)") do --1.15# loop through each pattern in found patterns
				if string.match(chapter_title:lower(), pattern:lower()) then --1.15# if pattern matches title, then remove it
					g_opt_categories = g_opt_categories:gsub(esc_string(pattern)..'/?', "")
					found_i = found_i + 1
				end
			end
		end
		
		for category in string.gmatch(g_opt_categories, "([^;]+)") do --1.15# write the changes
			local name, patterns = string.match(category, " *([^+>]*[^+> ]) *[+>](.*)") --1.15# added local
			if name then
				categories[name:lower()] = patterns
			elseif not parsed[category] then
				mp.msg.warn("Improper category definition: " .. category)
			end
			parsed[category] = true
		end
		
		--1.16# update user config variables (so it keeps the same toggled chapters for the whole session)
		if type(o.categories) == 'table' then --0.17# if it is table then find the appropriate value based on chapter
			for i=1, #o.categories do
				if o.categories[i] and o.categories[i][1] == chapter_state then --0.17# set the value for the defined chapter, causes crash because this function could run before chapter_state is set to internal or external (look at FINALLY: for the fix)
					o.categories[i][2] = g_opt_categories
					break
				end
			end
		else
			o.categories = g_opt_categories
		end
	end
	if current_chapter > 0 and chapters[current_chapter].title and chapters[current_chapter].title ~= '' then
		if found_i > 0 or string.match(categories.toggle, esc_string(chapter_title)) then --1.15# if found either in toggle or user then add it
			prompt_msg('○ Removed from Auto-Skip\n  ▷ Chapter: '..chapter_title)
			categories.toggle = categories.toggle:gsub(esc_string("^"..chapter_title.."/"), "") --1.02# if category is within toggle then remove it --1.02# if category is within toggle then remove it
			if g_autoskip_countdown_flag then kill_chapterskip_countdown() end --1.15# kill countdown if its on-going while disabling
		else
			prompt_msg('● Added to Auto-Skip\n  ➔ Chapter: '..chapter_title)
			categories.toggle = categories.toggle.."^"..chapter_title.."/" --1.02# if not within toggle then add chapter to toggle category
		end
	else
		if found_i > 0 or string.match(categories.toggle_idx, esc_string(chapter_title)) then --1.16# if it is index based then add it as index
			prompt_msg('○ Removed from Auto-Skip\n  ▷ Chapter: '..chapter_title)
			categories.toggle_idx = categories.toggle_idx:gsub(esc_string(chapter_title.."/"), "") --1.02# if category is within toggle then remove it --1.02# if category is within toggle then remove it
			if g_autoskip_countdown_flag then kill_chapterskip_countdown() end --1.15# kill countdown if its on-going while disabling
		else
			prompt_msg('● Added to Auto-Skip\n  ➔ Chapter: '..chapter_title)
			categories.toggle_idx = categories.toggle_idx..chapter_title.."/" --1.02# if not within toggle then add chapter to toggle category
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
	-- 	if playlist_osd and not autoskip_playlist_osd then mp.command("show-text '[${playlist-pos-1}/${playlist-count}] ${filename}'"..o.osd_duration) end --1.05# this can also be used for osd duration however it will not show msg.info
	-- if autoskip_playlist_osd then mp.command("show-text '➤ Auto-Skip\n[${playlist-pos-1}/${playlist-count}] ${filename}'"..o.osd_duration) end --1.05# this can also be used for osd duration however it will not show msg.info
	if playlist_osd and not autoskip_playlist_osd then --1.05# utilize prompt_msg
		prompt_msg('['..mp.command_native({'expand-text', '${playlist-pos-1}'})..'/'..mp.command_native({'expand-text', '${playlist-count}'})..'] '..mp.command_native({'expand-text', '${filename}'}))
	end
	if autoskip_playlist_osd then --1.05# utilize prompt_msg
		prompt_msg('➤ Auto-Skip\n['..mp.command_native({'expand-text', '${playlist-pos-1}'})..'/'..mp.command_native({'expand-text', '${playlist-count}'})..'] '..mp.command_native({'expand-text', '${filename}'}))
	end
	playlist_osd = false --1.01# reset playlist osd
	autoskip_playlist_osd = false --1.01# reset autoskip playlist osd
	force_silence_skip = false --1.10# reset force silence skip
	skipped = {} --1.04# reset skipped autoskip flag
	initial_chapter_count = mp.get_property_number("chapter-list/count")
	if initial_chapter_count > 0 and chapter_state ~= 'external-chapters' then chapter_state = 'internal-chapters' end --1.07# only set internal chapters if external-chapters were not loaded and the chapters count is more than 0
	prep_chapterskip_var() --1.05# change it as global variable
end)

mp.add_hook("on_load", 50, function()
	if o.external_chapters_autoload then load_chapters() end --0.15# renamed
end)

mp.observe_property('pause', 'bool', function(name, value)
	if value and skip_flag then
		restoreProp(initial_skip_time, true)
	end
	if g_autoskip_countdown_flag then kill_chapterskip_countdown('osd') end --1.09# kill countdown if it exists
end)

mp.add_hook('on_unload', 9, function()
	if o.modified_chapters_autosave == true or has_value(o.modified_chapters_autosave, chapter_state) then write_chapters(false) end --1.07# moved auto_save chapters here since I revert no_chapters here
	mp.set_property("keep-open", keep_open_state)
	chapter_state = 'no-chapters' --1.07# revert chapter state
	g_playlist_pos = (mp.get_property_native('playlist-playing-pos')+1 or 0)
	kill_chapterskip_countdown() --1.07# revert countdown when playlist loads
end)

mp.register_event('seek', function()
	if g_autoskip_countdown_flag then kill_chapterskip_countdown('osd') end --1.09# kill countdown if it exists
end)

mp.observe_property('eof-reached', 'bool', eofHandler)

-- BINDINGS --------------------------------------------------------------------

bind_keys(o.toggle_autoload_keybind, 'toggle-autoload', toggle_autoload)
bind_keys(o.toggle_autoskip_keybind, "toggle-autoskip", toggle_autoskip)
bind_keys(o.toggle_category_autoskip_keybind, "toggle-category-autoskip", toggle_category_autoskip)
bind_keys(o.add_chapter_keybind, "add-chapter", add_chapter)
bind_keys(o.remove_chapter_keybind, "remove-chapter", remove_chapter) --1.14# added remove_chapter again, mistakenly it was removed
bind_keys(o.write_chapters_keybind, "write-chapters", function () write_chapters(true) end)
bind_keys(o.edit_chapter_keybind, "edit-chapter", edit_chapter)
bind_keys(o.bake_chapters_keybind, "bake-chapters", bake_chapters)
bind_keys(o.chapter_prev_keybind, "chapter-prev", function() chapterSeek(-1) end)
bind_keys(o.chapter_next_keybind, "chapter-next", function() chapterSeek(1) end)
bind_keys(o.smart_prev_keybind, "smart-prev", smartPrev)
bind_keys(o.smart_next_keybind, "smart-next", smartNext)
bind_keys(o.silence_skip_keybind, "silence-skip", silenceSkip)
