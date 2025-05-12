ScriptName IF_Core_DataStorage_Objects extends Quest

;==============================
; Properties
;==============================
int Property ObjectCache Auto

String Property OBJECT_STORAGE_PREFIX = "SerM.IF.Data.Objects_" AutoReadOnly
String Property POSTFIX_OBJECT_ID = "_ObjectID" AutoReadOnly
String Property POSTFIX_CONTAINER_ID = "_ContainerID" AutoReadOnly
String Property POSTFIX_PROGRESS = "_Progress" AutoReadOnly
String Property POSTFIX_ALL_INSTANCES = "AllInstances" AutoReadOnly
String Property tKEY_COUNTER = "UniqueCounter" AutoReadOnly

IF_Core_ConfigStorage_Objects Property ConfigObjects Auto
IF_Core_ConfigStorage_Containers Property ConfigContainers Auto

;==============================
; Initialization
;==============================
Function Initialize()
    RemoveObsoleteInstances()
    UpdateCache()
EndFunction

;==============================
; Instance Maintenance
;==============================
Function RemoveObsoleteInstances()
    String[] allInstances = GetAllInstanceIDs()
    if allInstances == None
        return
    endif

    int i = 0
    while i < allInstances.Length
        Int instanceID = allInstances[i] as Int
        String objectID = GetObjectID(instanceID)
        String containerID = GetContainer(instanceID)

        if !ConfigObjects.HasObject(objectID) || !ConfigContainers.HasContainer(containerID)
            RemoveInstance(instanceID)
        endif
        i += 1
    endwhile
EndFunction

Function ClearAllInstances()
    StorageUtil.ClearAllPrefix(OBJECT_STORAGE_PREFIX)
    StorageUtil.ClearStringListPrefix(OBJECT_STORAGE_PREFIX + POSTFIX_ALL_INSTANCES)
    StorageUtil.SetIntValue(None, OBJECT_STORAGE_PREFIX + tKEY_COUNTER, 0)
EndFunction

;==============================
; ID Management
;==============================
Int Function GetNextInstanceID()
    Int current = StorageUtil.GetIntValue(None, OBJECT_STORAGE_PREFIX + tKEY_COUNTER)
    current += 1
    StorageUtil.SetIntValue(None, OBJECT_STORAGE_PREFIX + tKEY_COUNTER, current)
    return current
EndFunction

Int Function TryCreateObjectInstance(String objectID, String containerID, Int count)
    if !ConfigObjects.HasObject(objectID) || !ConfigContainers.HasContainer(containerID)
        return -1
    endif

    Int instanceID = GetNextInstanceID()
    String instanceKey = OBJECT_STORAGE_PREFIX + "Instance_" + instanceID

    StorageUtil.StringListAdd(None, OBJECT_STORAGE_PREFIX + POSTFIX_ALL_INSTANCES, instanceID + "")
    StorageUtil.SetStringValue(None, instanceKey + POSTFIX_OBJECT_ID, objectID)
    StorageUtil.SetStringValue(None, instanceKey + POSTFIX_CONTAINER_ID, containerID)
    StorageUtil.SetFloatValue(None, instanceKey + POSTFIX_PROGRESS, 0.0)
    return instanceID
EndFunction

Function RemoveInstance(Int instanceID)
    String instanceKey = OBJECT_STORAGE_PREFIX + "Instance_" + instanceID
    StorageUtil.UnsetStringValue(None, instanceKey + POSTFIX_OBJECT_ID)
    StorageUtil.UnsetStringValue(None, instanceKey + POSTFIX_CONTAINER_ID)
    StorageUtil.UnsetFloatValue(None, instanceKey + POSTFIX_PROGRESS)

    int count = StorageUtil.StringListCount(None, OBJECT_STORAGE_PREFIX + POSTFIX_ALL_INSTANCES)
    int i = 0
    while i < count
        if StorageUtil.StringListGet(None, OBJECT_STORAGE_PREFIX + POSTFIX_ALL_INSTANCES, i) == instanceID + ""
            StorageUtil.StringListRemove(None, OBJECT_STORAGE_PREFIX + POSTFIX_ALL_INSTANCES, i)
            return
        endif
        i += 1
    endwhile
