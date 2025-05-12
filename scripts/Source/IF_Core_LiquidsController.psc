Scriptname IF_Core_LiquidsController extends Quest

Import IF_Core_ConfigManager
Import IF_Core_DataManager

;============================================================
; IF Core LiquidsController
; Manages if-liquids in containers and provides public API
;============================================================

; Initialize liquid container data and MCM registration
Function OnInit()
    Debug.Trace("[IF] IF_Core_LiquidsController: OnInit")
    ; TODO:
    ; 1. Retrieve default liquid container configs from IF_Core_ConfigManager
    ; 2. Initialize JContainers maps for each liquid container in IF_Core_DataManager
    ; 3. Register MCM callbacks for the LiquidContainers page
EndFunction

; Periodic update: optional processing of liquid container state
Function OnTick()
    ; TODO:
    ; 1. Iterate through liquid containers and update any dynamic behaviors
EndFunction

; Handle MCM events for the "LiquidContainers" page
Function HandleMCMEvent(String pageName, Int controlID)
    If pageName == "LiquidContainers"
        Debug.Trace("[IF] LiquidsController received MCM event: " + controlID)
        ; TODO:
        ; - Load container template
        ; - Add/Edit/Delete LiquidItem entries in DataManager
        ; - Save changes
    EndIf
EndFunction

; Public API: Add liquids by ID to a container
Function AddIfLiquid(Int liquidID, Int containerID, Float quantity) Global
    Debug.Trace("[IF_API] AddIfLiquid called: liquid=" + liquidID + ", cont=" + containerID + ", qty=" + quantity)
    ; TODO:
    ; 1. Retrieve container map from IF_Core_DataManager
    ; 2. Increase stored quantity for liquidID
    ; 3. Return difference or confirmation
EndFunction

; Public API: Query contents of a liquid container
Function QueryLiquidContainer(Int containerID) Global
    Debug.Trace("[IF_API] QueryLiquidContainer called: cont=" + containerID)
    ; TODO:
    ; 1. Retrieve container map and return a form or map of LiquidItem[]
    Return None
EndFunction
