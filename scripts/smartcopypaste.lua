local utils = require 'mp.utils'
local msg = require 'mp.msg'
local extensions = {
    'mkv', 'avi', 'mp4', 'ogv', 'webm', 'rmvb', 'flv', 'wmv', 'mpeg', 'mpg', 'm4v', '3gp',
    'mp3', 'wav', 'ogm', 'flac', 'm4a', 'wma', 'ogg', 'opus',
}

local function get_extension(path)
    match = string.match(path, "%.([^%.]+)$" )
    if match == nil then
        return "nomatch"
    else
        return match
    end
end

local function get_extentionpath(path)
    match = string.match(path,"(.*)%.([^%.]+)$")
    if match == nil then
        return "nomatch"
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

mp.add_key_binding("ctrl+c", "copy", function()
    local text = mp.get_property_native('path', '')
    local time = math.floor(mp.get_property_number('time-pos'))
    set_clipboard(text..'&t='..tostring(time))
end)

mp.add_key_binding("ctrl+C", "copy-wo-time", function()
    local text = mp.get_property_native('path', '')
    set_clipboard(text)
end)

mp.add_key_binding("ctrl+v", "paste", function()
    local text = get_clipboard()
	local file
	
	if string.match(text, "(.*)&t=") then
		file = string.match(text, "(.*)&t=")
	elseif string.match(text, "^\"(.*)\"$") then
		file = string.match(text, "^\"(.*)\"$")
	else
		file = text
	end
	
	local time = string.match(text, "&t=(.*)")
	local currrentExtension = string.lower(get_extension(file))
	local currrentExtentionPath = (get_extentionpath(file))
	local filepath = mp.get_property_native('path', '')
	
	if has_extension(extensions, currrentExtension) and (currrentExtentionPath~= "") then
		mp.commandv('loadfile', file, 'append-play')
	end
	
	if (file ~= text) and string.match(text, "(.*)&t=") then
		mp.commandv('loadfile', file, 'append-play')
	end
	
	if (file:find("https?://") == 1) and contain_extension(extensions, file) then
        mp.commandv('loadfile', file, 'append-play')
    end
	
	if (filepath == file) and (time ~= nil) then
		mp.commandv('seek', time, 'absolute', 'exact')
	end

end)

mp.register_event('file-loaded', function()
    local text = get_clipboard()
	local time = string.match(text, "&t=(.*)")
	local file = string.match(text, "(.*)&t=")
	local filepath = mp.get_property_native('path', '')

	if (filepath == file) and (time ~= nil) then
		mp.commandv('seek', time, 'absolute', 'exact')
	end
	
end)
