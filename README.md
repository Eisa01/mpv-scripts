# Introduction
This repository contain scripts I have made for [mpv media player](https://github.com/mpv-player/mpv/). To add scripts from this repository, download the desired script in your `mpv/scripts/` directory (click [here](https://mpv.io/manual/master/#lua-scripting) to know more about mpv scripts).

**Table of Contents**
- [**SmartCopyPaste Script**](https://github.com/Eisa01/mpv-scripts#smartcopypaste-script)
 	- [SmartCopyPaste Usage Guide](https://github.com/Eisa01/mpv-scripts#smartcopypaste-usage-guide)
	- [SmartCopyPaste (Basic AND Pro) Features](https://github.com/Eisa01/mpv-scripts#smartcopypaste-basic-and-pro-features)
	- [SmartCopyPaste (Pro ONLY) Features](https://github.com/Eisa01/mpv-scripts#smartcopypaste-pro-only-features)
	- [SmartCopyPaste Compatibility](https://github.com/Eisa01/mpv-scripts#smartcopypaste-compatibility)
	- [SmartCopyPaste To-Do List](https://github.com/Eisa01/mpv-scripts#smartcopypaste-to-do-list)
	- [SmartCopyPaste-Basic Changelog](https://github.com/Eisa01/mpv-scripts#smartcopypaste-basic-changelog)
	- [SmartCopyPaste-Pro Changelog](https://github.com/Eisa01/mpv-scripts#smartcopypaste-pro-changelog)
- [**SmartHistory Script**](https://github.com/Eisa01/mpv-scripts#smarthistory-script)
	-	[SmartHistory Features and Usage Guide](https://github.com/Eisa01/mpv-scripts#smarthistory-features-and-usage-guide)
	-	[SmartHistory Compatibility](https://github.com/Eisa01/mpv-scripts#smarthistory-compatibility)
	-	[SmartHistory To-Do List](https://github.com/Eisa01/mpv-scripts#smarthistory-to-do-list)
	-	[SmartHistory Changelog](https://github.com/Eisa01/mpv-scripts#smarthistory-changelog)
# SmartCopyPaste Script
SmartCopyPaste is a script for mpv media player, the script adds a very smart copy paste experience to mpv. It gives mpv the ability to load videos simply by pasting them into mpv. As for copying,  pressing [ctrl]+[c] on a video, copies the video path and its time to clipboard, which enables paste to resume or to access video with the copied time by pasting.

Additionally, there are two versions of SmartCopyPaste, a **basic** version, and a **pro** version. The pro version contain additional features to save your clipboard into a log file giving the option to paste at any time even if clipboard was overwritten or cleared. More details about SmartCopyPaste are explained in the sections below. To use it, either download *`smartcopypaste-basic.lua`* **or** *`smartcopypaste-pro.lua`* file into your `mpv/scripts/` directory. 
### SmartCopyPaste Usage Guide
- **While mpv is active (running a video)**
	 - **[ctrl]**+**[c]** to copy video path with time
	 - **[ctrl]**+**[c]** to copy video path with time and **bookmark (PRO ONLY)**
	 - **[ctrl]**+**[C]** to copy video path without time
	 - **[ctrl]**+**[C]** to copy video path without time and **bookmark (PRO ONLY)**
	 - **[ctrl]**+**[v]** to jump to the copied time
	 - **[ctrl]**+**[v]** when different video is copied, [ctrl]+[v] will add video into playlist to play it next **(BASIC ONLY)**
	 - **[ctrl]**+**[v]** to jump to the latest bookmarked position in the bookmarked video **(PRO ONLY)**
	 - **[ctrl]**+**[V]** to add video into playlist to play it next
 - **While mpv is idle (NOT running a video)**
	 - **[ctrl]**+**[v]** to play the copied video *and time if available* (whether link or local video or video path)
	 - **[ctrl]**+**[v]** when no video is currently copied, [ctrl]+[v] will find and play your last copied or pasted video **(PRO ONLY)**
	 - **[ctrl]**+**[c]** to access your videos clipboard history **(PRO ONLY)**
 - **Other cases**
	 - Open video that has its time copied to resume automatically (if video and its time is still in clipboard)
### SmartCopyPaste (Basic AND Pro) Features
- **Powerful Paste:** Copy video or path or URL from anywhere and play it by pressing **[ctrl]**+**[v]** in idle mpv
- **Copy Video Path WITH Time:** In active mpv, copy the video path and time reached by **[ctrl]**+**[c]**
- **Copy Video Path WITHOUT Time:** In active mpv, copy the video path alone by **[ctrl]**+**[C]**
- **Resume to Copied Time:** If you copied a video path by [ctrl]+[c] within mpv, you will be able to open and resume the video by **[ctrl]**+**[v]**
- **Add Video to Playlist:** Adds copied video into playlist to play it next by **[ctrl]**+**[V]**
- **OSD** (On Screen Display): Displays any SmartCopyPaste action within mpv
- **youtube-dl Extension Support** Immediately paste links without finding exact video address for youtube and any other youtube-dl extension supported sites
### SmartCopyPaste (Basic ONLY) Feature
- **Auto Add Video to Playlist** If mpv is running a video and you have copied another video **[ctrl]**+**[v]** will add the copied video into playlist to play it next (this is only for basic since pro will resume to bookmarked time in the running video)
### SmartCopyPaste (PRO ONLY) Features
 - **Save Clipboard to a Log File:** The copies from mpv, and the pastes into mpv will be kept in a log file located in `%APPDATA%\mpv\mpvClipboard.log`
 - **Powerful Bookmark:** Copy video path and bookmark by **[ctrl]**+**[c]** then resume bookmark by **[ctrl]**+**[v]** in the bookmarked video.
 - **Remember Last Video Copied or Last Video Pasted:** While mpv is idle, press **[ctrl]**+**[v]** to play the last copied or pasted video even after device restarts or clipboard changes.
 - **Quick access to Videos Clipboard History:** If mpv is idle, press **[ctrl]**+**[c]** to access your clipboard history.

[**Additional reading and full overview on  features**](https://github.com/Eisa01/mpv-scripts/blob/master/documents/SmartCopyPaste%20Features%20Full%20Overview.md)
### SmartCopyPaste Compatibility
 - **SmartCopyPaste is currently for Windows only**
	 - To access windows clipboard, the method was inspired by [@wiiaboo](https://github.com/wiiaboo/) urlcopypaste script. Special thanks for his work.
### SmartCopyPaste To-Do List
 - Support more platforms
 - Can't think of anything else, have an idea... let me know ;)

[**To-Do List (Completed Items)**](https://github.com/Eisa01/mpv-scripts/blob/master/documents/SmartCopyPaste%20To-Do%20List%20(Completed%20Items).md)
### SmartCopyPaste Changelog
- Latest Changes **(1.3-Basic)**
	- Added Auto Add Video to Playlist when pasting a different video by  **[ctrl]**+**[v]**
	- Added Add to Playlist by **[ctrl]**+**[V]**
	- Added OSD within mpv for all SmartCopyPaste actions
	- Some other fixes and optimizations
- **(1.3-Pro)**
	- Fixed rare bug that caused SmartCopyPaste script to stop working
	- Added Add to Playlist by **[ctrl]**+**[V]**
	- Added OSD within mpv for all SmartCopyPaste actions
	- Some other fixes and optimizations
- Latest Changes **(1.4-Pro)**
	- Fixed issue that could cause script to stop working
	- Other important fixes and optimizations
	
[**SmartCopyPaste Full Changelog**](https://github.com/Eisa01/mpv-scripts/blob/master/documents/SmartCopyPaste%20Full%20Changelog.md)
# SmartHistory Script
SmartHistory is a script for mpv media player, the script adds a smart history functionality to mpv. It logs videos that you opened into `%APPDATA%\mpv\mpvHistory.log` along with the time you have reached on each video. The script uses the log to provide you with various features. More details about SmartHistory are explained in the sections below. To use it, download *`smartHistory.lua`* file into your `mpv/scripts/` directory. 
### SmartHistory Features and Usage Guide
- **Features**
	-  **Logs Opened Videos to a Log File:** All videos opened in mpv will be logged to create a history in `%APPDATA%\mpv\mpvHistory.log`. The format is: [date and time] of accessing video, the path & reached video time.
	- **OSD**: Displays any SmartHistory action within mpv
- **While mpv is idle (NOT running a video)**
	- Load last closed video by **[ctrl]**+**[l]**
	- Immediately open history log for list of played videos by **[ctrl]**+**[r]**
		- Use this along with smartcopypaste script to copy and paste video from history log into mpv
- **While mpv is active (running a video)**
	- Optional resume for previously closed videos by  **[ctrl]**+**[r]**
	- Add previously closed video into playlist to play it next by  **[ctrl]**+**[l]**
		- Useful for cases when you opened another video by accident and you want to get back to the last video
### SmartHistory Compatibility
 - **SmartHistory is currently for Windows only**
	 - To create the log file, the method was inspired by a deleted author from a reddit post. Special thanks for his work.
### SmartHistory To-Do List
 - Support more platforms
 - Can't think of anything else, have an idea... let me know ;)
### SmartHistory Changelog
 - (1.0)
	- Initial release of SmartHistory Script
	- Contains simple history log file with many smart features mentioned above.
 - Latest Changes - **(1.1)**
 	- Tons of bug fixes and optimizations
	- Fixed issues that could cause script to crash
	- Added OSD everywhere possible
