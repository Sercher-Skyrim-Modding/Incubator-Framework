ScriptName IF_Core_DataStorage_Containers extends Quest

String Property CONTAINER_STORAGE_PREFIX = "SerM.IF.Data.Containers_" AutoReadOnly
String Property POSTFIX_CAPACITY = "_Capacity" AutoReadOnly
String Property POSTFIX_GATE_SIZE = "_GateSize" AutoReadOnly
String Property POSTFIX_ALL_IDS = "AllIDs" AutoReadOnly

String Property CACHE_KEY_CAPACITY = "capacity" AutoReadOnly
String Property CACHE_KEY_GATE_SIZE = "gateSize" AutoReadOnly

IF_Core_ConfigStorage_Containers Property ConfigContainers Auto

;==============================
; Initialization
;==============================
Function Initialize()
    SyncWithConfig()
    RemoveObsoleteInstances()
EndFunction

Function SyncWithConfig()
    String[] containerIDs = ConfigContainers.GetAllContainerIDs()
    if containerIDs == None
        return
    endif

    int i = 0
    while i < containerIDs.Length
        String id = containerIDs[i]
        if !HasContainerID(id)
            SetCapacity(id, 0.0)
            SetGateSize(id, 0.0)
        endif
        i += 1
    endwhile
EndFunction

Function RemoveObsoleteInstances()
    String[] validIDs = ConfigContainers.GetAllContainerIDs()
    if validIDs == None
        return
    endif

    String[] allIDs = GetAllContainerIDs()
    if allIDs == None
        return
    endif

    int i = 0
    while i < allIDs.Length
        String id = allIDs[i]
        bool isValid = false
        int j = 0
        while j < validIDs.Length
            if validIDs[j] == id
                isValid = true
                j = validIDs.Length
            endif
            j += 1
        endwhile

        if !isValid
            StorageUtil.UnsetFloatValue(None, CONTAINER_STORAGE_PREFIX + id + POSTFIX_CAPACITY)
            StorageUtil.UnsetFloatValue(None, CONTAINER_STORAGE_PREFIX + id + POSTFIX_GATE_SIZE)
            RemoveContainerID(id)
        endif
        i += 1
    endwhile
EndFunction

Function ClearAllContainers()
    String[] allIDs = GetAllContainerIDs()
    if allIDs == None
        return
    endif

    int i = 0
    while i < allIDs.Length
        String id = allIDs[i]
        StorageUtil.UnsetFloatValue(None, CONTAINER_STORAGE_PREFIX + id + POSTFIX_CAPACITY)
        StorageUtil.UnsetFloatValue(None, CONTAINER_STORAGE_PREFIX + id + POSTFIX_GATE_SIZE)
        i += 1
    endwhile

    StorageUtil.ClearStringListPrefix(CONTAINER_STORAGE_PREFIX + POSTFIX_ALL_IDS)
EndFunction

;==============================
; Base Setters / Getters
;==============================
Function SetCapacity(String containerID, Float value)
    if !HasContainerID(containerID)
        RegisterContainerID(containerID)
    endif
    Float min = ConfigContainers.GetMinCapacity(containerID)
    Float max = ConfigContainers.GetMaxCapacity(containerID)
    StorageUtil.SetFloatValue(None, CONTAINER_STORAGE_PREFIX + containerID + POSTFIX_CAPACITY, Clamp(value, min, max))
EndFunction

Function SetGateSize(String containerID, Float value)
    if !HasContainerID(containerID)
        RegisterContainerID(containerID)
    endif
    Float min = ConfigContainers.GetMinGateSize(containerID)
    Float max = ConfigContainers.GetMaxGateSize(containerID)
    StorageUtil.SetFloatValue(None, CONTAINER_STORAGE_PREFIX + containerID + POSTFIX_GATE_SIZE, Clamp(value, min, max))
EndFunction

Function IncreaseCapacity(String containerID, Float amount)
    SetCapacity(containerID, GetCapacity(containerID) + amount)
EndFunction

Function DecreaseCapacity(String containerID, Float amount)
    SetCapacity(containerID, GetCapacity(containerID) - amount)
EndFunction

Function IncreaseGateSize(String containerID, Float amount)
    SetGateSize(containerID, GetGateSize(containerID) + amount)
EndFunction

Function DecreaseGateSize(String containerID, Float amount)
    SetGateSize(containerID, GetGateSize(containerID) - amount)
EndFunction

