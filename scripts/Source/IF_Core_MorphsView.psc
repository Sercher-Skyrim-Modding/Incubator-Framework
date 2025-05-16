; IF_Core_MorphsView.psc
; Applies calculated morph values to the player body using NiOverride API

Scriptname IF_Core_MorphsView extends Quest

; ===================
; === Properties ===
; ===================

IF_Core_MorphsModel Property MorphsModel Auto
Actor Property PlayerREF Auto
String Property MorphChannel = "IF_Core_MorphsView" AutoReadOnly
String Property StoragePrefix = "IF_Core_MorphsView_Morph_" AutoReadOnly

; ==========================
; === Function: Initialize ===
; ==========================
Function Initialize()
	Update()
EndFunction

; =================================
; === Function: ResetFull ===
; === Clears morphs, updates body, and clears history ===
; =================================
Function ResetFull()
	Reset()
	
	String[] tUsed = MorphsModel.GetAllMorphNames()
	int j = 0
	while j < tUsed.Length
		String tKey = StoragePrefix + tUsed[j]
		StorageUtil.UnsetStringValue(PlayerREF, tKey)
		j += 1
	endwhile
	NiOverride.UpdateModelWeight(PlayerREF)
EndFunction

; ===================================
; === Function: Reset ===
; === Clears morphs using local history only ===
; ===================================
Function Reset()
	String[] tUsed = MorphsModel.GetAllMorphNames()
	int i = 0
	while i < tUsed.Length
		String tMorph = tUsed[i]
		String tKey = StoragePrefix + tMorph
		NiOverride.ClearBodyMorph(PlayerREF, tMorph, MorphChannel)
		i += 1
	endwhile
EndFunction

; ============================
; === Function: Update ===
; ============================
Function Update()
	ApplyMorphs()
	NiOverride.UpdateModelWeight(PlayerREF)
EndFunction

; ==================================
; === Function: ApplyMorphs ===
; ==================================
Function ApplyMorphs()
    Reset()
    
	String[] tMorphs = MorphsModel.GetAllMorphNames()
	if tMorphs == None
		ConsoleUtil.PrintMessage("[IF Debug] MorphsView: No morphs to apply")
		return
	endif
	
	int appliedCount = 0
	int i = 0
	while i < tMorphs.Length
		String tMorph = tMorphs[i]
		float tValue = MorphsModel.GetMorphValue(tMorph)
		
		if tValue != 0.0
			NiOverride.SetBodyMorph(PlayerREF, tMorph, MorphChannel, tValue)
			String tKey = StoragePrefix + tMorph
			StorageUtil.SetStringValue(PlayerREF, tKey, "1")
			appliedCount += 1
		endif
		
		i += 1
	endwhile
EndFunction
