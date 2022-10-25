# ClipBoardManager
A macOS menubar clipboard manager with file support.

## Features
The menu bar item menu shows the clipboard history. The app tries to reconstruct the clipboard state as closely as possible. Therefore, the app supports a wide variety of formats, e.g.

- Files
- Multiple files
- Directories
- Web images
- Text

![Menu](./screenshots/Menu.png)

## Requirements and Versions
The standard version makes use of APIs that are only available on **MacOS13** and later. This older version has fewer features, e.g. no start at login via app preferences or file icons.

## Installation

You can compile the app yourself using xcode `xcodebuild -configuration Release` or you can download a compiled version from [releases](https://github.com/Lennard599/ClipBoardManager/releases).


## FAQ

**Why is the clipboard history incomplete?**

There are three possibilities:
- The app was not running. ClipBoardManager can only record the clipboard if it is running.
- If you copy faster than the refresh interval, the app is not able to save the state of the clipboard. You can reduce the refresh interval in the preferences.
- The app crashed or was forcefully closed. On closing, the app will write the clipboard history to disk, so it can be retrieved on the next startup.

## Links
[CPUMonitor menu bar app](https://github.com/Lennard599/CPUMonitor)