local utils = require 'mp.utils'
local msg = require 'mp.msg'
local extensions = {
    'mkv', 'avi', 'mp4', 'ogv', 'webm', 'rmvb', 'flv', 'wmv', 'mpeg', 'mpg', 'm4v', '3gp',
    'mp3', 'wav', 'ogm', 'flac', 'm4a', 'wma', 'ogg', 'opus',
}

local function get_extension(path)
	match = string.match(path, '%.([^%.]+)$')
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

local function contain_extension (tab, val)
	for index, value in ipairs(tab) do
		if value.match(val, value) then
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

mp.add_key_binding('ctrl+c', 'copy', function()
	local filePath = mp.get_property_native('path')
	local time = math.floor(mp.get_property_number('time-pos'))
	set_clipboard(filePath..'&t='..tostring(time))
	local copyLog = os.getenv('APPDATA')..'/mpv/mpvClipboard.log';
	local copyLogAdd = io.open(copyLog, 'a+')
	copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), filePath..'&t='..tostring(time)))    
	copyLogAdd:close()
end)

mp.add_key_binding('ctrl+C', 'copy-path', function()
	local filePath = mp.get_property_native('path')
	set_clipboard(filePath)
	local copyLog = os.getenv('APPDATA')..'/mpv/mpvClipboard.log';
	local copyLogAdd = io.open(copyLog, 'a+')
	copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), filePath..''))    
	copyLogAdd:close()
end)

mp.add_key_binding('ctrl+v', 'paste', function()
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

	local copyLog = os.getenv('APPDATA')..'/mpv/mpvClipboard.log'
	local copyLogOpen = io.open(copyLog, 'r+')
	local copyLogAdd = io.open(copyLog, 'a+')
	local linePosition
	local videoFound = ''
	local logVideo
	local logVideoTime
	
	for line in copyLogOpen:lines() do
		linePosition = line:find(']')
		line = line:sub(linePosition + 2)
		if line.match(line, '(.*)&t=') == filePath then
			videoFound = line
		end
	end

	copyLogOpen:close()

	logVideo = string.match(videoFound, '(.*)&t=')	
	logVideoTime = string.match(videoFound, '&t=(.*)')
	
	if (filePath == logVideo) and (logVideoTime ~= nil) then
		mp.commandv('seek', logVideoTime, 'absolute', 'exact')
	end
	
	if (filePath == nil) and has_extension(extensions, currentVideoExtension) and (currentVideoExtensionPath~= '') then
		mp.commandv('loadfile', videoFile)
		copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), videoFile..''))
		copyLogAdd:close()
	end
	
	if (filePath == nil) and not has_extension(extensions, videoFile) and not contain_extension(extensions, videoFile) then 
		copyLog = os.getenv('APPDATA')..'/mpv/mpvClipboard.log'
		copyLogOpen = io.open(copyLog, 'r+')

		for line in copyLogOpen:lines() do
			lastVideoFound = line
		end
		
		copyLogOpen:close()
		
		linePosition = lastVideoFound:find(']')
		lastVideoFound = lastVideoFound:sub(linePosition + 2)
		
		if string.match(lastVideoFound, '(.*)&t=') then
			videoFile = string.match(lastVideoFound, '(.*)&t=')
		else
			videoFile = lastVideoFound
		end
		
		mp.commandv('loadfile', videoFile)
		
		end
		
		if (filePath == nil) and (videoFile:find('https?://') == 1) and contain_extension(extensions, videoFile) then
			mp.commandv('loadfile', videoFile)
			copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), videoFile..''))--for 2.1 urls
			copyLogAdd:close()
		end
		
		if (filePath == videoFile) and (time ~= nil) then
			mp.commandv('seek', time, 'absolute', 'exact')
		end

end)

mp.register_event('file-loaded', function()
	local clip = get_clipboard()
	local time = string.match(clip, '&t=(.*)')
	local videoFile = string.match(clip, '(.*)&t=')
	local filePath = mp.get_property_native('path')

	if (filePath == videoFile) and (time ~= nil) then
		mp.commandv('seek', time, 'absolute', 'exact')
	end

end)
