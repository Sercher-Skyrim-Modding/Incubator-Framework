ScriptName IF_Core_DataStorage_Liquids extends Quest

;==============================
; Constants
;==============================
String Property LIQUID_STORAGE_PREFIX = "SerM.IF.Data.Liquids_" AutoReadOnly
String Property POSTFIX_AMOUNT = "_Amount" AutoReadOnly
String Property POSTFIX_ALL_IDS = "AllIDs" AutoReadOnly
String Property POSTFIX_CONTAINER_LIST = "_Containers" AutoReadOnly
String Property CACHE_KEY_AMOUNT = "amount" AutoReadOnly

;==============================
; Dependencies
;==============================
IF_Core_ConfigStorage_Liquids Property ConfigLiquids Auto
IF_Core_ConfigStorage_Containers Property ConfigContainers Auto

;==============================
; Cached Data
;==============================
Int Property LiquidCache Auto Hidden

;==============================
; Initialization
;==============================
Function Initialize()
    SyncWithConfig()
    RemoveObsoleteLiquids()
    UpdateCache()
EndFunction

Function SyncWithConfig()
    String[] liquidIDs = ConfigLiquids.GetAllLiquidIDs()
    if liquidIDs == None
        return
    endif

    int i = 0
    while i < liquidIDs.Length
        String id = liquidIDs[i]
        ; Only register if config still contains this liquid
        if ConfigLiquids.HasLiquid(id)
            if !HasLiquidID(id)
                RegisterLiquidID(id)
            endif
        endif
        i += 1
    endwhile
EndFunction

Function RemoveObsoleteLiquids()
    String[] validLiquidIDs = ConfigLiquids.GetAllLiquidIDs()
    String[] validContainerIDs = ConfigContainers.GetAllContainerIDs()

    if validLiquidIDs == None || validContainerIDs == None
        return
    endif

    String[] allLiquidIDs = GetAllLiquidIDs()
    if allLiquidIDs == None
        return
    endif

    int i = 0
    while i < allLiquidIDs.Length
        String liquidID = allLiquidIDs[i]
        bool liquidIsValid = false

        int li = 0
        while li < validLiquidIDs.Length
            if validLiquidIDs[li] == liquidID
                liquidIsValid = true
                li = validLiquidIDs.Length
            endif
            li += 1
        endwhile

        if !liquidIsValid
            RemoveLiquidID(liquidID)
        else
            String containerListKey = LIQUID_STORAGE_PREFIX + liquidID + POSTFIX_CONTAINER_LIST
            String[] containers = StorageUtil.StringListToArray(None, containerListKey)
            int j = 0
            while j < containers.Length
                String containerID = containers[j]

                bool containerValid = false
                int k = 0
                while k < validContainerIDs.Length
                    if validContainerIDs[k] == containerID
                        containerValid = true
                        k = validContainerIDs.Length
                    endif
                    k += 1
                endwhile

                if !containerValid
                    String tKey = LIQUID_STORAGE_PREFIX + liquidID + "_" + containerID + POSTFIX_AMOUNT
                    StorageUtil.UnsetFloatValue(None, tKey)
                    StorageUtil.StringListRemove(None, containerListKey, j)
                    j -= 1
                endif
                j += 1
            endwhile
        endif
        i += 1
    endwhile
EndFunction

Function ClearAll()
    StorageUtil.ClearAllPrefix(LIQUID_STORAGE_PREFIX)
    StorageUtil.ClearStringListPrefix(LIQUID_STORAGE_PREFIX + POSTFIX_ALL_IDS)
EndFunction

;==============================
; Storage Setters / Getters
;==============================
Function RegisterLiquidID(String id)
    if !HasLiquidID(id)
        StorageUtil.StringListAdd(None, LIQUID_STORAGE_PREFIX + POSTFIX_ALL_IDS, id)
    endif

    String[] containerIDs = ConfigContainers.GetAllContainerIDs()
    if containerIDs == None
        return
    endif

    int i = 0
    while i < containerIDs.Length
        SetAmount(id, containerIDs[i], 0.0)
        i += 1
    endwhile
EndFunction

Bool Function HasLiquidID(String id)
    int count = StorageUtil.StringListCount(None, LIQUID_STORAGE_PREFIX + POSTFIX_ALL_IDS)
    int i = 0
    while i < count
        if StorageUtil.StringListGet(None, LIQUID_STORAGE_PREFIX + POSTFIX_ALL_IDS, i) == id
            return true
        endif
        i += 1
    endwhile
    return false
EndFunction

Function RemoveLiquidID(String id)
    int count = StorageUtil.StringListCount(None, LIQUID_STORAGE_PREFIX + POSTFIX_ALL_IDS)
    int i = 0
    while i < count
        if StorageUtil.StringListGet(None, LIQUID_STORAGE_PREFIX + POSTFIX_ALL_IDS, i) == id
            StorageUtil.StringListRemove(None, LIQUID_STORAGE_PREFIX + POSTFIX_ALL_IDS, i)
            return
        endif
        i += 1
    endwhile
EndFunction

String[] Function GetAllLiquidIDs()
    return StorageUtil.StringListToArray(None, LIQUID_STORAGE_PREFIX + POSTFIX_ALL_IDS)
EndFunction

