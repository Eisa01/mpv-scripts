local platform = nil --set to 'linux', 'windows' or 'macos' to override automatic assign

if not platform then
  local o = {}
  if mp.get_property_native('options/vo-mmcss-profile', o) ~= o then
    platform = 'windows'
  elseif mp.get_property_native('options/input-app-events', o) ~= o then
    platform = 'macos'
  else
    platform = 'linux'
  end
end

local utils = require 'mp.utils'
local msg = require 'mp.msg'

function handleres(res, args, primary)
  if not res.error and res.status == 0 then
      return res.stdout
  else
    if platform=='linux' and not primary then
      append(true)
      return nil
    end
    msg.error("There was an error getting "..platform.." clipboard: ")
    msg.error("  Status: "..(res.status or ""))
    msg.error("  Error: "..(res.error or ""))
    msg.error("  stdout: "..(res.stdout or ""))
    msg.error("args: "..utils.to_string(args))
    return nil
  end
end

local extensions = {
	--video & audio
    'ac3', 'a52', 'eac3', 'mlp', 'dts', 'dts-hd', 'dtshd', 'true-hd', 'thd', 'truehd', 'thd+ac3', 'tta', 'pcm', 'wav', 'aiff', 'aif',  'aifc', 'amr', 'awb', 'au', 'snd', 'lpcm', 'yuv', 'y4m', 'ape', 'wv', 'shn', 'm2ts', 'm2t', 'mts', 'mtv', 'ts', 'tsv', 'tsa', 'tts', 'trp', 'adts', 'adt', 'mpa', 'm1a', 'm2a', 'mp1', 'mp2', 'mp3', 'mpeg', 'mpg', 'mpe', 'mpeg2', 'm1v', 'm2v', 'mp2v', 'mpv', 'mpv2', 'mod', 'tod', 'vob', 'vro', 'evob', 'evo', 'mpeg4', 'm4v', 'mp4', 'mp4v', 'mpg4', 'm4a', 'aac', 'h264', 'avc', 'x264', '264', 'hevc', 'h265', 'x265', '265', 'flac', 'oga', 'ogg', 'opus', 'spx', 'ogv', 'ogm', 'ogx', 'mkv', 'mk3d', 'mka', 'webm', 'weba', 'avi', 'vfw', 'divx', '3iv', 'xvid', 'nut', 'flic', 'fli', 'flc', 'nsv', 'gxf', 'mxf', 'wma', 'wm', 'wmv', 'asf', 'dvr-ms', 'dvr', 'wtv', 'dv', 'hdv', 'flv','f4v', 'f4a', 'qt', 'mov', 'hdmov', 'rm', 'rmvb', 'ra', 'ram', '3ga', '3ga2', '3gpp', '3gp', '3gp2', '3g2', 'ay', 'gbs', 'gym', 'hes', 'kss', 'nsf', 'nsfe', 'sap', 'spc', 'vgm', 'vgz', 'm3u', 'm3u8', 'pls', 'cue',
	--images
	"ase", "art", "bmp", "blp", "cd5", "cit", "cpt", "cr2", "cut", "dds", "dib", "djvu", "egt", "exif", "gif", "gpl", "grf", "icns", "ico", "iff", "jng", "jpeg", "jpg", "jfif", "jp2", "jps", "lbm", "max", "miff", "mng", "msp", "nitf", "ota", "pbm", "pc1", "pc2", "pc3", "pcf", "pcx", "pdn", "pgm", "PI1", "PI2", "PI3", "pict", "pct", "pnm", "pns", "ppm", "psb", "psd", "pdd", "psp", "px", "pxm", "pxr", "qfx", "raw", "rle", "sct", "sgi", "rgb", "int", "bw", "tga", "tiff", "tif", "vtf", "xbm", "xcf", "xpm", "3dv", "amf", "ai", "awg", "cgm", "cdr", "cmx", "dxf", "e2d", "egt", "eps", "fs", "gbr", "odg", "svg", "stl", "vrml", "x3d", "sxd", "v2d", "vnd", "wmf", "emf", "art", "xar", "png", "webp", "jxr", "hdp", "wdp", "cur", "ecw", "iff", "lbm", "liff", "nrrd", "pam", "pcx", "pgf", "sgi", "rgb", "rgba", "bw", "int", "inta", "sid", "ras", "sun", "tga"
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


local function get_clipboard(primary) 
  if platform == 'linux' then
    local args = { 'xclip', '-selection', primary and 'primary' or 'clipboard', '-out' }
    return handleres(utils.subprocess({ args = args, cancellable = false }), args, primary)
  elseif platform == 'windows' then
    local args = {
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
    }
    return handleres(utils.subprocess({ args =  args, cancellable = false }), args)
  elseif platform == 'macos' then
    local args = { 'pbpaste' }
    return handleres(utils.subprocess({ args = args, cancellable = false }), args)
  end
  return nil
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


local function copy()
    local filePath = mp.get_property_native('path')
	
	if (filePath ~= nil) then
		local time = math.floor(mp.get_property_number('time-pos'))	
		set_clipboard(filePath..' |time='..tostring(time))
		mp.osd_message('Copied & Bookmarked:\n'..filePath..' |time='..tostring(time))
		
		local copyLog = os.getenv('APPDATA')..'/mpv/mpvClipboard.log';
		local copyLogAdd = io.open(copyLog, 'a+')
		
		copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), filePath..' |time='..tostring(time)))
		copyLogAdd:close()
	else
		local res = utils.subprocess({ args = {
        'powershell', '-NoProfile', '-Command', [[& {
		Trap {
                Write-Error -ErrorRecord $_
                Exit 1
            }
		Invoke-Item "$env:APPDATA\mpv\mpvClipboard.log"
        }]]
    } })
	
    if not res.error then
        return res.stdout
    end
    return false
	end
