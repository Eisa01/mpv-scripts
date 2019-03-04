# Introduction
This repository contain scripts I have made for [mpv media player](https://github.com/mpv-player/mpv/). To add scripts from this repository, download the desired script in your `mpv/scripts/` directory (click [here](https://mpv.io/manual/master/#lua-scripting) to know more about mpv scripts).

**This repository contain the following scripts:**
- [**SmartCopyPaste Script**](https://github.com/Eisa01/mpv-scripts#smartcopypaste-script)
- [**SmartCopyPaste-II Script**](https://github.com/Eisa01/mpv-scripts#smartcopypaste-ii-script)
- [**SmartHistory Script**](https://github.com/Eisa01/mpv-scripts#smarthistory-script)
- [**SimpleUndo Script**](https://github.com/Eisa01/mpv-scripts#simpleundo-script)
- [**UndoRedo Script**](https://github.com/Eisa01/mpv-scripts#undoredo-script)

**The following scripts can conflict with each other:**
- Either install SmartCopyPaste or SmartCopyPaste-II.
- Either install SimpleUndo or UndoRedo.
# SmartCopyPaste Script
SmartCopyPaste is a script for mpv media player, the script adds a very smart copy paste experience to mpv. It gives mpv the ability to load videos simply by pasting them into mpv. As for copying,  pressing [ctrl]+[c] on a video, copies the video path and its time to clipboard, which enables paste to resume or to access video with the copied time by pasting. For installation, download *`SmartCopyPaste.lua`* file into your `mpv/scripts/` directory. 
### SmartCopyPaste Features and Usage Guide
 - **Features**
	- **OSD** (On Screen Display): Displays any SmartCopyPaste action within mpv.
	- **youtube-dl Extension Support** Immediately paste links without finding exact video address for youtube and any other youtube-dl extension supported sites.
- **While running a video**
	 - **[ctrl]**+**[c]** to copy video path with resume time
	 - **[ctrl]**+**[v]** does the following:
		 -  To jump to the copied time (resume)
		 - Or when different video is copied, [ctrl]+[v] will add it into playlist
	 - **[ctrl]**+**[C]** to copy video path without resyne time
	 - **[ctrl]**+**[V]** to add video into playlist to play it next
 - **While `NOT` running a video**
	 - **[ctrl]**+**[v]** to play the copied video with reached time _if available_
### SmartCopyPaste Compatibility
 - Currently for Windows OS only.
# SmartCopyPaste-II Script
SmartCopyPaste is a script for mpv media player, the script adds a very smart copy paste experience to mpv. It gives mpv the ability to load videos simply by pasting them into mpv. As for copying,  pressing [ctrl]+[c] on a video, copies the video path and its time to clipboard, which enables paste to resume or to access video with the copied time by pasting. 
The **II** version contain additional features which saves your clipboard into a log file. The log adds the option to paste at any time even if clipboard was overwritten or cleared. 

Basically,  the **II**  version is enhanced with a bookmark feature, copying a video will bookmark the video and time, while pasting will access the bookmark (even if clipboard is cleared). For installation, download *`SmartCopyPaste-II.lua`* file into your `mpv/scripts/` directory. 
### SmartCopyPaste-II Features and Usage Guide
- **Features**
	- **Bookmark**: Any copy in a video is also a bookmark point, to access the bookmark simply paste.
	- **Save Clipboard to a Log File:** The copies from mpv, and the pastes into mpv will be kept in a log file located in `%APPDATA%\mpv\mpvClipboard.log`. This is necessary for the bookmark feature.
	- **OSD**: Displays any SmartCopyPaste action within mpv.
	- **youtube-dl Extension Support** Immediately paste links without finding exact video address for youtube and any other youtube-dl extension supported sites.
- **While running a video**
	 - **[ctrl]**+**[c]** to copy video path with resume time and bookmark it
	 - **[ctrl]**+**[v]** does the following:
		 - To jump to the copied time
		 - Or to jump to the bookmarked position in the bookmarked video (resume)
	- **Extra Feature:** Less important features:
		- **[ctrl]**+**[C]** to copy video path without resyme time and bookmark
		- **[ctrl]**+**[V]** to add video into playlist to play it next
 - **While `NOT` running a video**
	 - **[ctrl]**+**[v]** to play the copied video *and time if available* (whether link or local video or video path)
	 - **[ctrl]**+**[v]** when no video is currently copied, [ctrl]+[v] will find and play your last copied or pasted video
	 - **[ctrl]**+**[c]** to access your videos clipboard history
### SmartCopyPaste-II Compatibility
 - Currently for Windows OS only.
# SmartHistory Script
SmartHistory is a script for mpv media player, the script adds a smart history functionality to mpv. It logs videos that you opened into `%APPDATA%\mpv\mpvHistory.log` along with the time you have reached on each video. The script uses the log to provide you with various features. More details about SmartHistory are explained in the sections below. For installation, download *`SmartHistory.lua`* file into your `mpv/scripts/` directory. 
### SmartHistory Features and Usage Guide
- **Features**
	- **Auto Bookmark**: When you exit video, it will always remember position and [ctrl]+[r] will resume. 
	-  **Logs Opened Videos to a Log File:** All videos opened in mpv will be logged to create a history in `%APPDATA%\mpv\mpvHistory.log`. The format is: [date and time] of accessing video, the path & reached video time.
	- **OSD**: Displays any SmartHistory action within mpv. This is necessary for Auto Bookmark.
- **While running a video**
	- **[ctrl]**+**[l]** to immediately load last closed video 
	- **[ctrl]**+**[r]** to open history log for list of played videos
		- Use this along with smartcopypaste script to copy and paste video from history log into mpv
 - **While `NOT` running a video**
	- **[ctrl]**+**[r]** to resume in any previously closed videos
	- **[ctrl]**+**[l]** to add previously closed video into playlist  
		- Useful for cases when you opened another video by accident and you want to get back to the last video
### SmartHistory Compatibility
 - Currently for Windows OS only.
# SimpleUndo Script
SimpleUndo is a script for mpv media player, the script adds a simple undo functionality into mpv. If you accidentally seek/jump to a different time in the video, press undo [ctrl]+[z] to return to your previous time and vice-versa. For installation, download *`SimpleUndo.lua`* file into your `mpv/scripts/` directory. 
### SimpleUndo Features and Usage Guide
- **Features**
	- **OSD**: Displays any SimpleUndo action within mpv.
- **While mpv is active (running a video)**
	- **[ctrl]**+**[z]** to undo accidental seek by returning to previous time and vise-versa.
### SimpleUndo Compatibility
 - Should work on all of mpv supported platforms.
# UndoRedo Script
UndoRedo is a script for mpv media player, the script adds undo, and redo functionality into mpv. If you seek/jump to a different time in the video, press undo [ctrl]+[z] to linearly undo the seeks/jumps in the video, and press redo [ctrl]+[y] to linearly return to previous undo positions. For installation, download *`UndoRedo.lua`* file into your `mpv/scripts/` directory. 
### UndoRedo Features and Usage Guide
- **Features**
	- **OSD**: Displays any SimpleUndo action within mpv.
- **While mpv is active (running a video)**
	- **[ctrl]**+**[z]** to undo by returning to previous times. 
		- Example: from second 30 jumped to minute 5, then 10, then 15. Undo will return to 10, undo again to return to 5, undo again to return to second 30.
	- **[ctrl]**+**[y]** to redo by restoring undo times. 
		- Example: from second 30 jumped to minute 5, then 10. Undo twice for second 30. Redo will restore to 5, redo again to restore to 10.
	- **[ctrl]**+**[shift]**+**[z]** loop between last undo and redo.
		- for quick undo & redo (Just like **SimpleUndo** script) it loops between the last undo & redo.
### UndoRedo Compatibility
 - Should work on all of mpv supported platforms.
# Misc
### To-Do List
- Support more platforms for scripts that are currently Windows OS only
- I am open to suggestions! Have an idea... let me know.. ;)
### Changelog
- [Here](https://github.com/Eisa01/mpv-scripts/blob/master/.doc/changelog.md) you can find the full changelog for all the scripts in this repository.
### Special Thanks
Below is list of contributors/ honorable mentions.
- **SmartCopyPaste Script** 
To access windows clipboard, the method was inspired by [@wiiaboo](https://github.com/wiiaboo/) urlcopypaste script. Special thanks for his work.
- **SmartHistory Script**
To create the log file, the method was inspired by a deleted author from a reddit post. Special thanks for his work.
- **UndoRedo Script**
Credits and special thanks to [@Banz99](https://github.com/Banz99) for forking SimpleUndo script and enhance it by a table to store undo and redo values, as well as iterate between them. Also special thanks for his full explanation on how it works.
