-- Copyright (c) 2021, Eisa AlAwadhi
-- License: BSD 2-Clause License
-- Creator: Eisa AlAwadhi
-- Project: SmartCopyPaste
-- Version: 3.0

local o = {
---------------------------USER CUSTOMIZATION SETTINGS---------------------------
--These settings are for users to manually change some options.
--Changes are recommended to be made in the script-opts directory.

	-----Script Settings----
	device = 'auto', --'auto' is for automatic device detection, or manually change to: 'windows' or 'mac' or 'linux'
	linux_copy = 'xclip -silent -selection clipboard -in', --copy command that will be used in Linux. OR write a different command
	linux_paste = 'xclip -selection clipboard -o', --paste command that will be used in Linux. OR write a different command
	mac_copy = 'pbcopy', --copy command that will be used in MAC. OR write a different command
	mac_paste = 'pbpaste', --paste command that will be used in MAC. OR write a different command
	windows_copy = 'powershell', --'powershell' is for using windows powershell to copy. OR write the copy command, e.g: ' clip'
	windows_paste = 'powershell', --'powershell' is for using windows powershell to paste. OR write the paste command
	resume_offset = -0.65, --change to 0 so item resumes from the exact position, or decrease the value so that it gives you a little preview before loading the resume point
	osd_messages = true, --true is for displaying osd messages when actions occur. Change to false will disable all osd messages generated from this script
	time_seperator = ' 🕒 ', --Time seperator that will be shown before the saved time in osd messages
	prefer_filename_over_title = 'local', --Prefers to copy filename over filetitle. Select between 'local', 'protocols', 'all', and 'none'. 'local' prefer filenames for videos that are not protocols. 'protocols' will prefer filenames for protocols only. 'all' will prefer filename over filetitle for both protocols and not protocols videos. 'none' will always use filetitle instead of filename
	copy_time_method = 'all', --Option to copy time with video, 'none' for disabled, 'all' to copy time for all videos, 'protocols' for copying time only for protocols, 'specifics' to copy time only for websites defined below, 'local' to copy time for videos that are not protocols
	specific_time_attributes=[[
	[ ["twitter", "?t=", ""], ["twitch", "?t=", "s"], ["youtube", "&t=", "s"] ]
	]], --The time attributes which will be added when copying protocols of specific websites from this list. Additional attributes can be added following the same format.
	protocols_time_attribute = '&t=', --The text that will be copied before the seek time when copying a protocol video from mpv 
	local_time_attribute = '&time=', --The text that will be copied before the seek time when copying a local video from mpv
	pastable_time_attributes=[[
	[" | time="]
	]], --The time attributes that can be pasted for resume, specific_time_attributes, protocols_time_attribute, local_time_attribute are automatically added
	copy_keybind=[[
	["ctrl+c", "ctrl+C", "meta+c", "meta+C"]
	]], --Keybind that will be used to copy
	running_paste_behavior = 'playlist', --The priority of paste behavior when a video is running. select between 'playlist', 'timestamp', 'force'.
	paste_keybind=[[
	["ctrl+v", "ctrl+V", "meta+v", "meta+V"]
	]], --Keybind that will be used to paste
	copy_specific_behavior = 'path', --Copy behavior when using copy_specific_keybind. select between 'title', 'path', 'timestamp', 'path&timestamp'.
	copy_specific_keybind=[[
	["ctrl+alt+c", "ctrl+alt+C", "meta+alt+c", "meta+alt+C"]
	]], --Keybind that will be used to copy based on the copy behavior specified
	paste_specific_behavior = 'playlist', --Paste behavior when using paste_specific_keybind. select between 'playlist', 'timestamp', 'force'.
	paste_specific_keybind=[[
	["ctrl+alt+v", "ctrl+alt+V", "meta+alt+v", "meta+alt+V"]
	]], --Keybind that will be used to paste based on the paste behavior specified
	paste_protocols=[[
	["https?://", "magnet:", "rtmp:"]
	]], --add above (after a comma) any protocol you want paste to work with; e.g: ,'ftp://'. Or set it as "" by deleting all defined protocols to make paste works with any protocol.
	paste_extensions=[[
	["ac3", "a52", "eac3", "mlp", "dts", "dts-hd", "dtshd", "true-hd", "thd", "truehd", "thd+ac3", "tta", "pcm", "wav", "aiff", "aif",  "aifc", "amr", "awb", "au", "snd", "lpcm", "yuv", "y4m", "ape", "wv", "shn", "m2ts", "m2t", "mts", "mtv", "ts", "tsv", "tsa", "tts", "trp", "adts", "adt", "mpa", "m1a", "m2a", "mp1", "mp2", "mp3", "mpeg", "mpg", "mpe", "mpeg2", "m1v", "m2v", "mp2v", "mpv", "mpv2", "mod", "tod", "vob", "vro", "evob", "evo", "mpeg4", "m4v", "mp4", "mp4v", "mpg4", "m4a", "aac", "h264", "avc", "x264", "264", "hevc", "h265", "x265", "265", "flac", "oga", "ogg", "opus", "spx", "ogv", "ogm", "ogx", "mkv", "mk3d", "mka", "webm", "weba", "avi", "vfw", "divx", "3iv", "xvid", "nut", "flic", "fli", "flc", "nsv", "gxf", "mxf", "wma", "wm", "wmv", "asf", "dvr-ms", "dvr", "wtv", "dv", "hdv", "flv","f4v", "f4a", "qt", "mov", "hdmov", "rm", "rmvb", "ra", "ram", "3ga", "3ga2", "3gpp", "3gp", "3gp2", "3g2", "ay", "gbs", "gym", "hes", "kss", "nsf", "nsfe", "sap", "spc", "vgm", "vgz", "m3u", "m3u8", "pls", "cue",
	"ase", "art", "bmp", "blp", "cd5", "cit", "cpt", "cr2", "cut", "dds", "dib", "djvu", "egt", "exif", "gif", "gpl", "grf", "icns", "ico", "iff", "jng", "jpeg", "jpg", "jfif", "jp2", "jps", "lbm", "max", "miff", "mng", "msp", "nitf", "ota", "pbm", "pc1", "pc2", "pc3", "pcf", "pcx", "pdn", "pgm", "PI1", "PI2", "PI3", "pict", "pct", "pnm", "pns", "ppm", "psb", "psd", "pdd", "psp", "px", "pxm", "pxr", "qfx", "raw", "rle", "sct", "sgi", "rgb", "int", "bw", "tga", "tiff", "tif", "vtf", "xbm", "xcf", "xpm", "3dv", "amf", "ai", "awg", "cgm", "cdr", "cmx", "dxf", "e2d", "egt", "eps", "fs", "gbr", "odg", "svg", "stl", "vrml", "x3d", "sxd", "v2d", "vnd", "wmf", "emf", "art", "xar", "png", "webp", "jxr", "hdp", "wdp", "cur", "ecw", "iff", "lbm", "liff", "nrrd", "pam", "pcx", "pgf", "sgi", "rgb", "rgba", "bw", "int", "inta", "sid", "ras", "sun", "tga",
	"torrent"]
	]], --add above (after a comma) any extension you want paste to work with; e.g: ,'pdf'. Or set it as "" by deleting all defined extension to make paste works with any extension.
	paste_subtitles=[[
	["aqt", "gsub", "jss", "sub", "ttxt", "pjs", "psb", "rt", "smi", "slt", "ssf", "srt", "ssa", "ass", "usf", "idx", "vtt"]
	]], --add above (after a comma) any extension you want paste to attempt to add as a subtitle file, e.g.:'txt'. Or set it as "" by deleting all defined extension to make paste attempt to add any subtitle.
	
---------------------------END OF USER CUSTOMIZATION SETTINGS---------------------------
}

