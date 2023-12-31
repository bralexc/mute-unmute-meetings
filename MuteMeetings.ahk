﻿; Generated by Auto-GUI 3.0.1
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
; runat max speed
SetBatchLines, -1
; detect windows in other virtual monitors
DetectHiddenWindows, On
; set coord mode for pixel functions to be relative to screen
CoordMode, Pixel, Screen

; set app icon
Menu Tray, Icon, %A_ScriptDir%\mic_mute_light.ico

; Define the appHotkeys object
appHotkeys := Object()
appHotkeys["MS Teams"] := "^+m" ; Ctrl+Shift+M
appHotkeys["Google Meet"] := "^d" ; Ctrl+D
appHotkeys["Zoom"] := "!a" ; Alt+A
appHotkeys["Webex"] := "^m" ; Ctrl+M
appHotkeys["Skype"] := "^m" ; Ctrl+M
appHotkeys["Other"] := "" 

; new window, always on top
Gui +hWndhGui +AlwaysOnTop

; app font
Gui Font, s9, Segoe UI
; text label, top
Gui Add, Text, x16 y8 w299 h23 +0x200 +Center +Border, Use the global hotkey to mute/unmute selected app
Gui Add, Text, x16 y40 w80 h22 +0x200  , Global hotkey
; global hotkey
Gui Add, Hotkey, vglobal_hotkey x120 y40 w120 h22, F9
; save button
Gui Add, Button, gOnSaveButton x248 y40 w68 h23 +Default, Save
; ; text label, app to track
Gui Add, Text, x16 y72 w80 h22 +0x200  , App to track
; ; drop down list, ms teams is the default app
; ; todo: populate this list automatically from %appHotkeys%?
Gui Add, DropDownList, vapp_dropdown gOnSelectApp x120 y72 w194, MS Teams||Google Meet|Zoom|Webex|Skype|Other
; ; group box, mute/unmute
Gui Add, GroupBox, x8 y104 w304 h56, Mute/Unmute hotkey
; ; text label, app choice, ms teams hardcoded to default
Gui Add, Text, vapp_text x16 y128 w80 h22 +0x200 , MS Teams
; ; hotkey input/output, manually set to Ctrl+Shift+A
Gui Add, Hotkey, vapp_hotkey gOnUpdateAppHotkey x120 y128 w183 h22, ^+m
; ; group box, app selection view
Gui Add, GroupBox, x8 y168 w304 h130, Selected app to mute/unmute
; ; checkbox, app selecion
Gui Add, CheckBox, vlock_window gOnUpdateLock x16 y192 w104 h23 +Checked , Lock window
; ; text label, app title
Gui Add, Text, x16 y216 w80 h22, Title
; ; input box, read-only
Gui Add, Edit, vapp_title x120 y216 w183 h22 +ReadOnly 
; ; text label, app executable
Gui Add, Text, x16 y240 w80 h22 +0x200  , Executable
; ; input box, read-only
; Gui Add, Edit, vapp_exe x100 y238 w140 h22 +ReadOnly
Gui Add, Edit, vapp_exe x120 y240 w183 h22 +ReadOnly 
; ; text label, app pid
Gui Add, Text, x16 y264 w80 h22 +0x200  , PID
; ; input box, read-only
Gui Add, Edit, vapp_pid x120 y264 w183 h22 +ReadOnly 

; ; show gui, title = Mute/Unmute
Gui Show, w329 h305, Mute/Unmute Meetings

; set global hotkey
GuiControlGet, global_hotkey
HotKey, %global_hotkey%, MuteUnmute

; run 'Update' every 250 ms
SetTimer, Update, 250
Return

; actions when gui is resized --- start
GuiSize:
    ; if window is minimized, stop running 'Update'
    SetTimer, Update, % A_EventInfo=1 ? "Off" : "On" ; Suspend on minimize
return
; actions when gui is resized --- end

; action when lock checkbox is pressed --- start
OnUpdateLock:
    ; retrieve checkbox state
    GuiControlGet, lock_window
    ; if checked, stop updates, else turn it back on
    if lock_window {
        SetTimer, Update, Off
        return
    }
    SetTimer, Update, 250
return
; action when lock checkbox is pressed --- end

; update loop to get selected window --- start
Update:
    ; retrieve check box state - if lock is enabled, don't run the update loop
    GuiControlGet, lock_window
    if lock_window {
        return
    }
    ; no idea what these do - i copied it from WindowSpy :)
    Gui %hGui%:Default
    CoordMode, Mouse, Screen
    MouseGetPos, msX, msY, msWin, msCtrl
    actWin := WinExist("A")
    curWin := actWin
    ControlGetFocus, curCtrl
    ; save window title to t1, ahk_class to t2
    WinGetTitle, t1
    WinGetClass, t2
    ; if we're selecting our own app window, don't do anything
    if (curWin = hGui || t2 = "MultitaskingViewFrame") ; Our Gui || Alt-tab
    {
        return
    }
    ; get the process executable and pid, store it
    WinGet, t3, ProcessName
    WinGet, t4, PID
    ; update fields with the retrieved info
    UpdateText("app_title", t1)
    UpdateText("app_exe", t3)
    UpdateText("app_ahkclass", t2)
    UpdateText("app_pid", t4)
return
; update loop to get selected window --- end


; action dropdown menu changes --- start
OnSelectApp:
    Gui, Submit, NoHide ; Update variables with current control states
    currentApp := app_dropdown
    currentHotkey := appHotkeys[currentApp]
    GuiControl,, app_hotkey, %currentHotkey% ; Update Hotkey field
    GuiControl,, app_text, %currentApp% ; Update Text field
return
; action dropdown menu changes --- end


; action when a hotkey changes --- start
OnUpdateAppHotkey:
    Gui, Submit, NoHide ; Update variables with current control states
    GuiControlGet, app_dropdown
    GuiControlGet, app_hotkey
    appHotkeys[app_dropdown] := app_hotkey
return
; action when a hotkey changes --- end


; action when clicking the save button -- start
OnSaveButton:
    ; remove old hotkey    
    HotKey, %global_hotkey%, Off
    ; assign new one
    GuiControlGet, global_hotkey
    HotKey, %global_hotkey%, MuteUnmute
    HotKey, %global_hotkey%, On
return
; action when clicking the save button -- end


; what to do when we click the close button
GuiClose:
    ExitApp


; update text of a gui control, but it if it changed
UpdateText(ControlID, NewText)
{
	; Unlike using a pure GuiControl, this function causes the text of the
	; controls to be updated only when the text has changed, preventing periodic
	; flickering (especially on older systems).
	static OldText := {}
	global hGui
	if (OldText[ControlID] != NewText)
	{
		GuiControl, %hGui%:, % ControlID, % NewText
		OldText[ControlID] := NewText
	}
}


; mute/unmute hotkey action --- start
MuteUnmute:
    ; get the current target app and its hotkey
    GuiControlGet, app_dropdown
    currentHotkey := appHotkeys[app_dropdown]

    ; get window title
    GuiControlGet, app_title
    
    if WinExist(app_title)
    {
        ; store current window
        actWin := WinExist("A")
        ControlGetFocus, curCtrl
        WinGetTitle, originalWindow

        ; get desired window in focus and send hotkey
        WinActivate, %app_title%
        Send, %currentHotkey%

        ; go back to stored window
        WinActivate, %originalWindow%

        return
    }
    MsgBox, Could not find the windows titled '%app_title%'.
return
; mute/unmute hotkey action --- end