Function MakeCapacityExtensionTick(String containerID, Float modifier = 1.0)
    IncreaseCapacity(containerID, ConfigContainers.GetCapacityExtensionSpeed(containerID) * modifier)
EndFunction

Function MakeCapacityRegenerationTick(String containerID, Float modifier = 1.0)
    DecreaseCapacity(containerID, ConfigContainers.GetCapacityRegenerationSpeed(containerID) * modifier)
EndFunction

Function MakeGateExtensionTick(String containerID, Float modifier = 1.0)
    IncreaseGateSize(containerID, ConfigContainers.GetGateExtensionSpeed(containerID) * modifier)
EndFunction

Function MakeGateRegenerationTick(String containerID, Float modifier = 1.0)
    DecreaseGateSize(containerID, ConfigContainers.GetGateRegenerationSpeed(containerID) * modifier)
EndFunction

Float Function GetCapacity(String containerID)
    return StorageUtil.GetFloatValue(None, CONTAINER_STORAGE_PREFIX + containerID + POSTFIX_CAPACITY)
EndFunction

Float Function GetGateSize(String containerID)
    return StorageUtil.GetFloatValue(None, CONTAINER_STORAGE_PREFIX + containerID + POSTFIX_GATE_SIZE)
EndFunction

Bool Function HasContainerID(String containerID)
    int count = StorageUtil.StringListCount(None, CONTAINER_STORAGE_PREFIX + POSTFIX_ALL_IDS)
    int i = 0
    while i < count
        if StorageUtil.StringListGet(None, CONTAINER_STORAGE_PREFIX + POSTFIX_ALL_IDS, i) == containerID
            return true
        endif
        i += 1
    endwhile
    return false
EndFunction

Function RegisterContainerID(String containerID)
    StorageUtil.StringListAdd(None, CONTAINER_STORAGE_PREFIX + POSTFIX_ALL_IDS, containerID)
EndFunction

Function RemoveContainerID(String containerID)
    int count = StorageUtil.StringListCount(None, CONTAINER_STORAGE_PREFIX + POSTFIX_ALL_IDS)
    int i = 0
    while i < count
        if StorageUtil.StringListGet(None, CONTAINER_STORAGE_PREFIX + POSTFIX_ALL_IDS, i) == containerID
            StorageUtil.StringListRemove(None, CONTAINER_STORAGE_PREFIX + POSTFIX_ALL_IDS, i)
            return
        endif
        i += 1
    endwhile
EndFunction

String[] Function GetAllContainerIDs()
    return StorageUtil.StringListToArray(None, CONTAINER_STORAGE_PREFIX + POSTFIX_ALL_IDS)
EndFunction

;==============================
; Cached Data
;==============================
Int Property ContainerCache Auto Hidden

Function UpdateCache()
    ContainerCache = JMap.object()
    String[] allIDs = GetAllContainerIDs()
    if allIDs == None
        return
    endif

    int i = 0
    while i < allIDs.Length
        String id = allIDs[i]
        if ConfigContainers.HasContainer(id)
            int entry = JMap.object()
            JMap.setFlt(entry, CACHE_KEY_CAPACITY, GetCapacity(id))
            JMap.setFlt(entry, CACHE_KEY_GATE_SIZE, GetGateSize(id))
            JMap.setObj(ContainerCache, id, entry)
        endif
        i += 1
    endwhile
EndFunction

Bool Function HasContainer_Cached(String containerID)
    return JMap.hasKey(ContainerCache, containerID)
EndFunction

Float Function GetCapacity_Cached(String containerID)
    return JMap.getFlt(JMap.getObj(ContainerCache, containerID), CACHE_KEY_CAPACITY)
EndFunction

Float Function GetGateSize_Cached(String containerID)
    return JMap.getFlt(JMap.getObj(ContainerCache, containerID), CACHE_KEY_GATE_SIZE)
EndFunction

;==============================
; Utility
;==============================
Float Function Clamp(Float value, Float min, Float max)
    if value < min
        return min
    elseif value > max
        return max
    endif
    return value
EndFunction


;/
    String containerID = "MyContainer"

    if DataStorageContainers.HasContainer_Cached(containerID)
        Float currentCapacity = DataStorageContainers.GetCapacity_Cached(containerID)
        Float currentGateSize = DataStorageContainers.GetGateSize_Cached(containerID)
        Debug.Trace("Container [" + containerID + "] -> Capacity: " + currentCapacity + ", GateSize: " + currentGateSize)
    endif
/;