(require 'mp.options').read_options(o)
local utils = require 'mp.utils'
local msg = require 'mp.msg'

o.copy_keybind = utils.parse_json(o.copy_keybind)
o.paste_keybind = utils.parse_json(o.paste_keybind)
o.copy_specific_keybind = utils.parse_json(o.copy_specific_keybind)
o.paste_specific_keybind = utils.parse_json(o.paste_specific_keybind)
o.paste_protocols = utils.parse_json(o.paste_protocols)
o.paste_extensions = utils.parse_json(o.paste_extensions)
o.paste_subtitles = utils.parse_json(o.paste_subtitles)
o.specific_time_attributes = utils.parse_json(o.specific_time_attributes)
o.pastable_time_attributes = utils.parse_json(o.pastable_time_attributes)

local protocols = {'https?://', 'magnet:', 'rtmp:'}
local seekTime = 0
local clip, clip_time, clip_file, filePath, fileTitle
local clipboard_pasted = false

function has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	
	return false
end

table.insert(o.pastable_time_attributes, o.protocols_time_attribute)
table.insert(o.pastable_time_attributes, o.local_time_attribute)
for i = 1, #o.specific_time_attributes do
	if not has_value(o.pastable_time_attributes, o.specific_time_attributes[i][2]) then
		table.insert(o.pastable_time_attributes, o.specific_time_attributes[i][2])
	end
