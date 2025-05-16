ScriptName IF_Core_MorphsController extends Quest

; ==============================
; === Dependencies ===
; ==============================
IF_Core_MorphsModel Property MorphsModel Auto
IF_Core_MorphsView  Property MorphsView  Auto

; ==============================
; === Initialization ===
; ==============================
Function Initialize()
    ConsoleUtil.PrintMessage("[IF Debug] MorphsController: Initializing...")
    
    MorphsModel.Initialize()
    MorphsView.Initialize()
    
    ConsoleUtil.PrintMessage("[IF Debug] MorphsController: Initialized successfully")
EndFunction

; ==============================
; === External Update Entry ===
; ==============================
Function UpdateMorphs()
    ConsoleUtil.PrintMessage("[IF Debug] MorphsController: Updating morphs...")
    
    MorphsModel.Update()
    MorphsView.Update()
    
    String[] morphPacks = MorphsModel.GetAllMorphPackNames()
    if morphPacks != None && morphPacks.Length > 0
        ConsoleUtil.PrintMessage("[IF Debug] MorphsController: Updated " + morphPacks.Length + " morph packs")
    else
        ConsoleUtil.PrintMessage("[IF Debug] MorphsController: No active morph packs found")
    endif
    
    String[] morphs = MorphsModel.GetAllMorphNames()
    if morphs != None && morphs.Length > 0
        ConsoleUtil.PrintMessage("[IF Debug] MorphsController: Applied " + morphs.Length + " morphs")
    else
        ConsoleUtil.PrintMessage("[IF Debug] MorphsController: No active morphs found")
    endif
EndFunction

; ==============================
; === Reset State ===
; ==============================
Function ResetMorphs()
    ConsoleUtil.PrintMessage("[IF Debug] MorphsController: Resetting all morphs...")
    
    MorphsModel.Reset()
    MorphsView.ResetFull()
    
    ConsoleUtil.PrintMessage("[IF Debug] MorphsController: All morphs reset")
EndFunction
