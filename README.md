# Introduction
This repository contain scripts I have made for [mpv media player](https://github.com/mpv-player/mpv/). To add scripts from this repository, download the desired script in your `mpv/scripts/` directory (click [here](https://mpv.io/manual/master/#lua-scripting) to know more about mpv scripts).
# SmartCopyPaste.lua
SmartCopyPaste is a script for mpv media player, the script adds a very smart copy paste experience to mpv. It gives mpv the ability to load videos simply by pasting them directly into mpv. It also gives you the option to quickly resume video by pasting or opening a copied video. "copying the video you are currently playing creates a bookmark point in clipboard that detects the video and its time, which gives the option to resume watching upon pasting or opening the same video". SmartCopyPaste works whether the video is a URL or it is a video you have locally.  More details about SmartCopyPaste are explained in the sections below. To use it, simply download the *`smartcopypaste.lua`* file into your `mpv/scripts/` directory. 
### SmartCopyPaste Features
 - **URL Paste Feature: Copy any video URL from anywhere and play it by pressing **[ctrl]+[v]** directly into mpv media player**
	- *Before accepting paste:*
		- It checks if the pasted URL contains a supported video extension such as **mp4**
		- It avoids accidental video change, **it only accepts pasting new video if there is no video already playing**
	- *Feature demonstration:*
	- ![URL pasted into mpv](https://media.giphy.com/media/uWczvTWFVcxwXG9zJI/giphy.gif)
 - **Powerful Paste Feature: Copy any video or its path from anywhere and play it by pressing **[ctrl]+[v]** directly into mpv media player**
	 - Supports copying the video itself and pasting it inside mpv
	 - Supports copying the path of video and pasting it inside mpv
	 - Supports native windows copy as path feature for videos and pasting inside mpv
	- *Before accepting paste:*
		 - It checks if the pasted path ends with a supported video extension such as **.mkv**
		 - It checks if the pasted path is not an empty extension such as a file-named (**.mkv**) 
		 - It avoids accidental video change, **it only accepts pasting new video if there is no video already playing**
	 - *Feature demonstration:*
	 - ![Local videos pasted into mpv](https://media.giphy.com/media/2zcXmABJzxY4XZfSmg/giphy.gif)
 - **Bookmark Feature: Copy the time of the video by [ctrl]+[c] in mpv then resume the video at any time**
	 - Supports pasting in the player immediately to open copied video along with its seeking time
		 - It avoids accidental video change,  it checks if the pasted time was of the same video
	 - Supports automatic seeking to the time you copied when you open the copied video (even without pasting)
		 - It avoids seeking automatically, it checks if the opened video was the copied video 
	 - Supports the mentioned features in both local files and URLs
		 - It enables you to share path with people (such as video url)
		 - Or to open the video again and resume it by pasting path into mpv 
	 - Feature demonstration
	 - ![Resume copied time by paste](https://thumbs.gfycat.com/LeanPepperyCopperbutterfly-size_restricted.gif)
 - **Path Copy Feature: Copy the video path by [ctrl]+[C]**
	 - It enables you to share path with people (such as video url)
	 - Or to open the video again by pasting path into mpv without resuming the time
### SmartCopyPaste Usage Guide
 - **[ctrl]**+**[c]** to copy the video/path and its time
 - **[ctrl]**+**[C]** to copy the video/path without time
 - **[ctrl]**+**[v]** to paste the video *and time if available*
 - Open video that has its time copied to resume automatically
### SmartCopyPaste Compatibility
 - **SmartCopyPaste is currently for Windows only**
	 - To access windows clipboard, the method was inspired by [@wiiaboo](https://github.com/wiiaboo/) urlcopypaste script. Special thanks for his work.
### SmartCopyPaste To-Do List
 - Enhance the bookmark feature of copy video and time by [ctrl]+[c]
	 - Keep bookmark point even if it is no longer in the clipboard which gives the ability to paste even if the clipboard is overwritten
	 - Make the bookmark point remain for multiple videos and give ability to resume to any saved bookmark point by ctrl+c
 - Support more platforms
	 - Linux
### SmartCopyPaste Changelog
 - 1.0
	- Initial release