end

if not o.device or o.device == 'auto' then
	if os.getenv('windir') ~= nil then
		o.device = 'windows'
	elseif os.execute '[ -d "/Applications" ]' == 0 and os.execute '[ -d "/Library" ]' == 0 or os.execute '[ -d "/Applications" ]' == true and os.execute '[ -d "/Library" ]' == true then
		o.device = 'mac'
	else
		o.device = 'linux'
  end
end

function starts_protocol(tab, val)
	for index, value in ipairs(tab) do
		if (val:find(value) == 1) then
			return true
		end
	end
	return false
end

function contain_value(tab, val)
	if not tab then return end
	if not val then return end

	for index, value in ipairs(tab) do
		if value.match(string.lower(val), string.lower(value)) then
			return true
		end
	end
	
	return false
end

function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then io.close(f) return true else return false end
end

function format_time(duration)
	local total_seconds = math.floor(duration)
	local hours = (math.floor(total_seconds / 3600))
	total_seconds = (total_seconds % 3600)
	local minutes = (math.floor(total_seconds / 60))
	local seconds = (total_seconds % 60)
	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function get_path()
	local path = mp.get_property('path')
	if not path then return end
	
	local title = mp.get_property('media-title'):gsub("\"", "")
	
	if starts_protocol(protocols, path) and o.prefer_filename_over_title == 'protocols' then
		title = mp.get_property('filename'):gsub("\"", "")
	elseif not starts_protocol(protocols, path) and o.prefer_filename_over_title == 'local' then
		title = mp.get_property('filename'):gsub("\"", "")
	elseif o.prefer_filename_over_title == 'all' then
		title = mp.get_property('filename'):gsub("\"", "")
	end
	
	return path, title
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

function handleres(res, args)
	if not res.error and res.status == 0 then
		return res.stdout
	else
		msg.error("There was an error getting "..o.device.." clipboard: ")
		msg.error("  Status: "..(res.status or ""))
		msg.error("  Error: "..(res.error or ""))
		msg.error("  stdout: "..(res.stdout or ""))
		msg.error("args: "..utils.to_string(args))
		return ''
	end
end

function os.capture(cmd)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  return s
end

function make_raw(s)
	if not s then return end
	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')
	return s
end

function get_extension(path)
	if not path then return end

    match = string.match(path, '%.([^%.]+)$' )
    if match == nil then
        return 'nomatch'
    else
        return match
    end
end


function get_specific_attribute(target_path)
		local pre_attribute = ''
		local after_attribute = ''
		if not starts_protocol(protocols, target_path) then
			pre_attribute = o.local_time_attribute
		elseif starts_protocol(protocols, target_path) then
			pre_attribute = o.protocols_time_attribute
			for i = 1, #o.specific_time_attributes do
				if contain_value({o.specific_time_attributes[i][1]}, target_path) then
					pre_attribute = o.specific_time_attributes[i][2]
					after_attribute = o.specific_time_attributes[i][3]
					break
				end
			end
		end
	return pre_attribute, after_attribute
