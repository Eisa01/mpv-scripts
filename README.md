# Introduction
This repository contain scripts I have made for [mpv media player](https://github.com/mpv-player/mpv/). To add scripts from this repository, download the desired script in your `mpv/scripts/` directory (click [here](https://mpv.io/manual/master/#lua-scripting) to know more about mpv scripts).

**This repository contain the following scripts:**
- [**SmartCopyPaste Script 2.2**](https://github.com/Eisa01/mpv-scripts#smartcopypaste-script-22)
- [**SmartCopyPaste-II Script 2.2**](https://github.com/Eisa01/mpv-scripts#smartcopypaste-ii-script-22)
- [**SmartHistory Script 1.5.2**](https://github.com/Eisa01/mpv-scripts#smarthistory-script-152)
- [**SimpleUndo Script 2.5.1**](https://github.com/Eisa01/mpv-scripts#simpleundo-script-251)
- [**UndoRedo Script 1.5.1**](https://github.com/Eisa01/mpv-scripts#undoredo-script-151)

**The following scripts can conflict with each other:**
- Either install SmartCopyPaste or SmartCopyPaste-II.
- Either install SimpleUndo or UndoRedo.
# SmartCopyPaste Script 2.2
SmartCopyPaste is a script for mpv media player, the script adds a very smart copy paste experience to mpv. It gives mpv the ability to load videos simply by pasting them into mpv. As for copying,  pressing <kbd>ctrl</kbd>+<kbd>c</kbd> on a video, copies the video path and its time to clipboard, which enables paste to resume or to access video with the copied time by pasting. For installation, download *`SmartCopyPaste-2.2.lua`* file into your `mpv/scripts/` directory. 
### SmartCopyPaste Main Features
- **Copy and Paste:** Adds ability to copy and paste any type of video to mpv, like (urls, video paths, or local videos)
- **youtube-dl Extension Support:** Immediately paste links without finding exact video address for youtube and any other youtube-dl extension supported sites.
- **Peerflix Extension Support:** Immediately paste torrent links or magnet links when proper peerflix extensions are installed. 
- **Customization:** In the script there are user customizable settings, such as the option to change the copy and paste command for each platform, option to add or remove file extensions and protocols that you want copying and pasting to accept, option of setting device OS manually if automatic detection fails, option to change and add more keyboard shortcuts (keybinds), and more...
- **OSD** (On Screen Display): Displays any SmartCopyPaste action within mpv.
### SmartCopyPaste Usage Guide
**While running a video:**
- <kbd>ctrl</kbd>+<kbd>c</kbd> to copy video path with resume time
- *<kbd>ctrl</kbd>+<kbd>v</kbd> does the following:*
	- To jump to the copied time
	- Or when different video is copied, <kbd>ctrl</kbd>+<kbd>v</kbd> will add it into playlist
- <kbd>ctrl</kbd>+<kbd>alt</kbd>+<kbd>c</kbd> to copy video path without resume time
- <kbd>ctrl</kbd>+<kbd>alt</kbd>+<kbd>v</kbd> to add video into playlist to play it next

**While `NOT` running a video:**
- <kbd>ctrl</kbd>+<kbd>v</kbd> to play the copied video with resume time _if available_

**Sidenote:**
- MAC OS will automatically use <kbd>command</kbd> instead of <kbd>ctrl</kbd> key
### SmartCopyPaste Compatibility
- Windows OS (default powershell, customizable / can be changed in the settings inside the script).
- MAC OS (default pbcopy and pbpaste, customizable / can be changed in the settings inside the script).
- Linux OS (default xclip, customizable / can be changed in the settings inside the script).
# SmartCopyPaste-II Script 2.2
SmartCopyPaste is a script for mpv media player, the script adds a very smart copy paste experience to mpv. It gives mpv the ability to load videos simply by pasting them into mpv. As for copying,  pressing <kbd>ctrl</kbd>+<kbd>c</kbd> on a video, copies the video path and its time to clipboard, which enables paste to resume or to access video with the copied time by pasting. 
The **II** version contain additional features which saves your clipboard into a log file. The log adds the option to paste at any time even if clipboard was overwritten or cleared. 

Basically,  the **II**  version is enhanced with a bookmark feature, copying a video will bookmark the video and time, while pasting will access the bookmark (even if clipboard is cleared). For installation, download *`SmartCopyPaste-II-2.2.lua`* file into your `mpv/scripts/` directory. 
### SmartCopyPaste-II Main Features
- **Copy and Paste:** Adds ability to copy and paste any type of video to mpv, like (urls, video paths, or local videos)
- **Bookmark:** Any copy in a video is also a bookmark point, to access the bookmark simply paste.
- **Saves Clipboard to a Log File:** The copies from mpv, and the pastes into mpv will be kept in a log file; log file location for Windows OS: `%APPDATA%\mpv\mpvClipboard.log`, for Linux OS and MAC OS: `~\.config\mpv\mpvClipboard.log`. This is necessary for the bookmark feature.
- **youtube-dl Extension Support:** Immediately paste links without finding exact video address for youtube and any other youtube-dl extension supported sites.
- **Peerflix Extension Support:** Immediately paste torrent links or magnet links when proper peerflix extensions are installed. 
- **Customization:** In the script there are user customizable settings, such as the option to change the copy and paste command for each platform, option to add or remove file extensions and protocols that you want copying and pasting to accept, option of setting device OS manually if automatic detection fails, option to change and add more keyboard shortcuts (keybinds), and more...
- **OSD:** Displays any SmartCopyPaste action within mpv.
### SmartCopyPaste-II Usage Guide
**While running a video:**
- <kbd>ctrl</kbd>+<kbd>c</kbd> to copy video path with resume time and bookmark it
- *<kbd>ctrl</kbd>+<kbd>v</kbd> does the following:*
	- To jump to the copied time
	- Or to jump to the bookmarked position in the bookmarked video (resume)
- <kbd>ctrl</kbd>+<kbd>alt</kbd>+<kbd>c</kbd> to copy video path without resume time and bookmark
- <kbd>ctrl</kbd>+<kbd>alt</kbd>+<kbd>v</kbd> to add video into playlist to play it next
	
**While `NOT` running a video:**
- *<kbd>ctrl</kbd>+<kbd>v</kbd> does the following:*
	- To play the copied video with resume time _if available_
	- Or when no video is currently copied, <kbd>ctrl</kbd>+<kbd>v</kbd> will find and play your last copied or pasted video
	
**Sidenote:**
- MAC OS will automatically use <kbd>command</kbd> instead of <kbd>ctrl</kbd> key
### SmartCopyPaste-II Compatibility
- Windows OS (default powershell, customizable / can be changed in the settings inside the script).
- MAC OS (default pbcopy and pbpaste, customizable / can be changed in the settings inside the script).
- Linux OS (default xclip, customizable / can be changed in the settings inside the script).
# SmartHistory Script 1.5.2
SmartHistory is a script for mpv media player, the script adds a smart history functionality to mpv. It logs videos that you opened into a log file along with the time you have reached on each video; log file location for Windows OS: `%APPDATA%\mpv\mpvHistory.log`, for Linux OS and MAC OS: `~\.config\mpv\mpvHistory.log`. The script uses the log to provide you with various features. More details about SmartHistory are explained in the sections below. For installation, download *`SmartHistory-1.5.2.lua`* file into your `mpv/scripts/` directory. 
### SmartHistory Main Features
- **Remember Last Video:** It will always remember your last played video, and <kbd>ctrl</kbd>+<kbd>l</kbd> will jump to your last played video.
- **Auto Bookmark:** When you exit video, it will always remember position and <kbd>ctrl</kbd>+<kbd>r</kbd> will resume. 
- **Logs Opened Videos to a Log File:** All videos opened in mpv will be logged to create a history file; log file location for Windows OS: `%APPDATA%\mpv\mpvHistory.log`, for Linux OS and MAC OS: `~\.config\mpv\mpvHistory.log`. The format is: [date and time] of accessing video, the path, then | reached video time. This is necessary for Remember Last Video and Auto Bookmark features.
- **OSD:** Displays any SmartHistory action within mpv.
### SmartHistory Usage Guide
**While running a video:**
- <kbd>ctrl</kbd>+<kbd>r</kbd> to resume in any previously closed videos
- <kbd>ctrl</kbd>+<kbd>l</kbd> to add previously closed video into playlist  
	- Useful for cases when you opened another video by accident and you want to get back to the last video

**While `NOT` running a video:**
- <kbd>ctrl</kbd>+<kbd>l</kbd> to immediately load last closed video 
### SmartHistory Compatibility
- Works on all of mpv supported platforms.
# SimpleUndo Script 2.5.1
SimpleUndo is a script for mpv media player, the script adds a simple undo functionality into mpv. If you accidentally seek/jump to a different time in the video, press undo <kbd>ctrl</kbd>+<kbd>z</kbd> to return to your previous time and vice-versa. For installation, download *`SimpleUndo-2.5.1.lua`* file into your `mpv/scripts/` directory. 
### SimpleUndo Main Features
- **Simple Undo:** Undo accidental time jumps in videos by pressing <kbd>ctrl</kbd>+<kbd>z</kbd> and press again to return to previous position.
- **OSD:** Displays any SimpleUndo action within mpv.
### SimpleUndo Usage Guide
- <kbd>ctrl</kbd>+<kbd>z</kbd> to undo accidental seek by returning to previous time and vise-versa.
### SimpleUndo Compatibility
- Works on all of mpv supported platforms.
# UndoRedo Script 1.5.1
UndoRedo is a script for mpv media player, the script adds undo, and redo functionality into mpv. If you seek/jump to a different time in the video, press undo <kbd>ctrl</kbd>+<kbd>z</kbd> to linearly undo the seeks/jumps in the video, and press redo <kbd>ctrl</kbd>+<kbd>y</kbd> to linearly return to previous undo positions. For installation, download *`UndoRedo-1.5.1.lua`* file into your `mpv/scripts/` directory. 
### UndoRedo Main Features
- **Undo and Redo:** Undo any accident time jumps in the video by pressing <kbd>ctrl</kbd>+<kbd>z</kbd> and redo the jumps by <kbd>ctrl</kbd>+<kbd>y</kbd>.
- **Simple Undo:** Undo accidental time jumps in videos by pressing <kbd>ctrl</kbd>+<kbd>alt</kbd>+<kbd>z</kbd> and press again to return to previous position.
- **OSD:** Displays any SimpleUndo action within mpv.
### UndoRedo Usage Guide
- <kbd>ctrl</kbd>+<kbd>z</kbd> to undo by returning to previous times. 
	- Example: from second 30 jumped to minute 5, then 10, then 15. Undo will return to 10, undo again to return to 5, undo again to return to second 30.
- <kbd>ctrl</kbd>+<kbd>y</kbd> to redo by restoring undo times. 
	- Example: from second 30 jumped to minute 5, then 10. Undo twice for second 30. Redo will restore to 5, redo again to restore to 10.
- <kbd>ctrl</kbd>+<kbd>alt</kbd>+<kbd>z</kbd> loop between last undo and redo.
	- This is for quick undo & redo (Just like **SimpleUndo**) it loops between the last undo & redo.
### UndoRedo Compatibility
- Works on all of mpv supported platforms.
# Misc
### To-Do List
- I am open to suggestions! Have an idea... let me know.. ;)
### Changelog
- [Here](https://github.com/Eisa01/mpv-scripts/blob/master/.doc/changelog.md) you can find the full changelog for all the scripts in this repository.
### Special Thanks
Below is list of contributors/ honorable mentions.
- **SmartCopyPaste Script:** For the handlers that are used inside the script, which added compatibility for newer mpv versions, the method was originally forked and edited from [@jonniek](https://github.com/jonniek) appendURL script. Specical thanks for his work. 
- **UndoRedo Script:** Credits and special thanks to [@Banz99](https://github.com/Banz99) for forking SimpleUndo script and enhance it by a table to store undo and redo values.