EndFunction

String[] Function GetAllInstanceIDs()
    return StorageUtil.StringListToArray(None, OBJECT_STORAGE_PREFIX + POSTFIX_ALL_INSTANCES)
EndFunction

Bool Function HasInstance(Int instanceID)
    String instanceKey = OBJECT_STORAGE_PREFIX + "Instance_" + instanceID
    return StorageUtil.HasStringValue(None, instanceKey + POSTFIX_OBJECT_ID)
EndFunction

;==============================
; Setters
;==============================
Function SetContainer(Int instanceID, String containerID)
    String instanceKey = OBJECT_STORAGE_PREFIX + "Instance_" + instanceID
    StorageUtil.SetStringValue(None, instanceKey + POSTFIX_CONTAINER_ID, containerID)
EndFunction

Function SetProgress(Int instanceID, Float value)
    if value < 0.0
        value = 0.0
    elseif value > 1.0
        value = 1.0
    endif
    String instanceKey = OBJECT_STORAGE_PREFIX + "Instance_" + instanceID
    StorageUtil.SetFloatValue(None, instanceKey + POSTFIX_PROGRESS, value)
EndFunction

Function AddProgress(Int instanceID, Float delta)
    Float current = GetProgress(instanceID)
    SetProgress(instanceID, current + delta)
EndFunction

;==============================
; Getters
;==============================
String Function GetContainer(Int instanceID)
    String instanceKey = OBJECT_STORAGE_PREFIX + "Instance_" + instanceID
    return StorageUtil.GetStringValue(None, instanceKey + POSTFIX_CONTAINER_ID)
EndFunction

Float Function GetProgress(Int instanceID)
    String instanceKey = OBJECT_STORAGE_PREFIX + "Instance_" + instanceID
    return StorageUtil.GetFloatValue(None, instanceKey + POSTFIX_PROGRESS)
EndFunction

String Function GetObjectID(Int instanceID)
    String instanceKey = OBJECT_STORAGE_PREFIX + "Instance_" + instanceID
    return StorageUtil.GetStringValue(None, instanceKey + POSTFIX_OBJECT_ID)
EndFunction

;==============================
; Filtering
;==============================
Int[] Function GetInstancesByContainer(String containerID)
    String[] all = GetAllInstanceIDs()
    if all == None
        return JArray.asIntArray(JArray.object())
    endif

    Int result = JArray.object()
    int i = 0
    while i < all.Length
        Int id = all[i] as Int
        if GetContainer(id) == containerID
            JArray.AddInt(result, id)
        endif
        i += 1
    endwhile
    return JArray.asIntArray(result)
EndFunction

Int[] Function GetInstancesByObject(String objectID)
    String[] all = GetAllInstanceIDs()
    if all == None
        return JArray.asIntArray(JArray.object())
    endif

    Int result = JArray.object()
    int i = 0
    while i < all.Length
        Int id = all[i] as Int
        if GetObjectID(id) == objectID
            JArray.AddInt(result, id)
        endif
        i += 1
    endwhile
    return JArray.asIntArray(result)
EndFunction

Int Function CountInstancesByContainer(String containerID)
    return GetInstancesByContainer(containerID).Length
EndFunction

Int Function CountInstancesByObject(String objectID)
    return GetInstancesByObject(objectID).Length
EndFunction

;==============================
; Filtering by container & object (cached)
;==============================
Int[] Function GetInstancesByContainerAndObject_Cached(String containerID, String objectID)
    Int result = JArray.object()
    if ObjectCache == 0
        return JArray.asIntArray(result)
    endif

    String[] tKeys = JMap.allKeysPArray(ObjectCache)
    int i = 0
    while i < tKeys.Length
        String tKey = tKeys[i]
        int id = tKey as Int
        int entry = JMap.getObj(ObjectCache, tKey)
        if entry != 0 && JMap.getStr(entry, "objectID") == objectID && JMap.getStr(entry, "containerID") == containerID
            JArray.addInt(result, id)
        endif
        i += 1
    endwhile
    return JArray.asIntArray(result)