Function SetAmount(String liquidID, String containerID, Float value)
    if !ConfigLiquids.HasLiquid(liquidID) || !ConfigContainers.HasContainer(containerID)
        return
    endif
    if value < 0.0
        value = 0.0
    endif
    String tKey = LIQUID_STORAGE_PREFIX + liquidID + "_" + containerID + POSTFIX_AMOUNT
    StorageUtil.SetFloatValue(None, tKey, value)

    String listKey = LIQUID_STORAGE_PREFIX + liquidID + POSTFIX_CONTAINER_LIST
    int count = StorageUtil.StringListCount(None, listKey)
    int i = 0
    while i < count
        if StorageUtil.StringListGet(None, listKey, i) == containerID
            return
        endif
        i += 1
    endwhile
    StorageUtil.StringListAdd(None, listKey, containerID)
EndFunction

Float Function GetAmount(String liquidID, String containerID)
    String tKey = LIQUID_STORAGE_PREFIX + liquidID + "_" + containerID + POSTFIX_AMOUNT
    return StorageUtil.GetFloatValue(None, tKey)
EndFunction

Function AddAmount(String liquidID, String containerID, Float delta)
    if !ConfigLiquids.HasLiquid(liquidID) || !ConfigContainers.HasContainer(containerID)
        return
    endif
    Float current = GetAmount(liquidID, containerID)
    SetAmount(liquidID, containerID, current + delta)
EndFunction

Function RemoveAmount(String liquidID, String containerID, Float delta)
    if !ConfigLiquids.HasLiquid(liquidID) || !ConfigContainers.HasContainer(containerID)
        return
    endif
    Float current = GetAmount(liquidID, containerID)
    Float result = current - delta
    if result < 0.0
        result = 0.0
    endif
    SetAmount(liquidID, containerID, result)
EndFunction

;==============================
; Cached Access
;==============================
Function UpdateCache()
    int liquidCacheID = JMap.object()

    String[] liquidIDs = GetAllLiquidIDs()
    if liquidIDs == None
        return
    endif

    int i = 0
    while i < liquidIDs.Length
        String lid = liquidIDs[i]
        int liquidEntryID = JMap.object()

        String listKey = LIQUID_STORAGE_PREFIX + lid + POSTFIX_CONTAINER_LIST
        String[] containers = StorageUtil.StringListToArray(None, listKey)

        int j = 0
        while j < containers.Length
            String cid = containers[j]
            Float amt = GetAmount(lid, cid)
            JMap.setFlt(liquidEntryID, cid, amt)
            j += 1
        endwhile

        JMap.setObj(liquidCacheID, lid, liquidEntryID)
        i += 1
    endwhile

    LiquidCache = liquidCacheID
EndFunction

Bool Function HasLiquidID_Cached(String liquidID)
    if LiquidCache == 0
        return false
    endif
    return JMap.hasKey(LiquidCache, liquidID)
EndFunction

Float Function GetAmount_Cached(String liquidID, String containerID)
    if LiquidCache == 0
        return 0.0
    endif
    int liquidEntryID = JMap.getObj(LiquidCache, liquidID)
    if liquidEntryID == 0
        return 0.0
    endif
    return JMap.getFlt(liquidEntryID, containerID)
EndFunction

String[] Function GetLiquidIDsByContainer_Cached(String containerID)
    ; Return list of liquid IDs stored in the specified container using cached data
    if LiquidCache == 0
        return None
    endif

    ; Collect all liquid IDs from cache
    String[] allLiquidIDs = JMap.allKeysPArray(LiquidCache)
    if allLiquidIDs == None
        return None
    endif

    ; Build a JSON array and filter by amount > 0
    Int jarr = JArray.object()
    int i = 0
    while i < allLiquidIDs.Length
        String lid = allLiquidIDs[i]
        Int entryID = JMap.getObj(LiquidCache, lid)
        Float amt = JMap.getFlt(entryID, containerID)
        if amt > 0.0
            JArray.addStr(jarr, lid)
        endif
        i += 1
    endwhile

    ; Convert JArray to Papyrus array
    return JArray.asStringArray(jarr)
EndFunction




;/
    int liquidMap = LiquidCache
    if JMap.hasKey(liquidMap, "Milk")
        int milkMap = JMap.getObj(liquidMap, "Milk")
        String[] containerIDs = JMap.allKeysPArray(milkMap)
        
        int i = 0
        while i < containerIDs.Length
            String containerID = containerIDs[i]
            Float amount = JMap.getFlt(milkMap, containerID)
            Debug.Trace("Milk in container [" + containerID + "]: " + amount)
            i += 1
        endwhile
    endif
/;

;/
    String[] liquidIDs = GetAllLiquidIDs()
    String[] containerIDs = ConfigContainers.GetAllContainerIDs()

    int i = 0
    while i < liquidIDs.Length
        String liquidID = liquidIDs[i]

        if HasLiquidID_Cached(liquidID)
            int j = 0
            while j < containerIDs.Length
                String containerID = containerIDs[j]
                Float amount = GetAmount_Cached(liquidID, containerID)

                if amount > 0.0
                    Debug.Trace("Жидкость [" + liquidID + "] в контейнере [" + containerID + "]: " + amount)
                endif

                j += 1
            endwhile
        endif

        i += 1
/;