ScriptName IF_Core_ConfigManager extends Quest

;==============================
; Properties for Config Storage Scripts
;==============================
IF_Core_ConfigStorage_Morphs Property MorphsStorage Auto
IF_Core_ConfigStorage_MorphPacks Property MorphPacksStorage Auto
IF_Core_ConfigStorage_Overlays Property OverlaysStorage Auto
IF_Core_ConfigStorage_Stats Property StatsStorage Auto
IF_Core_ConfigStorage_Objects Property ObjectsStorage Auto
IF_Core_ConfigStorage_Liquids Property LiquidsStorage Auto
IF_Core_ConfigStorage_Containers Property ContainersStorage Auto

;==============================
; Initialization Function
;==============================
Function LoadAllConfigs()
    ; Load each configuration
    MorphsStorage.Initialize()
    ContainersStorage.Initialize()
    
    MorphPacksStorage.Initialize()

    OverlaysStorage.Initialize()
    
    StatsStorage.Initialize()
    ObjectsStorage.Initialize()
    LiquidsStorage.Initialize()
EndFunction

;==============================
; Utility Function
;==============================
Function RefreshAllCaches()
    MorphsStorage.RefreshCache()
    ContainersStorage.RefreshCache()

    MorphPacksStorage.RefreshCache()
EndFunction

;==============================
; Accessor Functions
;==============================
IF_Core_ConfigStorage_Morphs Function GetMorphsStorage() ; Returns Morphs configuration storage
    return MorphsStorage
EndFunction

IF_Core_ConfigStorage_MorphPacks Function GetMorphPacksStorage() ; Returns MorphPacks configuration storage
    return MorphPacksStorage
EndFunction

IF_Core_ConfigStorage_Overlays Function GetOverlaysStorage() ; Returns Overlays configuration storage
    return OverlaysStorage
EndFunction

IF_Core_ConfigStorage_Stats Function GetStatsStorage() ; Returns Stats configuration storage
    return StatsStorage
EndFunction

IF_Core_ConfigStorage_Objects Function GetObjectsStorage() ; Returns Objects configuration storage
    return ObjectsStorage
EndFunction

IF_Core_ConfigStorage_Liquids Function GetLiquidsStorage() ; Returns Liquids configuration storage
    return LiquidsStorage
EndFunction

IF_Core_ConfigStorage_Containers Function GetContainersStorage() ; Returns Containers configuration storage
    return ContainersStorage
EndFunction