EndFunction

Int Function CountInstancesByContainerAndObject_Cached(String containerID, String objectID)
    return GetInstancesByContainerAndObject_Cached(containerID, objectID).Length
EndFunction

;==============================
; Cache Management
;==============================
Function UpdateCache()
    int cacheID = JMap.object()
    String[] all = GetAllInstanceIDs()
    if all == None
        return
    endif

    int i = 0
    while i < all.Length
        Int id = all[i] as Int
        int obj = JMap.object()
        JMap.setStr(obj, "containerID", GetContainer(id))
        JMap.setFlt(obj, "progress", GetProgress(id))
        JMap.setStr(obj, "objectID", GetObjectID(id))
        JMap.setObj(cacheID, id + "", obj)
        i += 1
    endwhile

    ObjectCache = cacheID
EndFunction

;==============================
; Cached Accessors
;==============================
Float Function GetProgress_Cached(Int id)
    if ObjectCache == 0
        return 0.0
    endif
    int entry = JMap.getObj(ObjectCache, id + "")
    if entry == 0
        return 0.0
    endif
    return JMap.getFlt(entry, "progress")
EndFunction

String Function GetContainer_Cached(Int id)
    if ObjectCache == 0
        return ""
    endif
    int entry = JMap.getObj(ObjectCache, id + "")
    if entry == 0
        return ""
    endif
    return JMap.getStr(entry, "containerID")
EndFunction

String Function GetObjectID_Cached(Int id)
    if ObjectCache == 0
        return ""
    endif
    int entry = JMap.getObj(ObjectCache, id + "")
    if entry == 0
        return ""
    endif
    return JMap.getStr(entry, "objectID")
EndFunction

;==============================
; Cached Filtering
;==============================
Int[] Function GetInstancesByContainer_Cached(String containerID)
    Int result = JArray.object()
    if ObjectCache == 0
        return JArray.asIntArray(result)
    endif

    String[] tKeys = JMap.allKeysPArray(ObjectCache)
    int i = 0
    while i < tKeys.length
        String tKey = tKeys[i]
        int id = tKey as Int
        int entry = JMap.getObj(ObjectCache, tKey)
        if entry != 0 && JMap.getStr(entry, "containerID") == containerID
            JArray.addInt(result, id)
        endif
        i += 1
    endwhile
    return JArray.asIntArray(result)
EndFunction

Int[] Function GetInstancesByObject_Cached(String objectID)
    Int result = JArray.object()
    if ObjectCache == 0
        return JArray.asIntArray(result)
    endif

    String[] tKeys = JMap.allKeysPArray(ObjectCache)
    int i = 0
    while i < tKeys.Length
        String tKey = tKeys[i]
        int id = tKey as Int
        int entry = JMap.getObj(ObjectCache, tKey)
        if entry != 0 && JMap.getStr(entry, "objectID") == objectID
            JArray.addInt(result, id)
        endif
        i += 1
    endwhile
    return JArray.asIntArray(result)
EndFunction

Int Function CountInstancesByContainer_Cached(String containerID)
    return GetInstancesByContainer_Cached(containerID).Length
EndFunction

Int Function CountInstancesByObject_Cached(String objectID)
    return GetInstancesByObject_Cached(objectID).Length
EndFunction



;/
    ; Получаем все ID инстансов
    String[] allIDs = YourStorageReference.GetAllInstanceIDs()
    if allIDs != None
        int i = 0
        while i < allIDs.Length
            Int instanceID = allIDs[i] as Int

            String objectID = YourStorageReference.GetObjectID_Cached(instanceID)
            String containerID = YourStorageReference.GetContainer_Cached(instanceID)
            Float progress = YourStorageReference.GetProgress_Cached(instanceID)

            Debug.Trace("Instance " + instanceID + " => Object: " + objectID + ", Container: " + containerID + ", Progress: " + progress)

            i += 1
        endwhile
    endif
/;