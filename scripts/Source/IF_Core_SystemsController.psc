Scriptname IF_Core_SystemsController extends Quest

;============================================================
; IF Core SystemsController
; Central registry and updater for all subsystem controllers
;============================================================

; Subsystem controller properties
IF_Core_GeneralController    Property GeneralController    Auto
IF_Core_MorphsController     Property MorphsController     Auto
IF_Core_MorphPacksController Property MorphPacksController Auto
IF_Core_StatsController      Property StatsController      Auto
IF_Core_ObjectsController    Property ObjectsController    Auto
IF_Core_LiquidsController    Property LiquidsController    Auto

; Register and initialize all controllers
Function RegisterAll()
    Debug.Trace("[IF] IF_Core_SystemsController: RegisterAll")
    GeneralController.OnInit()
    MorphsController.OnInit()
    MorphPacksController.OnInit()
    StatsController.OnInit()
    ObjectsController.OnInit()
    LiquidsController.OnInit()
EndFunction

; Invoke tick on each controller
Function OnTick()
    GeneralController.OnTick()
    MorphsController.OnTick()
    MorphPacksController.OnTick()
    StatsController.OnTick()
    ObjectsController.OnTick()
    LiquidsController.OnTick()
EndFunction
