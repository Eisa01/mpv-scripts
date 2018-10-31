
# Introduction
This repository contain scripts I have made for [mpv media player](https://github.com/mpv-player/mpv/). To add scripts from this repository, download the desired script in your `mpv/scripts/` directory (click [here](https://mpv.io/manual/master/#lua-scripting) to know more about mpv scripts).

**Table of Contents**
 - [SmartCopyPaste Script](https://github.com/Eisa01/mpv-scripts#smartcopypaste-script)
 	 - [SmartCopyPaste Usage Guide](https://github.com/Eisa01/mpv-scripts#smartcopypaste-usage-guide)
	 - [SmartCopyPaste (Basic AND Pro) Features](https://github.com/Eisa01/mpv-scripts#smartcopypaste-basic-and-pro-features)
	 - [SmartCopyPaste (Pro ONLY) Features](https://github.com/Eisa01/mpv-scripts#smartcopypaste-pro-only-features)
	 - [SmartCopyPaste Compatibility](https://github.com/Eisa01/mpv-scripts#smartcopypaste-compatibility)
	 - [SmartCopyPaste To-Do List](https://github.com/Eisa01/mpv-scripts#smartcopypaste-to-do-list)
	 - [SmartCopyPaste-Basic Changelog](https://github.com/Eisa01/mpv-scripts#smartcopypaste-basic-changelog)
	 - [SmartCopyPaste-Pro Changelog](https://github.com/Eisa01/mpv-scripts#smartcopypaste-pro-changelog)
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

[**Additional reading and detailed explanation on  features**](https://github.com/Eisa01/mpv-scripts/blob/master/documents/SmartCopyPaste-Feature-Details.md#smartcopypaste-detailed-explanation-of-features)
### SmartCopyPaste Compatibility
 - **SmartCopyPaste is currently for Windows only**
	 - To access windows clipboard, the method was inspired by [@wiiaboo](https://github.com/wiiaboo/) urlcopypaste script. Special thanks for his work.
### SmartCopyPaste To-Do List
 - Support more platforms
	 - Linux
 - ~~Enhance the bookmark feature of copy video and time by **[ctrl]**+**[c]**~~  (Done in **Pro** SmartCopyPaste)
	 - ~~Keep bookmark point even if it is no longer in the clipboard which gives the ability to paste even if the clipboard is overwritten~~ (**Done** in **Pro** SmartCopyPaste)
	 - ~~Make the bookmark point remain for multiple videos and give ability to resume to any saved bookmark point by **[ctrl]**+**[v]**~~ (**Done** in **Pro** SmartCopyPaste)
- ~~Add a shortcut to quickly access clipboard history for the pro version~~ (**Done** in **Pro 1.2** SmartCopyPaste)
-  ~~While watching a video, add pasted video to playlist so pasted video plays after finishing current video instead of ignoring paste~~ (**Done** in SmartCopyPaste **1.3**)
### SmartCopyPaste-Basic Changelog
 - 1.0 - **(Basic)**
	- Initial release
- 1.1 - **(Basic)**
	- Fixed a bug that caused any thing pasted to be added automatically to playlist
	- Some other fixes and optimizations
- 1.2 - **(Basic)**
	- Added support for youtube-dl extension (by removing checking links if they contain video file format) so pasting youtube links should work immediately if you have youtube-dl extension. Works for all other websites that youtube-dl extension supports.
	- Fixed issue that caused SmartCopyPaste to stop working if you copied in mpv while mpv was idle
	- Some other fixes and optimizations
- 1.3 - **(Basic)**
	- Added Auto Add Video to Playlist when pasting a different video by  **[ctrl]**+**[v]**
	- Added Add to Playlist by **[ctrl]**+**[V]**
	- Added OSD within mpv for all SmartCopyPaste actions
	- Some other fixes and optimizations
### SmartCopyPaste-Pro Changelog
- 1.0 - **(Pro)**
	- Initial release of an all new pro version containing tons of newly added features! [(check pro features section)](https://github.com/Eisa01/mpv-scripts#SmartCopyPaste-Pro-ONLY-Features)
- 1.1 - **(Pro)**
	- Same fixes and optimizations as the basic version
- 1.2 - **(Pro)**
	- Added support for youtube-dl extension (by removing checking links if they contain video file format) so pasting youtube links should work immediately if you have youtube-dl extension. Works for all other websites that youtube-dl extension supports.
	- Copying while mpv is idle now opens your clipboard history so you can copy any previous videos watched and paste to play them
	- Same fixes and optimizations as the basic version
- 1.3 - **(Pro)**
	- Fixed rare bug that caused SmartCopyPaste script to stop working
	- Added Add to Playlist by **[ctrl]**+**[V]**
	- Added OSD within mpv for all SmartCopyPaste actions
	- Some other fixes and optimizations
