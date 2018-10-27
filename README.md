

# Introduction
This repository contain scripts I have made for [mpv media player](https://github.com/mpv-player/mpv/). To add scripts from this repository, download the desired script in your `mpv/scripts/` directory (click [here](https://mpv.io/manual/master/#lua-scripting) to know more about mpv scripts).
Table of Contents
 - [SmartCopyPaste Script](https://github.com/Eisa01/mpv-scripts#smartcopypaste-script)
	 - [SmartCopyPaste (Basic AND Pro) Features](https://github.com/Eisa01/mpv-scripts#smartcopypaste-basic-and-pro-features)
	 - [SmartCopyPaste (Pro ONLY) Features](https://github.com/Eisa01/mpv-scripts#smartcopypaste-pro-only-features)
	 - [SmartCopyPaste Usage Guide](https://github.com/Eisa01/mpv-scripts#smartcopypaste-usage-guide)
	 - [SmartCopyPaste Compatibility](https://github.com/Eisa01/mpv-scripts#smartcopypaste-compatibility)
	 - [SmartCopyPaste To-Do List](https://github.com/Eisa01/mpv-scripts#smartcopypaste-to-do-list)
	 - [SmartCopyPaste-Basic Changelog](https://github.com/Eisa01/mpv-scripts#smartcopypaste-basic-changelog)
	 - [SmartCopyPaste-Pro Changelog](https://github.com/Eisa01/mpv-scripts#smartcopypaste-pro-changelog)
# SmartCopyPaste Script
SmartCopyPaste is a script for mpv media player, the script adds a very smart copy paste experience to mpv. It gives mpv the ability to load videos simply by pasting them directly into mpv. It also gives you the option to quickly resume video by pasting or opening a copied video. "copying the video you are currently playing creates a bookmark point in clipboard that detects the video and its time, which gives the option to resume watching upon pasting or opening the copied video". SmartCopyPaste works whether the video is a URL or it is a video you have locally.  
Additionally, there are two versions of SmartCopyPaste, a **basic** version, and a **pro** version. The pro version contain additional features to save your clipboard giving the option to paste at any time even if clipboard was overwritten or cleared. More details about SmartCopyPaste are explained in the sections below. To use it, either download *`smartcopypaste-basic.lua`* **or** *`smartcopypaste-pro.lua`* file into your `mpv/scripts/` directory. 
### SmartCopyPaste (Basic AND Pro) Features
 - **URL Paste Feature:** Copy any video URL from anywhere and play it by pressing **[ctrl]+[v]** directly into mpv
	- *Before accepting paste:*
		- It avoids accidental video change, **it only accepts pasting new video if there is no video already playing**
		- Supports youtube-dl extension, so pasting youtube page link should work immediately (no need to find the exact video link) this is for any supported site in youtube-dl extension. [List of youtube-dl supported sites](https://rg3.github.io/youtube-dl/supportedsites.html)
	- *Feature demonstration:*
	- ![URL pasted into mpv](https://media.giphy.com/media/uWczvTWFVcxwXG9zJI/giphy.gif)
 - **Powerful Paste Feature:** Copy any video or its path from anywhere and play it by pressing **[ctrl]+[v]** directly into mpv
	 - Supports copying the video itself and pasting it inside mpv
	 - Supports copying the path of video and pasting it inside mpv
	 - Supports native windows copy as path feature for videos and pasting inside mpv
	- *Before accepting paste:*
		 - It checks if the pasted path ends with a supported video extension such as **.mkv**
		 - It checks if the pasted path is not an empty extension such as a file-named (**.mkv**) 
		 - It avoids accidental video change, **it only accepts pasting new video if there is no video already playing**
	 - *Feature demonstration:*
	 - ![Local videos pasted into mpv](https://media.giphy.com/media/2zcXmABJzxY4XZfSmg/giphy.gif)
 - **Bookmark Feature:** Copy the time of the video by [ctrl]+[c] in mpv then resume the video at any time
	 - Supports pasting in the player immediately to open copied video along with its seeking time
		 - It avoids accidental video change,  it checks if the pasted time was of the same video
	 - Supports automatic seeking to the time you copied when you open the copied video (even without pasting)
		 - It avoids seeking wrongly, it checks if the opened video was the copied video 
	 - Supports the mentioned features in both local files and URLs
		 - It enables you to share path with people (such as video url) with resume time
		 - Or to open the video again and resume it by pasting path into mpv 
	 - Feature demonstration
	 - ![Resume copied time by paste](https://thumbs.gfycat.com/LeanPepperyCopperbutterfly-size_restricted.gif)
 - **Path Copy Feature:** Copy the video path by **[ctrl]**+**[C]**
	 - It enables you to share path with people (such as video url) without resume time
	 - Or to open the video again by pasting path into mpv without resuming the time
### SmartCopyPaste (Pro ONLY) Features
 - **Save Clipboard to Log Feature:** The copies from mpv, and the pastes into mpv will be kept in a log for far more powerful copy paste experience, and a history that you can find useful.
	 - Copying your open video by **[ctrl]** + **[c]** copies the video and its time while saving it to a log file located in `%APPDATA%\mpv\mpvClipboard.log`
	 - Pasting a video into mpv plays the video and also saves it to a log file located in `%APPDATA%\mpv\mpvClipboard.log`
 - **Powerful Bookmark Feature:** Copy the time of multiple videos by **[ctrl]**+**[c]** in mpv then resume any video even after clipboard is overwritten or it is cleared.
	 - Using the log, copying videos adds a bookmark point, so you can resume to your copy position in any and all copied videos by **[ctrl]**+**[v]**
	 - For multiple videos you copy their resume time will be saved and you can resume to exact position by pasting in each video
 - **Remember Videos Copied or Videos Pasted Feature:** If clipboard is replaced with anything such as 'random text', you can still paste the video ;)
	 - Paste video to play then paste to resume anything copied even if clipboard no longer contain the time
 - **Remember Last Video Copied or Last Video Paste Feature:** The last copied video or pasted will remain even after a device restart or clipboard changes.
	 - If mpv is idle you can always paste your last copied mpv video or last pasted video into mpv to play it then paste again to resume. (this works even if you have different types of files in clipboard)
 - **Quick access to Videos Clipboard History:** Gain quick access to your videos clipboard history to find your previous videos and play or share them.
	 - If mpv is idle (not running any video) simply copy by pressing **[ctrl]**+**[c]** to access your clipboard history
### SmartCopyPaste Usage Guide
 - **[ctrl]**+**[c]** to copy the video/path and its time
 - **[ctrl]**+**[C]** to copy the video/path without time
 - **[ctrl]**+**[v]** to paste the video *and time if available* (whether link or local video itself or any video path)
 - **[ctrl]**+**[c]** while mpv is idle (not playing a video) to access your videos clipboard history **(PRO ONLY)**
 - Open video that has its time copied to resume automatically (if video and its time is still in clipboard)
### SmartCopyPaste Compatibility
 - **SmartCopyPaste is currently for Windows only**
	 - To access windows clipboard, the method was inspired by [@wiiaboo](https://github.com/wiiaboo/) urlcopypaste script. Special thanks for his work.
### SmartCopyPaste To-Do List
 - While watching a video, add pasted video to playlist so pasted video plays after finishing current video instead of ignoring paste

 - Support more platforms
	 - Linux
 - ~~Enhance the bookmark feature of copy video and time by **[ctrl]**+**[c]**~~  (Done in **Pro** SmartCopyPaste)
	 - ~~Keep bookmark point even if it is no longer in the clipboard which gives the ability to paste even if the clipboard is overwritten~~ (**Done** in **Pro** SmartCopyPaste)
	 - ~~Make the bookmark point remain for multiple videos and give ability to resume to any saved bookmark point by **[ctrl]**+**[v]**~~ (**Done** in **Pro** SmartCopyPaste)
- ~~Add a shortcut to quickly access clipboard history for the pro version~~ (**Done** in **Pro 1.2** SmartCopyPaste)
### SmartCopyPaste-Basic Changelog
 - 1.0 - **(Basic)**
	- Initial release
- 1.1 - **(Basic)**
	- Fixed a bug that caused any thing pasted to be added automatically to playlist
	- Some other fixes and optimizations
- 1.2 - **(Basic)**
	- Added support for youtube-dl extension (by removing checking links if they contain video file format) so pasting youtube links should work immediately if you have youtube-dl extension. Works for all other websites that youtube dl extension supports.
	- Fixed issue that caused SmartCopyPaste to stop working if you copied in mpv while mpv was idle
	- Some other fixes and optimizations
### SmartCopyPaste-Pro Changelog
- 1.0 - **(Pro)**
	- Initial release of an all new pro version containing tons of newly added features! [(check pro features section)](https://github.com/Eisa01/mpv-scripts#SmartCopyPaste-Pro-ONLY-Features)
- 1.1 - **(Pro)**
	- Same fixes and optimizations as the basic version
- 1.2 - **(Pro)**
	- Added support for youtube-dl extension (by removing checking links if they contain video file format) so pasting youtube links should work immediately if you have youtube-dl extension. Works for all other websites that youtube dl extension supports.
	- Copying while mpv is idle now opens your clipboard history so you can copy any previous videos watched and paste to play them
	- Same fixes and optimizations as the basic version
