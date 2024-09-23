#Requires AutoHotkey v2.0

;=======================================================================================================================
; CAPS-UNLOCKED
;=======================================================================================================================
; This is a complete solution to map the CapsLock key to Control and Escape without losing the ability to toggle CapsLock
;
;  * Use CapsLock as Escape if it's the only key that is pressed and released within 300ms (configurable)
;  * Use CapsLock as LControl when used in conjunction with some other key or if it's held longer than 300ms
;  * Toggle CapsLock by pressing LControl+CapsLock

SetCapsLockState "Off"
StartTime := 0
Capslock::
{
    ; Declare global variables
    global StartTime, A_PriorKey

    if GetKeyState("LControl", "P") {
        KeyWait("CapsLock")
        Send("{CapsLock Down}")
        return
    }

    Send("{LControl Down}")
    State := (GetKeyState("Alt", "P") || GetKeyState("Shift", "P") || GetKeyState("LWin", "P") || GetKeyState("RWin", "P"))
    if (!State && StartTime = 0) {
        StartTime := A_TickCount
    }

    KeyWait("CapsLock")
    Send("{LControl Up}")
    
    ; Read settings from INI file
    condEscape := IniRead(A_ScriptDir "\Settings.ini", "CapsUnlocked", "TapEscape", 1)
    if (State || !condEscape) {
        return
    }

    elapsedTime := A_TickCount - StartTime
    timeout := IniRead(A_ScriptDir "\Settings.ini", "CapsUnlocked", "Timeout", 300)
    if (A_PriorKey = "CapsLock" && elapsedTime < timeout) {
        Send("{Esc}")
    }

    StartTime := 0
    return
}
