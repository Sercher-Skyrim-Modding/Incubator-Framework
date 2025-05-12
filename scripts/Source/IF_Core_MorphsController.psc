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
    MorphsModel.Initialize()
    MorphsView.Initialize()
EndFunction

; ==============================
; === External Update Entry ===
; ==============================
Function UpdateMorphs()
    MorphsModel.Update()
    MorphsView.Update()
EndFunction

; ==============================
; === Reset State ===
; ==============================
Function ResetMorphs()
    MorphsModel.Reset()
    MorphsView.ResetFull()
EndFunction
