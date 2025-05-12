Scriptname IF_Core_Main extends Quest

;============================================================
; IF Core Main Quest Script
; Core framework entry: initialization and update loop
;============================================================

IF_Core_ConfigManager Property ConfigManager Auto
IF_Core_DataManager Property DataManager Auto
    
IF_Core_MorphsController Property MorphsController Auto

; Initialization and system registration
Event OnInit()
    ConfigManager.LoadAllConfigs()
    DataManager.Initialize()
    
    MorphsController.Initialize()

    ConsoleUtil.PrintMessage("[IF Debug] Initialized!")
    RegisterForSingleUpdate(4)
EndEvent

; Periodic update loop
Event OnUpdate()
    DataManager.UpdateAllCaches()
    
    MorphsController.UpdateMorphs()

    ConsoleUtil.PrintMessage("[IF Debug] Update.")
    RegisterForSingleUpdate(4)
EndEvent

; Save data on reset
Event OnReset()
    
EndEvent