end

function get_time_attribute(target_path)
	local pre_attribute = ''
	for i = 1, #o.pastable_time_attributes do
		if contain_value({o.pastable_time_attributes[i]}, target_path) then
			pre_attribute = o.pastable_time_attributes[i]
			break
		end
	end
	return pre_attribute
end


function get_clipboard()
	local clipboard
	if o.device == 'linux' then
		clipboard = os.capture(o.linux_paste)
		return clipboard
	elseif o.device == 'windows' then
		if o.windows_paste == 'powershell' then
			local args = {
				'powershell', '-NoProfile', '-Command', [[& {
					Trap {
						Write-Error -ErrorRecord $_
						Exit 1
					}
					$clip = Get-Clipboard -Raw -Format Text -TextFormatType UnicodeText
					if (-not $clip) {
						$clip = Get-Clipboard -Raw -Format FileDropList
					}
					$u8clip = [System.Text.Encoding]::UTF8.GetBytes($clip)
					[Console]::OpenStandardOutput().Write($u8clip, 0, $u8clip.Length)
				}]]
			}
			return handleres(utils.subprocess({ args =  args, cancellable = false }), args)
		else
			clipboard = os.capture(o.windows_paste)
			return clipboard
		end
	elseif o.device == 'mac' then
		clipboard = os.capture(o.mac_paste)
		return clipboard
	end
	return ''
end


function set_clipboard(text)
	local pipe
	if o.device == 'linux' then
		pipe = io.popen(o.linux_copy, 'w')
		pipe:write(text)
		pipe:close()
	elseif o.device == 'windows' then
		if o.windows_copy == 'powershell' then
			local res = utils.subprocess({ args = {
				'powershell', '-NoProfile', '-Command', string.format([[& {
					Trap {
						Write-Error -ErrorRecord $_
						Exit 1
					}
					Add-Type -AssemblyName PresentationCore
					[System.Windows.Clipboard]::SetText('%s')
				}]], text)
			} })
		else
			pipe = io.popen(o.windows_copy,'w')
			pipe:write(text)
			pipe:close()
		end
	elseif o.device == 'mac' then
		pipe = io.popen(o.mac_copy,'w')
		pipe:write(text)
		pipe:close()
	end
	return ''
end

function parse_clipboard(text)
	if not text then return end
	
	local clip, clip_file, clip_time, pre_attribute
	clip = text
	
	clip = make_raw(clip)
	pre_attribute = get_time_attribute(clip)

	if string.match(clip, '(.*)'..pre_attribute) then
		clip_file = string.match(clip, '(.*)'..pre_attribute)
		clip_time = tonumber(string.match(clip, pre_attribute..'(%d*%.?%d*)'))
	elseif string.match(clip, '^\"(.*)\"$') then
		clip_file = string.match(clip, '^\"(.*)\"$')
	else
		clip_file = clip
	end

	return clip, clip_file, clip_time
end

function copy()
	if filePath ~= nil then
		if o.copy_time_method == 'none' or copy_time_method == '' then
			copy_specific('path')
			return
		elseif o.copy_time_method == 'protocols' and not starts_protocol(protocols, filePath) then
			copy_specific('path')
			return
		elseif o.copy_time_method == 'local' and starts_protocol(protocols, filePath) then
			copy_specific('path')
			return
		elseif o.copy_time_method == 'specifics' then
			if not starts_protocol(protocols, filePath) then
				copy_specific('path')
				return
			else
				for i = 1, #o.specific_time_attributes do
					if contain_value({o.specific_time_attributes[i][1]}, filePath) then
						copy_specific('path&timestamp')
						return
					end
				end
				copy_specific('path')
				return
			end
		else
			copy_specific('path&timestamp')
			return
		end
	else
		if o.osd_messages == true then
			mp.osd_message('Failed to Copy\nNo Video Found')
		end
		msg.info('Failed to copy, no video found')
	end
