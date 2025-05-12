ScriptName IF_Core_DataManager extends Quest

IF_Core_DataStorage_Stats Property StatsStorage Auto
IF_Core_DataStorage_Objects Property ObjectsStorage Auto
IF_Core_DataStorage_Liquids Property LiquidsStorage Auto
IF_Core_DataStorage_Containers Property ContainersStorage Auto

;==============================
; Initialization
;==============================
Function Initialize()
    StatsStorage.Initialize()
    ObjectsStorage.Initialize()
    LiquidsStorage.Initialize()
    ContainersStorage.Initialize()
EndFunction

;==============================
; Accessors
;==============================
IF_Core_DataStorage_Stats Function GetStatsStorage() ; returns the stats data storage
    return StatsStorage
EndFunction

IF_Core_DataStorage_Objects Function GetObjectsStorage() ; returns the objects data storage
    return ObjectsStorage
EndFunction

IF_Core_DataStorage_Liquids Function GetLiquidsStorage() ; returns the liquids data storage
    return LiquidsStorage
EndFunction

IF_Core_DataStorage_Containers Function GetContainersStorage() ; returns the containers data storage
    return ContainersStorage
EndFunction

;==============================
; Cache Management
;==============================
Function UpdateAllCaches()
    StatsStorage.UpdateCache()
    ObjectsStorage.UpdateCache()
    LiquidsStorage.UpdateCache()
    ContainersStorage.UpdateCache()
EndFunction
