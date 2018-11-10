local utils = require 'mp.utils'
local msg = require 'mp.msg'
local extensions = {
    'mkv', 'avi', 'mp4', 'ogv', 'webm', 'rmvb', 'flv', 'wmv', 'mpeg', 'mpg', 'm4v', '3gp',
    'mp3', 'wav', 'ogm', 'flac', 'm4a', 'wma', 'ogg', 'opus',
}
local pasted = false

local function get_extension(path)
    match = string.match(path, '%.([^%.]+)$' )
    if match == nil then
        return 'nomatch'
    else
        return match
    end
end

local function get_extentionpath(path)
    match = string.match(path,'(.*)%.([^%.]+)$')
    if match == nil then
        return 'nomatch'
    else
        return match
    end
end

local function has_extension (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function get_clipboard()
    local res = utils.subprocess({ args = {
        'powershell', '-NoProfile', '-Command', [[& {
            Trap {
                Write-Error -ErrorRecord $_
                Exit 1
            }
            $clip = Get-Clipboard -Raw -Format Text -TextFormatType UnicodeText
			if ($clip) {
                $clip = $clip
				}
			else {
				$clip = Get-Clipboard -Raw -Format FileDropList
			}
            $u8clip = [System.Text.Encoding]::UTF8.GetBytes($clip)
            [Console]::OpenStandardOutput().Write($u8clip, 0, $u8clip.Length)
        }]]
    } })
    if not res.error then
        return res.stdout
    end
    return ''
end

local function set_clipboard(text)
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
end

mp.register_event('end-file', function()
	pasted = false
end)

mp.add_key_binding("ctrl+c", "copy", function()
    local filePath = mp.get_property_native('path')
	if (filePath ~= nil) then
		local time = math.floor(mp.get_property_number('time-pos'))
		set_clipboard(filePath..'&t='..tostring(time))
		mp.osd_message("Copied: Video&Time:\n"..filePath..'&t='..tostring(time))
	else
		return false
	end
end)

mp.add_key_binding("ctrl+C", "copy-path", function()
    local filePath = mp.get_property_native('path')
	if (filePath ~= nil) then
		set_clipboard(filePath)
		mp.osd_message("Copied Video Only:\n"..filePath)
	else
		return false
	end
end)

mp.add_key_binding("ctrl+v", "paste", function()
	local clip = get_clipboard()
	local filePath = mp.get_property_native('path')
	local time 

	if string.match(clip, '(.*)&t=') then
		videoFile = string.match(clip, '(.*)&t=')
		time = string.match(clip, '&t=(.*)')
	elseif string.match(clip, '^\"(.*)\"$') then
		videoFile = string.match(clip, '^\"(.*)\"$')
	else
		videoFile = clip
	end	
	
	local currentVideoExtension = string.lower(get_extension(videoFile))
	local currentVideoExtensionPath = (get_extentionpath(videoFile))
	
	if (filePath == nil) and has_extension(extensions, currentVideoExtension) and (currentVideoExtensionPath~= '') then
		mp.commandv('loadfile', videoFile)
		mp.osd_message("Pasted Video:\n"..videoFile)
	elseif (filePath == nil) and (videoFile:find('https?://') == 1) then
		mp.commandv('loadfile', videoFile)
		mp.osd_message("Pasted Video:\n"..videoFile)
	elseif (filePath ~= nil) and (filePath ~= videoFile) and has_extension(extensions, currentVideoExtension) and (currentVideoExtensionPath~= '') or (videoFile:find('https?://') == 1) then
		mp.commandv('loadfile', videoFile, 'append-play')
		mp.osd_message("Pasted Video Into Playlist:\n"..videoFile)
	else
		mp.osd_message("Failed To Add Into Playlist:\n\"No Copied Video Found\"\nClipboard Contains:\n"..clip)
	end

	if (filePath == videoFile) and (time ~= nil) then
		mp.commandv('seek', time, 'absolute', 'exact')
		mp.osd_message('Resumed to Copied Time of This Video')
	end
	
	pasted = true
end)

mp.add_key_binding('ctrl+V', 'paste-playlist', function()
	local clip = get_clipboard()
	local filePath = mp.get_property_native('path')

	if string.match(clip, '(.*)&t=') then
		videoFile = string.match(clip, '(.*)&t=')
	elseif string.match(clip, '^\"(.*)\"$') then
		videoFile = string.match(clip, '^\"(.*)\"$')
	else
		videoFile = clip
	end	
	local currentVideoExtension = string.lower(get_extension(videoFile))
	local currentVideoExtensionPath = (get_extentionpath(videoFile))
	
	if has_extension(extensions, currentVideoExtension) and (currentVideoExtensionPath~= '') or (videoFile:find('https?://') == 1) then
		mp.commandv('loadfile', videoFile, 'append-play')
		mp.osd_message("Pasted Into Playlist:\n"..videoFile)
	else
		mp.osd_message("Failed To Add Into Playlist:\n\"No Copied Video Found\"\nClipboard Contains:\n"..clip)
	end
	
	pasted = true
end)

mp.register_event('file-loaded', function()
	if (pasted == true) then
		local clip = get_clipboard()
		local time = string.match(clip, '&t=(.*)')
		local videoFile = string.match(clip, '(.*)&t=')
		local filePath = mp.get_property_native('path')

		if (filePath == videoFile) and (time ~= nil) then
			mp.commandv('seek', time, 'absolute', 'exact')
		end
	else
		return false
	end
end)