end


function copy_specific(action)
	if not action then return end

	if filePath == nil then
		if o.osd_messages == true then
			mp.osd_message('Failed to Copy\nNo Video Found')
		end
		msg.info("Failed to copy, no video found")
		return
	else
		if action == 'title' then
			if o.osd_messages == true then
				mp.osd_message("Copied:\n"..fileTitle)
			end
			set_clipboard(fileTitle)
			msg.info("Copied the below into clipboard:\n"..fileTitle)
		end
		if action == 'path' then
			if o.osd_messages == true then
				mp.osd_message("Copied:\n"..filePath)
			end
			set_clipboard(filePath)
			msg.info("Copied the below into clipboard:\n"..filePath)
		end
		if action == 'timestamp' then
			local pre_attribute, after_attribute = get_specific_attribute(filePath)
			local video_time = mp.get_property_number('time-pos')
			if o.osd_messages == true then
				mp.osd_message("Copied"..o.time_seperator..format_time(video_time))
			end
			set_clipboard(pre_attribute..math.floor(video_time)..after_attribute)
			msg.info('Copied the below into clipboard:\n'..pre_attribute..math.floor(video_time)..after_attribute)
		end
		if action == 'path&timestamp' then
			local pre_attribute, after_attribute = get_specific_attribute(filePath)
			local video_time = mp.get_property_number('time-pos')
			if o.osd_messages == true then
				mp.osd_message("Copied:\n" .. fileTitle .. o.time_seperator .. format_time(video_time))
			end
			set_clipboard(filePath..pre_attribute..math.floor(video_time)..after_attribute)
			msg.info('Copied the below into clipboard:\n'..filePath..pre_attribute..math.floor(video_time)..after_attribute)
		end
	end
end

function trigger_paste_action(action)
	if not action then return end
	
	if action == 'load-file' then
		filePath = clip_file
		if o.osd_messages == true then
			if clip_time ~= nil then
				mp.osd_message("Pasted:\n"..clip_file .. o.time_seperator .. format_time(clip_time))
				msg.info("Pasted the below file into mpv:\n"..clip_file .. format_time(clip_time))
			else
				mp.osd_message("Pasted:\n"..clip_file)
				msg.info("Pasted the below file into mpv:\n"..clip_file)
			end
		end
		mp.commandv('loadfile', clip_file)
		clipboard_pasted = true
	end
	
	if action == 'load-subtitle' then
		if o.osd_messages == true then
			mp.osd_message("Pasted Subtitle:\n"..clip_file)
		end
		mp.commandv('sub-add', clip_file, 'select')
		msg.info("Pasted the below subtitle into mpv:\n"..clip_file)
	end
	
	if action == 'file-seek' then
		local video_duration = mp.get_property_number('duration')
		seekTime = clip_time + o.resume_offset
		
		if seekTime > video_duration then 
			if o.osd_messages == true then
				mp.osd_message('Time Paste Exceeds Video Length' .. o.time_seperator .. format_time(clip_time))
			end
			msg.info("The time pasted exceeds the video length:\n"..format_time(clip_time))
			return
		end 
		
		if (seekTime < 0) then
			seekTime = 0
		end
	
		if o.osd_messages == true then
			mp.osd_message('Resumed to Pasted Time' .. o.time_seperator .. format_time(clip_time))
		end
		mp.commandv('seek', seekTime, 'absolute', 'exact')
		msg.info("Resumed to the pasted time" .. o.time_seperator .. format_time(clip_time))
	end
	
	if action == 'add-playlist' then
		if o.osd_messages == true then
			mp.osd_message('Pasted Into Playlist:\n'..clip_file)
		end
		mp.commandv('loadfile', clip_file, 'append-play')
		msg.info("Pasted the below into playlist:\n"..clip_file)
	end
	
	if action == 'error-subtitle' then
		if o.osd_messages == true then
			mp.osd_message('Subtitle Paste Requires Running Video:\n'..clip_file)
		end
		msg.info('Subtitles can only be pasted if a video is running:\n'..clip_file)
	end
	
	if action == 'error-unsupported' then
		if o.osd_messages == true then
			mp.osd_message('Failed to Paste\nPasted Unsupported Item:\n'..clip)
		end
		msg.info('Failed to paste into mpv, pasted item shown below is unsupported:\n'..clip)
	end
	
	if action == 'error-missing' then
		if o.osd_messages == true then
			mp.osd_message('File Doesn\'t Exist:\n' .. clip_file)
		end
		msg.info('The file below doesn\'t seem to exist:\n' .. clip_file)
	end
	
	if action == 'error-time' then
		if o.osd_messages == true then
			if clip_time ~= nil then
				mp.osd_message('Time Paste Requires Running Video' .. o.time_seperator .. format_time(clip_time))
				msg.info('Time can only be pasted if a video is running:\n'.. format_time(clip_time))
			else
				mp.osd_message('Time Paste Requires Running Video')
				msg.info('Time can only be pasted if a video is running')
			end
		end
	end
	
	if action == 'error-missingtime' then
		if o.osd_messages == true then
			mp.osd_message('Clipboard does not contain time for seeking:\n'..clip)
		end
		msg.info("Clipboard does not contain the time attribute and time for seeking:\n"..clip)
	end
	
	if action == 'error-samefile' then
		if o.osd_messages == true then
			mp.osd_message('Pasted file is already running:\n'..clip)
		end
		msg.info("Pasted file shown below is already running:\n"..clip)
	end

