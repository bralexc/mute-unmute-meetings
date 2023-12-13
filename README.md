# Mute/Unmute Meetings Script

This script provides a convenient way to mute/unmute popular meeting applications like MS Teams, Google Meet, Zoom, Webex, and Skype using global hotkeys. It's designed to run in the background and allows for easy switching between applications.

## Features

- Set global hotkeys for muting/unmuting different meeting apps.
- Select different apps to control from a dropdown menu.
- Lock the current window to avoid accidental changes.
- GUI interface for easy interaction.
- Automatically updates the selected application based on the active window.

## Requirements

- AutoHotKey installed on your system.
- Windows OS (the script is designed for Windows environments).

## Installation

1. Clone or download this repository to your local machine.
2. Install AutoHotkey if not already installed.
3. Run the `MuteUnmute.ahk` script.

## Usage

1. Launch the script.
3. Choose the app you want to control from the dropdown menu.
2. Use the global hotkey (default is F9) to mute/unmute the selected app.
4. Optionally, customize the hotkeys for each app in the script.

## Customizing Hotkeys

You can customize the saved hotkeys for each application by editing the `appHotkeys` object in the script:

```ahk
appHotkeys := Object()
appHotkeys["MS Teams"] := "^+m" ; Ctrl+Shift+M
appHotkeys["Google Meet"] := "^d" ; Ctrl+D
...
```

or directly in the app.

## License

This project is GNU GPLv3 licensed.