end


local function copy_path()
	local filePath = mp.get_property_native('path')

	if (filePath ~= nil) then
		set_clipboard(filePath)
		mp.osd_message('Copied & Bookmarked Video Only:\n'..filePath)
		
		local copyLog = os.getenv('APPDATA')..'/mpv/mpvClipboard.log';
		local copyLogAdd = io.open(copyLog, 'a+')
		
		copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), filePath))    
		copyLogAdd:close()
	else
		return false
	end
end


local function paste()
	local clip = get_clipboard()
	local filePath = mp.get_property_native('path')
	local time

	if string.match(clip, '(.*) |time=') then
		videoFile = string.match(clip, '(.*) |time=')
		time = string.match(clip, ' |time=(.*)')
	elseif string.match(clip, '^\"(.*)\"$') then
		videoFile = string.match(clip, '^\"(.*)\"$')
	else
		videoFile = clip
	end

	local currentVideoExtension = string.lower(get_extension(videoFile))
	local currentVideoExtensionPath = (get_extentionpath(videoFile))
	local copyLog = os.getenv('APPDATA')..'/mpv/mpvClipboard.log'
	local copyLogAdd = io.open(copyLog, 'a+')
	local copyLogOpen = io.open(copyLog, 'r+')
	local linePosition
	local videoFound = ''
	local logVideo
	local logVideoTime

	for line in copyLogOpen:lines() do
	
		linePosition = line:find(']')
		line = line:sub(linePosition + 2)
	   
		if line.match(line, '(.*) |time=') == filePath then
			videoFound = line
		end
	end

	logVideo = string.match(videoFound, '(.*) |time=')
	logVideoTime = string.match(videoFound, ' |time=(.*)')
	
	if (filePath == logVideo) and (logVideoTime ~= nil) then
		mp.commandv('seek', logVideoTime, 'absolute', 'exact')
		mp.osd_message('Resumed to Copied Time')
	end
	
	if (filePath ~= nil) and (logVideoTime == nil) then
		mp.osd_message('No Copied Time Found')
	end
	
	if (filePath == nil) and has_extension(extensions, currentVideoExtension) and (currentVideoExtensionPath~= '') then
		mp.commandv('loadfile', videoFile)
		mp.osd_message('Pasted:\n'..videoFile)
		
		if (time ~= nil) then
			copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), videoFile..' |time='..tostring(time)))
		else
			copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), videoFile))
		end
	elseif (filePath == nil) and (videoFile:find('https?://') == 1) then
		mp.commandv('loadfile', videoFile)
		mp.osd_message('Pasted URL:\n'..videoFile)
		
		if (time ~= nil) then
			copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), videoFile..' |time='..tostring(time)))
		else
			copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), videoFile))
		end
    elseif (filePath == nil) and not has_extension(extensions, currentVideoExtension) and not (videoFile:find('https?://') == 1) then
		copyLogLastOpen = io.open(copyLog, 'r+')

		for line in copyLogLastOpen:lines() do
			lastVideoFound = line
		end
	
		if (lastVideoFound ~= nil) then
			linePosition = lastVideoFound:find(']')
			lastVideoFound = lastVideoFound:sub(linePosition + 2)
			
			if string.match(lastVideoFound, '(.*) |time=') then
				videoFile = string.match(lastVideoFound, '(.*) |time=')
			else
				videoFile = lastVideoFound
			end
			
			mp.commandv('loadfile', videoFile)
			mp.osd_message('Pasted Last Logged Item:\n'..videoFile)
		else 
			mp.osd_message('Pasted Unsupported Item:\n'..clip)
		end
		copyLogLastOpen:close()
	end
	
	if (filePath == videoFile) and (time ~= nil) then
		mp.commandv('seek', time, 'absolute', 'exact')
		mp.osd_message('Resumed to Copied Time')
	end
	
	pasted = true
	copyLogAdd:close()
	copyLogOpen:close()
