Scriptname IF_Core_GeneralController extends Quest

;============================================================
; IF Core GeneralController: manage enable/disable and cleanup
;============================================================

; Reference to DataManager instance
IF_Core_DataManager Property DataManager Auto

; Initialization
Function OnInit()
    Debug.Trace("[IF] IF_Core_GeneralController: OnInit")
EndFunction

; No periodic actions
Function OnTick()
EndFunction

; Handle MCM events for "General" page
Function HandleMCMEvent(String pageName, Int controlID)
    If pageName == "General"
        Debug.Trace("[IF] IF_Core_GeneralController MCM event: " + controlID)
    EndIf
EndFunction

; Enable the mod
Function EnableMod()
    Debug.Trace("[IF_API] EnableMod called")
EndFunction

; Disable the mod
Function DisableMod()
    Debug.Trace("[IF_API] DisableMod called")
EndFunction

; Reset all data and configurations
Function ResetAll()
    Debug.Trace("[IF_API] ResetAll called")
    DataManager.SaveAll()
EndFunction
