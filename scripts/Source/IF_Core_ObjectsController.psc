Scriptname IF_Core_ObjectsController extends Quest

Import IF_Core_ConfigManager
Import IF_Core_DataManager

;============================================================
; IF Core ObjectsController
; Manages if-objects in containers and provides public API
;============================================================

; Initialize object container data and MCM registration
Function OnInit()
    Debug.Trace("[IF] IF_Core_ObjectsController: OnInit")
    ; TODO:
    ; 1. Retrieve default object container configs from IF_Core_ConfigManager
    ; 2. Initialize JContainers maps for each container in IF_Core_DataManager
    ; 3. Register MCM callbacks for the ObjectsContainers page
EndFunction

; Periodic update: optional processing of container state
Function OnTick()
    ; TODO:
    ; 1. Iterate through object containers and update any dynamic behaviors
EndFunction

; Handle MCM events for the "ObjectsContainers" page
Function HandleMCMEvent(String pageName, Int controlID)
    If pageName == "ObjectsContainers"
        Debug.Trace("[IF] ObjectsController received MCM event: " + controlID)
        ; TODO:
        ; - Load container template
        ; - Add/Edit/Delete ContainerItem entries in DataManager
        ; - Save changes
    EndIf
EndFunction

; Public API: Add objects by ID to a container
Function AddIfObject(Int objectID, Int containerID, Float quantity) Global
    Debug.Trace("[IF_API] AddIfObject called: obj=" + objectID + ", cont=" + containerID + ", qty=" + quantity)
    ; TODO:
    ; 1. Retrieve container map from IF_Core_DataManager
    ; 2. Increase stored quantity for objectID
    ; 3. Return difference or confirmation
EndFunction

; Public API: Query contents of a container
Function QueryContainer(Int containerID) Global
    Debug.Trace("[IF_API] QueryContainer called: cont=" + containerID)
    ; TODO:
    ; 1. Retrieve container map and return a form or map of ContainerItem[]
    Return None
EndFunction