end

local function paste_playlist()
	local clip = get_clipboard()
	local filePath = mp.get_property_native('path')
	local time
	
	if string.match(clip, '(.*) |time=') then
		videoFile = string.match(clip, '(.*) |time=')
		time = string.match(clip, ' |time=(.*)')
	elseif string.match(clip, '^\"(.*)\"$') then
		videoFile = string.match(clip, '^\"(.*)\"$')
	else
		videoFile = clip
	end
	
	local copyLog = os.getenv('APPDATA')..'/mpv/mpvClipboard.log'
	local copyLogAdd = io.open(copyLog, 'a+')
	local copyLogOpen = io.open(copyLog, 'r+')
	local currentVideoExtension = string.lower(get_extension(videoFile))
	local currentVideoExtensionPath = (get_extentionpath(videoFile))
	
	if has_extension(extensions, currentVideoExtension) and (currentVideoExtensionPath~= '') or (videoFile:find('https?://') == 1) then
		mp.commandv('loadfile', videoFile, 'append-play')
		mp.osd_message('Pasted Into Playlist:\n'..videoFile)
		
		if (time ~= nil) then
			copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), videoFile..' |time='..tostring(time)))
		else
			copyLogAdd:write(('[%s] %s\n'):format(os.date('%d/%b/%y %X'), videoFile))
		end
	else
		mp.osd_message('Failed to Add Into Playlist\nPasted Unsupported Item:\n'..clip)
	end
	
	pasted = true
	copyLogAdd:close()
	copyLogOpen:close()
end

mp.register_event('end-file', function()
	pasted = false
end)

mp.register_event('file-loaded', function()
	if (pasted == true) then
		local clip = get_clipboard()
		local time = string.match(clip, ' |time=(.*)')
		local videoFile = string.match(clip, '(.*) |time=')
		local filePath = mp.get_property_native('path')

		if (filePath == videoFile) and (time ~= nil) then
			mp.commandv('seek', time, 'absolute', 'exact')
		end	
	else
		return false
	end
end)


mp.add_key_binding('ctrl+c', 'copy', copy)
mp.add_key_binding('ctrl+C', 'copyCaps', copy)
mp.add_key_binding('ctrl+v', 'paste', paste)
mp.add_key_binding('ctrl+V', 'pasteCaps', paste)

mp.add_key_binding('ctrl+alt+c', 'copy-path', copy_path)
mp.add_key_binding('ctrl+alt+C', 'copy-pathCaps', copy_path)
mp.add_key_binding('ctrl+alt+v', 'paste-playlist', paste_playlist)
mp.add_key_binding('ctrl+alt+V', 'paste-playlistCaps', paste_playlist)