end

function paste()
	if o.osd_messages == true then
		mp.osd_message("Pasting...")
	end
	msg.info("Pasting...")

	clip = get_clipboard(clip)
	if not clip then msg.error('Error: clip is null' .. clip) return end
	clip, clip_file, clip_time = parse_clipboard(clip)
	
	local currentVideoExtension = string.lower(get_extension(clip_file))
	
	if filePath == nil then
		if file_exists(clip_file) and has_value(o.paste_extensions, currentVideoExtension) 
		or starts_protocol(o.paste_protocols, clip_file) then
			trigger_paste_action('load-file')
		elseif file_exists(clip_file) and has_value(o.paste_subtitles, currentVideoExtension) then
			trigger_paste_action('error-subtitle')
		elseif not has_value(o.paste_extensions, currentVideoExtension) then
			trigger_paste_action('error-unsupported')
		elseif not file_exists(clip_file) then
			trigger_paste_action('error-missing')
		end
	else
		if file_exists(clip_file) and has_value(o.paste_subtitles, currentVideoExtension) then
			trigger_paste_action('load-subtitle')
		elseif o.running_paste_behavior == 'playlist' then
			if filePath ~= clip_file and file_exists(clip_file) and has_value(o.paste_extensions, currentVideoExtension)
			or filePath ~= clip_file and starts_protocol(o.paste_protocols, clip_file)
			or filePath == clip_file and file_exists(clip_file) and has_value(o.paste_extensions, currentVideoExtension) and clip_time == nil
			or filePath == clip_file and starts_protocol(o.paste_protocols, clip_file) and clip_time == nil then
				trigger_paste_action('add-playlist')
			elseif clip_time ~= nil then
				trigger_paste_action('file-seek')
			elseif not has_value(o.paste_extensions, currentVideoExtension) then
				trigger_paste_action('error-unsupported')
			elseif not file_exists(clip_file) then
				trigger_paste_action('error-missing')
			end
		elseif o.running_paste_behavior == 'timestamp' then
			if clip_time ~= nil then
				trigger_paste_action('file-seek')
			elseif file_exists(clip_file) and has_value(o.paste_extensions, currentVideoExtension) 
			or starts_protocol(o.paste_protocols, clip_file) then
				trigger_paste_action('add-playlist')
			elseif not has_value(o.paste_extensions, currentVideoExtension) then
				trigger_paste_action('error-unsupported')
			elseif not file_exists(clip_file) then
				trigger_paste_action('error-missing')
			end
		elseif o.running_paste_behavior == 'force' then
			if filePath ~= clip_file and file_exists(clip_file) and has_value(o.paste_extensions, currentVideoExtension) 
			or filePath ~= clip_file and starts_protocol(o.paste_protocols, clip_file) then
				trigger_paste_action('load-file')
			elseif clip_time ~= nil then
				trigger_paste_action('file-seek')
			elseif file_exists(clip_file) and filePath == clip_file 
			or filePath == clip_file and starts_protocol(o.paste_protocols, clip_file) then
				trigger_paste_action('add-playlist')
			elseif not has_value(o.paste_extensions, currentVideoExtension) then
				trigger_paste_action('error-unsupported')
			elseif not file_exists(clip_file) then
				trigger_paste_action('error-missing')
			end
		end
	end
