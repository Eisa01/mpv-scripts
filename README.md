# Introduction
This repository contain scripts I have made for [mpv media player](https://github.com/mpv-player/mpv/). To add scripts from this repository, download the desired script in your `mpv/scripts/` directory (click [here](https://mpv.io/manual/master/#lua-scripting) to know more about mpv scripts).

**Table of Contents**
- [**SmartCopyPaste Script**](https://github.com/Eisa01/mpv-scripts#smartcopypaste-script)
 	- [SmartCopyPaste Features and Usage Guide](https://github.com/Eisa01/mpv-scripts#smartcopypaste-features-and-usage-guide)
	- [SmartCopyPaste Compatibility](https://github.com/Eisa01/mpv-scripts#smartcopypaste-compatibility)
	- [SmartCopyPaste To-Do List](https://github.com/Eisa01/mpv-scripts#smartcopypaste-to-do-list)
	- [SmartCopyPaste Changelog](https://github.com/Eisa01/mpv-scripts#smartcopypaste-changelog)
- [**SmartCopyPaste-II Script**](https://github.com/Eisa01/mpv-scripts#smartcopypaste-ii-script)
 	- [SmartCopyPaste-II Features and Usage Guide](https://github.com/Eisa01/mpv-scripts#smartcopypaste-ii-features-and-usage-guide)
	- [SmartCopyPaste-II Compatibility](https://github.com/Eisa01/mpv-scripts#smartcopypaste-ii-compatibility)
	- [SmartCopyPaste-II To-Do List](https://github.com/Eisa01/mpv-scripts#smartcopypaste-ii-to-do-list)
	- [SmartCopyPaste-II Changelog](https://github.com/Eisa01/mpv-scripts#smartcopypaste-ii-changelog)
- [**SmartHistory Script**](https://github.com/Eisa01/mpv-scripts#smarthistory-script)
	- [SmartHistory Features and Usage Guide](https://github.com/Eisa01/mpv-scripts#smarthistory-features-and-usage-guide)
	- [SmartHistory Compatibility](https://github.com/Eisa01/mpv-scripts#smarthistory-compatibility)
	- [SmartHistory To-Do List](https://github.com/Eisa01/mpv-scripts#smarthistory-to-do-list)
	- [SmartHistory Changelog](https://github.com/Eisa01/mpv-scripts#smarthistory-changelog)
- [**SimpleUndo Script**](https://github.com/Eisa01/mpv-scripts#simpleundo-script)
	- [SimpleUndo Features and Usage Guide](https://github.com/Eisa01/mpv-scripts#simpleundo-features-and-usage-guide)
	- [SimpleUndo Compatibility](https://github.com/Eisa01/mpv-scripts#simpleundo-compatibility)
	- [SimpleUndo To-Do List](https://github.com/Eisa01/mpv-scripts#simpleundo-to-do-list)
	- [SimpleUndo Changelog](https://github.com/Eisa01/mpv-scripts#simpleundo-changelog)
# SmartCopyPaste Script
SmartCopyPaste is a script for mpv media player, the script adds a very smart copy paste experience to mpv. It gives mpv the ability to load videos simply by pasting them into mpv. As for copying,  pressing [ctrl]+[c] on a video, copies the video path and its time to clipboard, which enables paste to resume or to access video with the copied time by pasting. To use it, download *`SmartCopyPaste.lua`* file into your `mpv/scripts/` directory. 
### SmartCopyPaste Features and Usage Guide
 - **Features**
	- **OSD** (On Screen Display): Displays any SmartCopyPaste action within mpv.
	- **youtube-dl Extension Support** Immediately paste links without finding exact video address for youtube and any other youtube-dl extension supported sites.
- **While mpv is active (running a video)**
	 - **[ctrl]**+**[c]** to copy video path with time
	 - **[ctrl]**+**[C]** to copy video path without time
	 - **[ctrl]**+**[v]** to jump to the copied time
	 - **[ctrl]**+**[v]** when different video is copied, [ctrl]+[v] will add video into playlist
	 - **[ctrl]**+**[V]** to add video into playlist to play it next
 - **While mpv is idle (NOT running a video)**
	 - **[ctrl]**+**[v]** to play the copied video *and time if available* (whether link or local video or video path)
### SmartCopyPaste Compatibility
 - **SmartCopyPaste is currently for Windows only**
	 - To access windows clipboard, the method was inspired by [@wiiaboo](https://github.com/wiiaboo/) urlcopypaste script. Special thanks for his work.
### SmartCopyPaste To-Do List
 - Support more platforms
 - Can't think of anything else, have an idea... let me know ;)
### SmartCopyPaste Changelog
- Latest Changes **(1.5)**
	- Fixed automatic resume of copied time issue
# SmartCopyPaste-II Script
SmartCopyPaste is a script for mpv media player, the script adds a very smart copy paste experience to mpv. It gives mpv the ability to load videos simply by pasting them into mpv. As for copying,  pressing [ctrl]+[c] on a video, copies the video path and its time to clipboard, which enables paste to resume or to access video with the copied time by pasting. 
The **II** version contain additional features which saves your clipboard into a log file. The log adds the option to paste at any time even if clipboard was overwritten or cleared. 

Basically, copying a video will bookmark the video and time, while pasting will access the bookmark. To use it, download *`SmartCopyPaste-II.lua`* file into your `mpv/scripts/` directory. 
### SmartCopyPaste-II Features and Usage Guide
- **Features**
	- **Save Clipboard to a Log File:** The copies from mpv, and the pastes into mpv will be kept in a log file located in `%APPDATA%\mpv\mpvClipboard.log`.
	- **OSD**: Displays any SmartCopyPaste action within mpv.
	- **youtube-dl Extension Support** Immediately paste links without finding exact video address for youtube and any other youtube-dl extension supported sites.
- **While mpv is active (running a video)**
	 - **[ctrl]**+**[c]** to copy video path with time and bookmark
	 - **[ctrl]**+**[C]** to copy video path without time and bookmark
	 - **[ctrl]**+**[v]** to jump to the copied time
	 - **[ctrl]**+**[v]** to jump to the latest bookmarked position in the bookmarked video
	 - **[ctrl]**+**[V]** to add video into playlist to play it next
 - **While mpv is idle (NOT running a video)**
	 - **[ctrl]**+**[v]** to play the copied video *and time if available* (whether link or local video or video path)
	 - **[ctrl]**+**[v]** when no video is currently copied, [ctrl]+[v] will find and play your last copied or pasted video
	 - **[ctrl]**+**[c]** to access your videos clipboard history
### SmartCopyPaste-II Compatibility
 - **SmartCopyPaste-II is currently for Windows only**
	 - To access windows clipboard, the method was inspired by [@wiiaboo](https://github.com/wiiaboo/) urlcopypaste script. Special thanks for his work.
### SmartCopyPaste-II To-Do List
 - Support more platforms
 - Can't think of anything else, have an idea... let me know ;)
### SmartCopyPaste-II Changelog
- Latest Changes **(1.5)**
	- Fixed automatic resume of copied time issue
	- Some other fixes and optimizations
# SmartHistory Script
SmartHistory is a script for mpv media player, the script adds a smart history functionality to mpv. It logs videos that you opened into `%APPDATA%\mpv\mpvHistory.log` along with the time you have reached on each video. The script uses the log to provide you with various features. More details about SmartHistory are explained in the sections below. To use it, download *`SmartHistory.lua`* file into your `mpv/scripts/` directory. 
### SmartHistory Features and Usage Guide
- **Features**
	-  **Logs Opened Videos to a Log File:** All videos opened in mpv will be logged to create a history in `%APPDATA%\mpv\mpvHistory.log`. The format is: [date and time] of accessing video, the path & reached video time.
	- **OSD**: Displays any SmartHistory action within mpv.
- **While mpv is idle (NOT running a video)**
	- **[ctrl]**+**[l]** to immediately load last closed video 
	- **[ctrl]**+**[r]** to open history log for list of played videos
		- Use this along with smartcopypaste script to copy and paste video from history log into mpv
- **While mpv is active (running a video)**
	- **[ctrl]**+**[r]** to resume in any previously closed videos
	- **[ctrl]**+**[l]** to add previously closed video into playlist  
		- Useful for cases when you opened another video by accident and you want to get back to the last video
### SmartHistory Compatibility
 - **SmartHistory is currently for Windows only**
	 - To create the log file, the method was inspired by a deleted author from a reddit post. Special thanks for his work.
### SmartHistory To-Do List
 - Support more platforms
 - Can't think of anything else, have an idea... let me know ;)
### SmartHistory Changelog
 - Latest Changes - **(1.2)**
 	- One small bug squashed
 - (1.1)
 	- Tons of bug fixes and optimizations
	- Fixed issues that could cause script to crash
	- Added OSD everywhere possible
 - (1.0)
	- Initial release of SmartHistory Script
	- Contains simple history log file with many smart features mentioned above.
# SimpleUndo Script
SimpleUndo is a script for mpv media player, the script adds a simple undo functionality into mpv. If you accidentally seek/jump to a different time in the video, press undo [ctrl]+[z] to return to your previous time and vice-versa. To use it, download *`SimpleUndo.lua`* file into your `mpv/scripts/` directory. 
### SimpleUndo Features and Usage Guide
- **Features**
	- **OSD**: Displays any SimpleUndo action within mpv.
- **While mpv is active (running a video)**
	- **[ctrl]**+**[z]** to undo accidental seek by returning to previous time and vise-versa.
### SimpleUndo Compatibility
 - **All platforms that are supported by mpv media player**
	 - Should be able to work on all platforms that mpv supports.
### SimpleUndo To-Do List
 - Trying to keep it simple, [ctrl]+[z] does all the work.. Have a simple idea? Let me know.. ;)
 - Find a way to make it work even if seeking was continuous.
### SimpleUndo Changelog
 - Latest Changes - **(2.0)** [2/27/2019] 
	 - An all new 2.0 version taking SimpleUndo to a whole new level.
	 - Now it should work even in all different kinds of jumping in video. Such as, dragging the mouse, using multiple key-presses, or holding the seeking button, and even if you use an external script to seek.
 - **(1.1)** [2/24/2019] 
	- Lighter smaller code, no more variable tables since one value is enough for [ctrl]+[z] action.
 - **(1.0)** [2/23/2019] 
	- Initial release of SimpleUndo Script
