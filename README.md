# Introduction
This repository contain scripts I have made for [mpv media player](https://github.com/mpv-player/mpv/).
To add scripts from this repository, download the desired script in your `mpv/scripts/` directory, for user customizable settings download the related conf file in your `mpv/script-opts/` directory.

**Scripts available in this repository:**
 [SmartCopyPaste Script 3.1](https://github.com/Eisa01/mpv-scripts#smartcopypaste), [SmartCopyPaste_II Script 3.1](https://github.com/Eisa01/mpv-scripts#smartcopypaste_ii), [SimpleHistory Script 1.1](https://github.com/Eisa01/mpv-scripts#simplehistory), [SimpleBookmark Script 1.1](https://github.com/Eisa01/mpv-scripts#simplebookmark), [SimpleUndo Script 3.2](https://github.com/Eisa01/mpv-scripts#simpleundo), [UndoRedo Script 2.2](https://github.com/Eisa01/mpv-scripts#undoredo)

# SmartCopyPaste
Gives mpv the capability to copy and paste while being smart and customizable... 

![SmartCopyPaste Demo](https://raw.githubusercontent.com/Eisa01/mpv-scripts/master/.misc/smartcopypaste_demo1.webp)
<details>
<Summary>Click for more details!</Summary>

### Default Keybinds
- <kbd>Ctrl</kbd>+<kbd>c</kbd> copies file path with resume time
- <kbd>Ctrl</kbd>+<kbd>v</kbd> pastes and run file into mpv
- <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>c</kbd> copies the file path without time
- <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>v</kbd> appends the video file into playlist
- MAC OS will also use <kbd>Command</kbd> key for copy and paste
### Main Features
- **Copy and Paste:** Adds copy and paste to mpv for any file, like (urls, torrents, images, subtitles, audio files, video paths)
- **youtube-dl Extension Support:** Immediately paste links without finding exact video address for youtube and any other youtube-dl extension supported sites.
- **Peerflix / WebTorrent Extension Support:** Immediately paste torrent links or magnet links when proper extensions are installed.
- **Customization:** Tons of user customizable settings that can even change the behavior and priority of copy and paste actions.
- **OSD** (On Screen Display): Displays any SmartCopyPaste action within mpv.
- **More:** This is not all! Explore the conf file to learn more about the possibilities you are missing out...
### Compatibility
- Windows OS (default powershell, customizable / can be changed in the settings inside the script).
- MAC OS (default pbcopy and pbpaste, customizable / can be changed in the settings inside the script).
- Linux OS (default xclip, customizable / can be changed in the settings inside the script).
</details>

# SmartCopyPaste_II
Just like SmartCopyPaste but logs your clipboard and makes use of it...

![SmartCopyPaste_II Demo](https://raw.githubusercontent.com/Eisa01/mpv-scripts/master/.misc/smartcopypaste_ii_demo1.webp)
<details>
<Summary>Click for more details!</Summary>

### Default Keybinds
- <kbd>Ctrl</kbd>+<kbd>c</kbd> copies file path with resume time
- <kbd>Ctrl</kbd>+<kbd>v</kbd> pastes and run file into mpv
- <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>c</kbd> copies the file path without time
- <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>v</kbd> appends the video file into playlist
- MAC OS will also use <kbd>Command</kbd> key for copy and paste
- <kbd>c</kbd> opens Clipboard list (Log Manager)
### Main Features
- **Copy and Paste:** Adds copy and paste to mpv for any file, like (urls, torrents, images, subtitles, audio files, video paths)
- **youtube-dl Extension Support:** Immediately paste links without finding exact video address for youtube and any other youtube-dl extension supported sites.
- **Peerflix / WebTorrent Extension Support:** Immediately paste torrent links or magnet links when proper extensions are installed.
- **Saves Clipboard to a Log File:** The copies from mpv, and the pastes into mpv will be kept in a log file; log file location is mpv config directory, default for Windows OS: `%APPDATA%\mpv\mpvClipboard.log`, for Linux OS and MAC OS: `~\.config\mpv\mpvClipboard.log`.
- **Log Manager:** Reads the log file directly in mpv, giving access to navigate, play files, add to playlist, delete, search, and filter the content.
- **Customization:** Tons of user customizable settings that can even change the behavior and priority of copy and paste actions, as well as everything about Log Manager.
- **OSD:** Displays any SmartCopyPaste_II action within mpv.
- **More:** This is not all! Explore the conf file to learn more about the possibilities you are missing out...
### Compatibility
- Windows OS (default powershell, customizable / can be changed in the settings inside the script).
- MAC OS (default pbcopy and pbpaste, customizable / can be changed in the settings inside the script).
- Linux OS (default xclip, customizable / can be changed in the settings inside the script).
</details>

# SimpleHistory
Stores whatever you open in a history file and abuses it with features! Continue watching your last played or resume previously played videos, manage and play from your history, and more...

![SimpleHistory Demo](https://raw.githubusercontent.com/Eisa01/mpv-scripts/master/.misc/simplehistory_demo1.webp)
<details>
<Summary>Click for more details!</Summary>

### Default Keybinds
- <kbd>Ctrl</kbd>+<kbd>r</kbd> resume in any previously closed videos / idle: loads and resumes last played video
- <kbd>Alt</kbd>+<kbd>r</kbd> add last closed video into playlist / idle: loads last closed video without resuming
- <kbd>h</kbd> opens History list (Log Manager)
- <kbd>r</kbd> opens History list - filtered with recent items (Log Manager)
### Main Features
- **Last Played:** Immediately jumps to your last played video so you continue watching
- **Video Resume:** It saves the position of all videos you are watching so you can easily resume
- **Saves History to a Log File:** The files and position of files played will be kept in a log file; log file location is mpv config directory, default for Windows OS: `%APPDATA%\mpv\mpvHistory.log`, for Linux OS and MAC OS: `~\.config\mpv\mpvHistory.log`.
- **Log Manager:** Reads the log file directly in mpv, giving access to navigate, play files, add to playlist, delete, search, and filter the content (I personally like the distinct filter). It lists the last episode played of each different show.
- **Customization:** Tons of user customizable settings, you can change almost everything. Hate the resume notification? Then just disable it. Hate recents list automatically loading? Then just disable it, and so on so forth...
- **OSD:** Displays any SimpleHistory action within mpv.
- **More:** This is not all! Explore the conf file to learn more about the possibilities you are missing out...
### Compatibility
- Works on all of mpv supported platforms.
</details>

# SimpleBookmark
Bookmark with a key, then list and access your bookmarks with a key. Assign your favorites to a keybind then access your favorites with that same keybind. Simple as that...

![SimpleBookmark Demo](https://raw.githubusercontent.com/Eisa01/mpv-scripts/master/.misc/simplebookmark_demo1.webp)
<details>
<Summary>Click for more details!</Summary>

### Default Keybinds
- <kbd>Ctrl</kbd>+<kbd>b</kbd> bookmarks file along with time reached
- <kbd>Alt</kbd>+<kbd>b</kbd> bookmarks file only
- <kbd>b</kbd> opens Bookmark list (Log Manager)
- <kbd>k</kbd> opens Bookmark list - filtered with files assigned to keybinds (Log Manager)
- <kbd>Alt + 1</kbd> - <kbd>Alt + 9</kbd> assigns file to keybind when list is open / loads the  assigned when list is closed
- <kbd>Alt</kbd>+<kbd>-</kbd> when list is open it removes the assigned keybind from the bookmark
### Main Features
- **Bookmark:** Adds bookmark functionality to mpv, simply press the bookmark keybind and you are done.
- **Assign Bookmark to Keybind:** Press the keybind slot when displaying bookmarks will assign the bookmark to a keybind, making it easy to jump to the bookmark at anytime when pressing the same keybind.
- **Log Manager:** Reads the bookmark log file, giving mpv easy access to all of your bookmarks with the functionality to navigate, play files, add to playlist, delete, search, and filter the content.
- **Saves Bookmark to a Log File:** The bookmarks will be kept in a log file; log file location is mpv config directory, default for Windows OS: `%APPDATA%\mpv\mpvBookmark.log`, for Linux OS and MAC OS: `~\.config\mpv\mpvBookmark.log`.
- **Customization:** Tons of user customizable settings that can even change the behavior of bookmarking, assigning video to a keybind, and the Log Manager itself.
- **OSD:** Displays any SimpleBookmark action within mpv.
- **More:** This is not all! Seriously I am too lazy to write down all the features neatly ;) Explore the conf file to learn more about the possibilities you are missing out...
### Compatibility
- Works on all of mpv supported platforms.
</details>

# SimpleUndo
Accidentally seeked? No worries, simply undo..

![SimpleUndo Demo](https://raw.githubusercontent.com/Eisa01/mpv-scripts/master/.misc/simpleundo_demo1.webp)
<details>
<Summary>Click for more details!</Summary>

### Default Keybinds
- <kbd>Ctrl</kbd>+<kbd>z</kbd> to undo accidental seek by returning to previous time and vise-versa.
### Main Features
- **Simple Undo:** Undo accidental time jumps in videos by pressing undo keybind and press again to return to previous position.
- **OSD:** Displays any SimpleUndo action within mpv.
### Compatibility
- Works on all of mpv supported platforms.
</details>

# UndoRedo
Undo is not enough to fix your accidental seek? Well now you can redo as well..

![UndoRedo Demo](https://raw.githubusercontent.com/Eisa01/mpv-scripts/master/.misc/undoredo_demo1.webp)
<details>
<Summary>Click for more details!</Summary>

### Default Keybinds
- <kbd>Ctrl</kbd>+<kbd>z</kbd> to undo by returning to previous time.
- <kbd>Ctrl</kbd>+<kbd>y</kbd> to redo by restoring the undo time.
- <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>z</kbd> undo accidental seek by returning to previous time and vise-versa.
### Main Features
- **Undo and Redo:** Undo any accident time jumps in the video by pressing the undo keybind and redo the jumps by pressing the redo keybind.
- **Simple Undo:** Undo accidental time jumps in videos by pressing Simple Undo keybind and press again to return to previous position.
- **OSD:** Displays any UndoRedo action within mpv.
### Compatibility
- Works on all of mpv supported platforms.
</details>

# Misc
### Visitors
![:Vistors](https://count.getloli.com/get/@236d2c6a-efc0-447d-9008-8ecc754f8606?theme=gelbooru)

Counting since `2021-09-25T19:04:24Z` (ISO 8601)
### MPV.net Support
[MPV.net](https://github.com/stax76/mpv.net) users must change the option `input-default-bindings = no` to `input-default-bindings = yes` located in `MPV.net/mpv.conf` 
### Special Thanks
Below is list of contributors/ honorable mentions.
- **SmartCopyPaste Script:** For the handlers that are used inside the script, which added compatibility for newer mpv versions, the method was originally forked and edited from [@jonniek](https://github.com/jonniek) appendURL script. Specical thanks for his work.
- **LogManager**: [@jonniek](https://github.com/jonniek) mpv-playlistmanager script and [@hacel](https://github.com/hacel) recents script, both scripts were forked and modified to help me in developing the LogManager which is used inside the script. Specials thanks for their work.
- **UndoRedo Script:** Credits and special thanks to [@Banz99](https://github.com/Banz99) for forking SimpleUndo script and enhance it by a table to store undo and redo values.