end


function paste_specific(action)
	if not action then return end
	
	if o.osd_messages == true then
		mp.osd_message("Pasting...")
	end
	msg.info("Pasting...")
	
	clip = get_clipboard(clip)
	if not clip then msg.error('Error: clip is null' .. clip) return end
	clip, clip_file, clip_time = parse_clipboard(clip)
	local currentVideoExtension = string.lower(get_extension(clip_file))
	
	if action == 'playlist' then
		if file_exists(clip_file) and has_value(o.paste_extensions, currentVideoExtension)
		or starts_protocol(o.paste_protocols, clip_file) then
			trigger_paste_action('add-playlist')
		elseif not has_value(o.paste_extensions, currentVideoExtension) then
			trigger_paste_action('error-unsupported')
		elseif not file_exists(clip_file) then
			trigger_paste_action('error-missing')
		end
	end
	
	if action == 'timestamp' then
		if filePath == nil then
			trigger_paste_action('error-time')
		elseif clip_time ~= nil then
			trigger_paste_action('file-seek')
		elseif clip_time == nil then
			trigger_paste_action('error-missingtime')
		elseif not has_value(o.paste_extensions, currentVideoExtension) then
			trigger_paste_action('error-unsupported')
		elseif not file_exists(clip_file) then
			trigger_paste_action('error-missing')
		end
	end
	
	if action == 'force' then
		if filePath ~= clip_file and file_exists(clip_file) and has_value(o.paste_extensions, currentVideoExtension) 
		or filePath ~= clip_file and starts_protocol(o.paste_protocols, clip_file) then
			trigger_paste_action('load-file')
		elseif file_exists(clip_file) and filePath == clip_file 
		or filePath == clip_file and starts_protocol(o.paste_protocols, clip_file) then
			trigger_paste_action('error-samefile')
		elseif not has_value(o.paste_extensions, currentVideoExtension) then
			trigger_paste_action('error-unsupported')
		elseif not file_exists(clip_file) then
			trigger_paste_action('error-missing')
		end
	end
end

mp.register_event('file-loaded', function()
	filePath, fileTitle = get_path()
	if clipboard_pasted == true then
		clip = get_clipboard(clip)
		if not clip then msg.error('Error: clip is null' .. clip) return end
		clip, clip_file, clip_time = parse_clipboard(clip)

		if filePath == clip_file and clip_time ~= nil then
			local video_duration = mp.get_property_number('duration')
			seekTime = clip_time + o.resume_offset

			if seekTime > video_duration then 
				if o.osd_messages == true then
					mp.osd_message('Time Paste Exceeds Video Length' .. o.time_seperator .. format_time(clip_time))
				end
				msg.info("The time pasted exceeds the video length:\n"..format_time(clip_time))
				return
			end 

			if seekTime < 0 then
				seekTime = 0
			end

			mp.commandv('seek', seekTime, 'absolute', 'exact')
			clipboard_pasted = false
		end
	end
end)

bind_keys(o.copy_keybind, 'copy', copy)
bind_keys(o.copy_specific_keybind, 'copy-specific', function()copy_specific(o.copy_specific_behavior)end)
bind_keys(o.paste_keybind, 'paste', paste)
bind_keys(o.paste_specific_keybind, 'paste-specific', function()paste_specific(o.paste_specific_behavior)end)
