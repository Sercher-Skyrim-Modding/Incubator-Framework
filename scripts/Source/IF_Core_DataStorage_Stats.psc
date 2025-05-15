ScriptName IF_Core_DataStorage_Stats extends Quest

;==============================
; Properties
;==============================
int Property StatCache Auto

String Property STAT_STORAGE_PREFIX = "SerM.IF.Data.Stats_" AutoReadOnly
String Property POSTFIX_BASE = "_Base" AutoReadOnly
String Property POSTFIX_ALL_IDS = "AllIDs" AutoReadOnly

IF_Core_ConfigStorage_Stats Property ConfigStats Auto

;==============================
; Initialization
;==============================
Function Initialize()
    SyncWithConfig()
    RemoveObsoleteStats()
    UpdateCache()
EndFunction

Function SyncWithConfig()
    int statIDs = ConfigStats.GetAllStatIDs_JArray()
    if statIDs == 0
        return
    endif

    int i = 0
    while i < jArray.count(statIDs)
        String id = jArray.getStr(statIDs, i, "null")
        if !HasStat(id)
            SetBaseValue(id, 0.0)
        endif
        i += 1
    endwhile
EndFunction

Function RemoveObsoleteStats()
    int validIDs = ConfigStats.GetAllStatIDs_JArray()
    if validIDs == 0
        return
    endif

    String[] allIDs = GetAllStatIDs()
    if allIDs == None
        return
    endif

    int i = 0
    while i < allIDs.Length
        String id = allIDs[i]
        bool isValid = false
        int j = 0
        while j < jArray.count(validIDs)
            if jArray.getStr(validIDs, j) == id
                isValid = true
                j = jArray.count(validIDs)
            endif
            j += 1
        endwhile

        if !isValid
            StorageUtil.UnsetFloatValue(None, STAT_STORAGE_PREFIX + id + POSTFIX_BASE)
            RemoveStatID(id)
        endif
        i += 1
    endwhile
EndFunction

Function ClearAllStats()
    String[] allIDs = GetAllStatIDs()
    if allIDs == None
        return
    endif

    int i = 0
    while i < allIDs.Length
        String id = allIDs[i]
        StorageUtil.UnsetFloatValue(None, STAT_STORAGE_PREFIX + id + POSTFIX_BASE)
        i += 1
    endwhile

    StorageUtil.ClearStringListPrefix(STAT_STORAGE_PREFIX + POSTFIX_ALL_IDS)
EndFunction

;==============================
; Stat Management
;==============================
Function SetBaseValue(String statID, Float value)
    if !HasStatID(statID)
        StorageUtil.StringListAdd(None, STAT_STORAGE_PREFIX + POSTFIX_ALL_IDS, statID)
    endif
    StorageUtil.SetFloatValue(None, STAT_STORAGE_PREFIX + statID + POSTFIX_BASE, value)
EndFunction

Float Function GetBaseValue(String statID)
    return StorageUtil.GetFloatValue(None, STAT_STORAGE_PREFIX + statID + POSTFIX_BASE)
EndFunction

; Checks if the stat has a value assigned (physically exists in StorageUtil)
Bool Function HasStat(String statID)
    return StorageUtil.HasFloatValue(None, STAT_STORAGE_PREFIX + statID + POSTFIX_BASE)
EndFunction

; Checks if the statID is registered in the list of all stat IDs
Bool Function HasStatID(String statID)
    int count = StorageUtil.StringListCount(None, STAT_STORAGE_PREFIX + POSTFIX_ALL_IDS)
    int i = 0
    while i < count
        if StorageUtil.StringListGet(None, STAT_STORAGE_PREFIX + POSTFIX_ALL_IDS, i) == statID
            return true
        endif
        i += 1
    endwhile
    return false
EndFunction

Function RemoveStatID(String statID)
    int count = StorageUtil.StringListCount(None, STAT_STORAGE_PREFIX + POSTFIX_ALL_IDS)
    int i = 0
    while i < count
        if StorageUtil.StringListGet(None, STAT_STORAGE_PREFIX + POSTFIX_ALL_IDS, i) == statID
            StorageUtil.StringListRemove(None, STAT_STORAGE_PREFIX + POSTFIX_ALL_IDS, i)
            return
        endif
        i += 1
    endwhile
EndFunction

String[] Function GetAllStatIDs()
    return StorageUtil.StringListToArray(None, STAT_STORAGE_PREFIX + POSTFIX_ALL_IDS)
EndFunction

;==============================
; Cache
;==============================
Function UpdateCache()
    int cache = JMap.object()
    String[] ids = GetAllStatIDs()
    if ids == None
        return
    endif

    int i = 0
    while i < ids.Length
        String id = ids[i]
        JMap.setFlt(cache, id, GetBaseValue(id))
        i += 1
    endwhile

    StatCache = cache
EndFunction

Float Function GetBaseValue_Cached(String statID)
    if StatCache == 0
        return 0.0
    endif
    if !JMap.hasKey(StatCache, statID)
        return 0.0
    endif
    return JMap.getFlt(StatCache, statID)
EndFunction

Bool Function HasStat_Cached(String statID)
    if StatCache == 0
        return false
    endif
    return JMap.hasKey(StatCache, statID)
EndFunction




;/
    IF_Core_DataStorage_Stats statsStorage = SomeQuestReference as IF_Core_DataStorage_Stats

    String[] allIDs = statsStorage.GetAllStatIDs()
    int i = 0
    while i < allIDs.Length
        String id = allIDs[i]
        Float baseValue = statsStorage.GetBaseValue_Cached(id)
        Debug.Trace("Stat: " + id + " | Value: " + baseValue)
        i += 1
    endwhile
/;