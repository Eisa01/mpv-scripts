# Introduction
This repository contain scripts I have made for [mpv media player](https://github.com/mpv-player/mpv/).
To add scripts from this repository, download the desired script in your `mpv/scripts/` directory, for user customizable settings download the related conf file in your `mpv/script-opts/` directory.

**Scripts available in this repository:**
[SmartSkip](https://github.com/Eisa01/mpv-scripts#smartskip), [SmartCopyPaste](https://github.com/Eisa01/mpv-scripts#smartcopypaste), [SmartCopyPaste_II](https://github.com/Eisa01/mpv-scripts#smartcopypaste_ii), [SimpleHistory](https://github.com/Eisa01/mpv-scripts#simplehistory), [SimpleBookmark](https://github.com/Eisa01/mpv-scripts#simplebookmark), [SimpleUndo](https://github.com/Eisa01/mpv-scripts#simpleundo), [UndoRedo](https://github.com/Eisa01/mpv-scripts#undoredo)

# SmartSkip
You think Netflix is good at binge-watching? Yes, it is.. :) But give SmartSkip a try!
Automatically or manually skip opening, intro, outro, and preview, like never before. Jump to next file, previous file, and save your chapter changes!

![SmartSkip Demo](https://raw.githubusercontent.com/Eisa01/mpv-scripts/master/.misc/smartskip_demo1.webp)
<details>
<Summary>Click for more details!</Summary>

### Default Keybinds
Below default keybinds can be changed using the script conf file, or through script-opts by referring to the names that do not contain spaces.

| Keybind                        | Name                             | Description                                                       |
|-------------------------------------|----------------------------------|-------------------------------------------------------------------|
| `>`                             | smart-next                       | Skips using silence-skip > chapter-next > playlist-next, based on configurable variables     |
| `<`                             | smart-prev                       | Jumps to beginning > previous chapter > previous playlist, based on configurable variables   |
| `?`                             | silence-skip                     | Skips until a silence is detected based on configurable variables                                    |
| `ctrl+right`                     | chapter-next                     | Jumps to next chapter > to next playlist                            |
| `ctrl+left`                      | chapter-prev                     | Jumps to previous chapter > to beginning > to previous playlist     |
| `smart-next`, `enter`, `y`          | Proceed Auto-Skip             | Proceeds Auto-Skip when countdown is started             |
| `smart-prev`, `pause`, `esc`, `n`    | Cancel Auto-Skip             | Cancels Auto-Skip when countdown is started              |
| `ctrl+.`                        | toggle-autoskip                  | Enables or disables Auto-Skip during playback for the current mpv session                            |
| `alt+.`                         | toggle-category-autoskip         | Enables or disables a chapter for Auto-Skip during playback for the current mpv session              |
| ` `                            | toggle-autoload                   | Enables or disables autoload during playback for the current mpv session                             |
| `n`                            | add-chapter                       | Add a chapter for the reached position                                   |
| `alt+n`                         | remove-chapter                    | Removes the current chapter                                              |
| `ctrl+n`                        | write-chapters                    | jumps to the previous available filter based on configured filters       |
| `alt+s` / `alt+S`                  | edit-chapter                     | Renames the current chapter (requires [user-input-module](https://github.com/CogentRedTester/mpv-user-input) )     |
| ` `                              | bake-chapters                   | Merge the changes of chapters for the file inside mkv file                |

### Main Features
* **Smart Next / Prev:** Automatically triggers Skip to Silence, Chapter Next/ Prev, or Playlist Next/ Prev based on configurable parameters.
- **Skip to Silence:** If the file you are watching is not chaptered, skipping to silence will attempt to skip the intro and outro by finding the silence in the file (optionally: chapter automatically created).
- **Auto Skip**: If the file you are watching has organized chapters, any opening, ending sound can be automatically skipped after your **preferred countdown** time.
- **Chapters Modification:** Create, remove, edit chapters,  and then save changes into an external file or bake them into the mkv file.
- **Chapter Next / Prev:** Go to next chapter, if no chapters available go to next playlist, and vise-versa (like the good times with MPC-HC).
- **Autoload**: Basically, if you are not using mpv's autoload script, this is bundled along for convenience and for the possibility to add more features in the future.
- **Customization:** Tons of user customizable settings that can even change the behavior and priority of smart-next, smart-prev, auto-skip, and more!
- **OSD** (On Screen Display): Displays a proper OSD for the actions preformed through SmartSkip.
- **More:** This is not all! Explore the conf file to learn more about the possibilities you are missing out...
### Compatibility
- Works on all of mpv supported platforms.
</details>

# SmartCopyPaste
Gives mpv the capability to copy and paste while being smart and customizable... 

![SmartCopyPaste Demo](https://raw.githubusercontent.com/Eisa01/mpv-scripts/master/.misc/smartcopypaste_demo1.webp)
<details>
<Summary>Click for more details!</Summary>

### Default Keybinds
The following are the default keybinds, they can be changed in the conf file of the script or using script-opts by referring to the name.
| Keybind                        | Name                             | Description                                                       |
|--------------------------------|----------------------------------|-------------------------------------------------------------------|
| `ctrl+c` / `ctrl+C` / `meta+c` / `meta+C`                   | copy                   | copies file path / URI with resume time using the configured smart behavior.     |
| `ctrl+v` / `ctrl+V` / `meta+v` / `meta+V`                     | paste                | pastes and run into mpv from the clipboard using the configured smart behavior.        |
| `ctrl+alt+c` / `ctrl+alt+C` / `meta+alt+c` / `meta+alt+C`                        | copy-specific           | copies the file path without the reached time or based on the configured specific copy behavior.  |
| `ctrl+alt+v` / `ctrl+alt+V` / `meta+alt+v` / `meta+alt+V`                            | paste-specific                        | pastes and appends the video file into playlist or based on the configured specific paste behavior.                                                                             |
### Main Features
- **Copy and Paste:** Adds copy and paste to mpv for any file, like (urls, torrents, images, subtitles, audio files, video paths)
- **Multi-Paste:** Capability to paste a list of supported items seperated by new line to generate a playlist and conduct different actions depending on the files pasted.
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
The following are the default keybinds, they can be changed in the conf file of the script or using script-opts by referring to the name.
| Keybind                        | Name                             | Description                                                       |
|--------------------------------|----------------------------------|-------------------------------------------------------------------|
| `ctrl+c` / `ctrl+C` / `meta+c` / `meta+C`                   | copy                   | copies file path / URI with resume time using the configured smart behavior.     |
| `ctrl+v` / `ctrl+V` / `meta+v` / `meta+V`                     | paste                | pastes and run into mpv from the clipboard using the configured smart behavior.        |
| `ctrl+alt+c` / `ctrl+alt+C` / `meta+alt+c` / `meta+alt+C`                        | copy-specific           | copies the file path without the reached time or based on the configured specific copy behavior.  |
| `ctrl+alt+v` / `ctrl+alt+V` / `meta+alt+v` / `meta+alt+V`                            | paste-specific                        | pastes and appends the video file into playlist or based on the configured specific paste behavior.                                                                             |
| `c` / `C`                            | open-list                               | opens Clipboard list [(LogManager)](https://github.com/Eisa01/mpv-scripts#logmanager)                                               |
### Main Features
- **Copy and Paste:** Adds copy and paste to mpv for any file, like (urls, torrents, images, subtitles, audio files, video paths)
- **Multi-Paste:** Capability to paste a list of supported items seperated by new line to generate a playlist and conduct different actions depending on the files pasted.
- **youtube-dl Extension Support:** Immediately paste links without finding exact video address for youtube and any other youtube-dl extension supported sites.
- **Peerflix / WebTorrent Extension Support:** Immediately paste torrent links or magnet links when proper extensions are installed.
- **Saves Clipboard to a Log File:** The copies from mpv, and the pastes into mpv will be kept in a log file; log file location is mpv config directory, default for Windows OS: `%APPDATA%\mpv\mpvClipboard.log`, for Linux OS and MAC OS: `~\.config\mpv\mpvClipboard.log`.
- **[LogManager:](https://github.com/Eisa01/mpv-scripts#logmanager)** Reads the log file directly in mpv, giving access to navigate, play files, add to playlist, delete, search, and filter the content.
- **Customization:** Tons of user customizable settings that can even change the behavior and priority of copy and paste actions, as well as everything about LogManager.
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
The following are the default keybinds, they can be changed in the conf file of the script or using script-opts by referring to the name.
| Keybind                        | Name                             | Description                                                       |
|--------------------------------|----------------------------------|-------------------------------------------------------------------|
| `ctrl+r` / `ctrl+R`                   | history-resume                   | **File Loaded:** Resumes in any previously closed video. / **Idle:** Loads and resumes the last played videos.      |
| `alt+r` / `alt+R`                     | history-load-last                | **File Loaded:** Adds last closed video into playlist. / **Idle**: Loads last closed video without resuming.        |
| `ctrl+H`                         | history-incognito-mode           | Triggeres a customizable incognito mode that stops saving history. To resume saving history press `ctrl+H` again |
| `h` / `H`                            | open-list                        | opens History list [(LogManager)](https://github.com/Eisa01/mpv-scripts#logmanager)                                                                             |
| `r` / `R`                            | *NA*                               | opens History list - filtered with recent items [(LogManager)](https://github.com/Eisa01/mpv-scripts#logmanager)                                                |
### Main Features
- **Last Played:** Immediately jumps to your last played video so you continue watching
- **Video Resume:** It saves the position of all videos you are watching so you can easily resume
- **Saves History to a Log File:** The files and position of files played will be kept in a log file; log file location is mpv config directory, default for Windows OS: `%APPDATA%\mpv\mpvHistory.log`, for Linux OS and MAC OS: `~\.config\mpv\mpvHistory.log`.
- **Incognito Mode:** A highly customizable incognito mode that can also be set to auto_run with mpv. It stops history logging when triggered until it is disabled by triggering it again.
- **Blacklist/Whitelist:** A very smart blacklist option that can understand inputted text to blacklist certain websites, urls, files, file paths, and protocols from saving into history. It can also be inverted into a whitelist so only defined files / urls / websites are saved into history.
- **[LogManager:](https://github.com/Eisa01/mpv-scripts#logmanager)** Reads the log file directly in mpv, giving access to navigate, play files, add to playlist, delete, search, and filter the content. (I personally like the distinct filter). It lists the last episode played of each different show.
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
The following are the default keybinds, they can be changed in the conf file of the script or using script-opts by referring to the name.
| Keybind                        | Name                             | Description                                                       |
|--------------------------------|----------------------------------|-------------------------------------------------------------------|
| `ctrl+b` / `ctrl+B`                | bookmark-save                  | bookmarks file along with time reached.                                      |
| `alt+b` / `alt+B`                | bookmark-fileonly                  | bookmarks file only without the reached time.                                    |
| `b` / `B`       | open-list          | opens Bookmark list [(LogManager)](https://github.com/Eisa01/mpv-scripts#logmanager) |
| `k` / `K`       | *NA*          | opens Bookmark list - filtered with entries assigned to keybinds [(LogManager)](https://github.com/Eisa01/mpv-scripts#logmanager) |
| `alt+1`-`alt+9`                | *NA*                  | **List is open:** assigns entry to a keybind. / **List is closed:** loads the assigned entry.                                    |
| `alt+shift+1`-`alt+shift+9`                | *NA*                  | override a corresponding assigned keybind entry based on the pressed number.                                   |
| `alt+-`       | keybind-slot-remove          | when list is open it removes the assigned keybind from the bookmarked entry based on cursor position. |
| `alt+shift+-`       | keybind-slot-remove-highlight          | when list is open it removes all the highlighted assigned keybinds from the bookmarked entries. |
### Main Features
- **Bookmark:** Adds bookmark functionality to mpv, simply press the bookmark keybind and you are done.
- **Assign Bookmark to Keybind:** Press the keybind slot when displaying bookmarks will assign the bookmark to a keybind, making it easy to jump to the bookmark at anytime when pressing the same keybind.
- **[LogManager:](https://github.com/Eisa01/mpv-scripts#logmanager)** Reads the log file directly in mpv, giving access to navigate, play files, add to playlist, delete, search, and filter the content.
- **Saves Bookmark to a Log File:** The bookmarks will be kept in a log file; log file location is mpv config directory, default for Windows OS: `%APPDATA%\mpv\mpvBookmark.log`, for Linux OS and MAC OS: `~\.config\mpv\mpvBookmark.log`.
- **Customization:** Tons of user customizable settings that can even change the behavior of bookmarking, assigning video to a keybind, and the LogManager itself.
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
The following are the default keybinds, they can be changed in the script or using script-opts by referring to the name.
| Keybind                        | Name                             | Description                                                       |
|--------------------------------|----------------------------------|-------------------------------------------------------------------|
| `ctrl+z` / `ctrl+Z`                 | undo / undoCaps                  | undo accidental seek by returning to previous time and vise-versa.|
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
The following are the default keybinds, they can be changed in the script or using script-opts by referring to the name.
| Keybind                        | Name                             | Description                                                       |
|--------------------------------|----------------------------------|-------------------------------------------------------------------|
| `ctrl+z` / `ctrl+Z`                | undo / undoCaps                  | undo by returning to previous time.                                      |
| `ctrl+y` / `ctrl+Y`                | redo / redoCaps                  | redo by restoring the undo time.                                    |
| `ctrl+alt+z` / `ctrl+alt+Z`       | undoLoop / undoLoopCaps          | undo accidental seek by returning to previous time and vise-versa. |
### Main Features
- **Undo and Redo:** Undo any accident time jumps in the video by pressing the undo keybind and redo the jumps by pressing the redo keybind.
- **Simple Undo:** Undo accidental time jumps in videos by pressing Simple Undo keybind and press again to return to previous position.
- **OSD:** Displays any UndoRedo action within mpv.
### Compatibility
- Works on all of mpv supported platforms.
</details>

# LogManager
A highly customizable GUI to list and manage the logged items for SimpleHistory, SimpleBookmark, SmartCopyPaste_II; it is already integrated with the scripts.

Bookmarks (Keybinds Filter and Sort) | Clipboard (Highlighted 3 Items)| History (Search for Naruto in April 2022)
:----------------------------:|:----------------------------:|:----------------------------:
![LogManager Demo1](https://github.com/Eisa01/mpv-scripts/raw/master/.misc/logManager_demo1.png)|![LogManager Demo2](https://github.com/Eisa01/mpv-scripts/raw/master/.misc/logManager_demo2.png)|![LogManager Demo3](https://github.com/Eisa01/mpv-scripts/raw/master/.misc/logManager_demo3.png)
<details>
<Summary>Click for more details!</Summary>

### Default Keybinds
The following are the default keybinds, they can be changed in the conf file of the scripts or using script-opts by referring to the name.
| Keybind                        | Name                             | Description                                                       |
|--------------------------------|----------------------------------|-------------------------------------------------------------------|
| `UP` / `WHEEL_UP`                  | move-up                          | navigates up on the log list                                      |
| `DOWN` / `WHEEL_DOWN`              | move-down                        | navigates down on the log list                                    |
| `PGUP`                           | page-up                          | navigates to the first item of current shown page on the log list |
| `PGDWN`                          | page-down                        | navigates to the last item of current shown page on the log list  |
| `HOME`                           | move-first                       | navigates to the first item on the log list                       |
| `END`                            | move-last                        | navigates to the last item on the log list                        |
| `SHIFT`                          | *NA*                               | highlights the items on the list to manage and take action on multiple items. Keep holding `SHIFT`, then press any navigation keybind, e.g.: `SHIFT+UP`/`SHIFT+PGDWN` to highlight the items navigated towards    |
| `ctrl+a` / `ctrl+A`                | list-highlight-all               | highlights all the displayed items on the log list                |
| `ctrl+d` / `ctrl+D`                | list-unhighlight-all             | cancels the highlight of all highlighted items shown on the log list   |
| `RIGHT` / `MBTN_FORWARD`           | list-filter-next                 | jumps to the next available filter based on configured filters          |
| `LEFT` / `MBTN_BACK`               | list-filter-previous             | jumps to the previous available filter based on configured filters      |
| `alt+s` / `alt+S`                  | list-cycle-sort                  | cycles through the different available sorts on the log list      |
| `ENTER` / `MBTN_MID`               | list-select                      | loads an entry based on cursor position                                    |
| `ctrl+ENTER`                     | list-add-playlist                | add entry to playlist based on cursor position                             |
| `SHIFT+ENTER`                    | list-add-playlist-highlight      | adds all highlighted entries to playlist                                   |
| `0`-`9`                            | *NA*                               | quick-select an entry from 0th to 9th position                                   |
| `DEL`                            | list-delete                      | deletes an entry from the log file based on cursor position                |
| `SHIFT+DEL`                      | list-delete-highlight            | deletes all highlighted entries from the log file                          |
| `ctrl+f` / `ctrl+F`                | list-search-activate             | triggers search to quickly find an item on the log list                    |
| `ALT+ENTER`                      | search_string_not_typing         | forcefully exit typing mode of search while keeping search open            |
| *Depends on the script*            | ignore                           | Keybinds that will be ignored when the log list is open (mainly to avoid opening another log list from a different script while current one is active)   |
| `ESC` / `MBTN_RIGHT`               | *NA*                               | close the log list (closes search first if it is open)                                                                                                   |
### Main Features
- **Log Manage:** List the log entries and manage them using mpv
- **Log Search:** Search for any specific entries in the list using a simplified search engine
- **Log Filter:** Apply a filter to the list depending on various built-in filters or build your own keywords filter
- **Log Multi-Select:** Multi-select the items to load / manage multiple entries easily
- **Customization:** LogManager is highly customizable in terms of anything that has to do with it, such as, keybinds, GUI with tons of built-in variables, the list of entries, and more.
- **OSD:** Displays any LogManager action within mpv.
### Compatibility
- Intergrated with SmartCopyPaste-II, SimpleHistory, SimpleBookmark
</details>

# Misc
### MPV.net Support
[MPV.net](https://github.com/stax76/mpv.net) users must change the option `input-default-bindings = no` to `input-default-bindings = yes` located in `MPV.net/mpv.conf` 

### Special Thanks
Below is list of contributors/ honorable mentions. Without the below contributions these scripts would not exist today.
- **SmartCopyPaste Script:** For the handlers that are used inside the script, which added compatibility for newer mpv versions, the method was originally forked and edited from [@jonniek](https://github.com/jonniek) appendURL script. Special thanks for his work.
- **LogManager**: [@jonniek](https://github.com/jonniek) mpv-playlistmanager script and [@hacel](https://github.com/hacel) recents script, both scripts were forked and modified to help me in developing the LogManager which is used inside the script. Specials thanks for their work.
- **UndoRedo Script:** Credits and special thanks to my friend [@Banz99](https://github.com/Banz99) for forking SimpleUndo script and enhance it by a table to store undo and redo values.
- **SmartSkip Script:** [skiptosilence.lua](https://github.com/detuur/mpv-scripts) by [@detuur](https://github.com/detuur/), [chapters.lua](https://github.com/mar04/chapters_for_mpv) by @[mar04](https://github.com/mar04), [chapterskip.lua](https://github.com/po5/chapterskip) by [@po5](https://github.com/po5/), and [autoload.lua](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua) by [@mpv](https://github.com/mpv-player/mpv/) team. The following scripts were forked and modified in order to develop SmartSkip. Specials thanks for their work.
