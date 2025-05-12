; ============================================
; IF_Core_DataController
; Manages logic for interacting with game data layer
; ============================================

ScriptName IF_Core_DataController extends Quest

; ===============================
; Data Storage References
; ===============================
IF_Core_DataStorage_Liquids Property LiquidData Auto
IF_Core_DataStorage_Objects Property ObjectData Auto
IF_Core_DataStorage_Containers Property ContainerData Auto

; ===============================
; Config Storage References
; ===============================
IF_Core_ConfigStorage_Liquids Property LiquidConfigs Auto
IF_Core_ConfigStorage_Objects Property ObjectConfigs Auto
IF_Core_ConfigStorage_Containers Property ContainersConfigs Auto

; ===============================
; Amount Queries
; ===============================

Float Function GetLiquidAmountInContainer(String liquidID, String containerID)
    if !LiquidConfigs.HasLiquid(liquidID) || !ContainersConfigs.HasContainer(containerID)
        return -1.0
    endif
    return LiquidData.GetAmount_Cached(containerID, liquidID)
EndFunction

Int Function GetObjectAmountInContainer(String objectID, String containerID)
    if !ObjectConfigs.HasObject(objectID) || !ContainersConfigs.HasContainer(containerID)
        return -1
    endif
    return ObjectData.CountInstancesByContainerAndObject_Cached(containerID, objectID)
EndFunction

String[] Function GetAllObjectIDsInContainer(String containerID)
    ; Return list of object IDs stored in the specified container using cached data
    if !ContainersConfigs.HasContainer(containerID)
        return None
    endif

    Int[] instanceIDs = ObjectData.GetInstancesByContainer_Cached(containerID)
    if instanceIDs == None
        return None
    endif

    String[] result = PapyrusUtil.StringArray(0)
    int i = 0
    while i < instanceIDs.Length
        String objID = ObjectData.GetObjectID_Cached(instanceIDs[i])
        if objID != ""
            result = PapyrusUtil.PushString(result, objID)
        endif
        i += 1
    endwhile
    return result
EndFunction

String[] Function GetAllLiquidIDsInContainer(String containerID)
    if !ContainersConfigs.HasContainer(containerID)
        return None
    endif
    return LiquidData.GetLiquidIDsByContainer_Cached(containerID)
EndFunction

; ===============================
; Capacity Queries
; ===============================

Float Function GetRemainingContainerCapacity(String containerID, Float limitMod = 0.0)
    if !ContainersConfigs.HasContainer(containerID)
        return -1.0
    endif

    Float capacity = ContainerData.GetCapacity_Cached(containerID)
    Float effectiveCapacity = capacity + limitMod
    Float usedVolume = 0.0

    String[] allLiquidIDs = LiquidConfigs.GetAllLiquidIDs()
    if allLiquidIDs != None
        int i = 0
        while i < allLiquidIDs.Length
            String liquidID = allLiquidIDs[i]
            Float amount = LiquidData.GetAmount_Cached(containerID, liquidID)
            Float volumePerUnit = LiquidConfigs.GetVolume(liquidID)
            usedVolume += amount * volumePerUnit
            i += 1
        endwhile
    endif

    Int[] instanceIDs = ObjectData.GetInstancesByContainer_Cached(containerID)
    if instanceIDs != None
        int j = 0
        while j < instanceIDs.Length
            int id = instanceIDs[j]
            String objectID = ObjectData.GetObjectID_Cached(id)
            if objectID != ""
                Float volumePerUnit = ObjectConfigs.GetVolume(objectID)
                usedVolume += volumePerUnit
            endif
            j += 1
        endwhile
    endif

    return effectiveCapacity - usedVolume
EndFunction

Float Function GetRemainingContainerCapacityWithLimit(String containerID)
    Float limitMod = 0.0
    if ContainersConfigs.HasContainer(containerID)
        limitMod = ContainersConfigs.GetLimitCapacityMod(containerID)
    endif
    return GetRemainingContainerCapacity(containerID, limitMod)
EndFunction

; ===============================
; Fit Checks
; ===============================

Bool Function CanFitLiquid(String liquidID, String containerID, Float amount)
    if !LiquidConfigs.HasLiquid(liquidID) || !ContainersConfigs.HasContainer(containerID)
        return false
    endif
    Float volume = LiquidConfigs.GetVolume(liquidID) * amount
    return volume <= GetRemainingContainerCapacity(containerID)
EndFunction

Bool Function CanFitObject(String objectID, String containerID, Int count)
    if !ObjectConfigs.HasObject(objectID) || !ContainersConfigs.HasContainer(containerID)
        return false
    endif
    Float volume = ObjectConfigs.GetVolume(objectID) * count
    return volume <= GetRemainingContainerCapacity(containerID)
EndFunction

Bool Function CanInsertObject(String objectID, String containerID)
    if !ObjectConfigs.HasObject(objectID) || !ContainersConfigs.HasContainer(containerID)
        return false
    endif
    Float gateSize = ContainerData.GetGateSize_Cached(containerID)
    Float insertionSize = ObjectConfigs.GetInsertionSize(objectID)
    return insertionSize <= gateSize
EndFunction

Bool Function CanExtractObject(String objectID, String containerID)
    if !ObjectConfigs.HasObject(objectID) || !ContainersConfigs.HasContainer(containerID)
        return false
    endif

    Float gateSize = ContainerData.GetGateSize_Cached(containerID)
    Float extractionSize = ObjectConfigs.GetExtractionSize(objectID)
    Float remaining = GetRemainingContainerCapacity(containerID)

    if remaining < 0
        return false
    endif

    Float capacity = ContainerData.GetCapacity_Cached(containerID)
    Float limitMod = ContainersConfigs.GetLimitGateSizeMod(containerID)

    if remaining < 0.0
        gateSize += limitMod
    endif

    return extractionSize <= gateSize
EndFunction

; ===============================
; Liquid/Object Addition
; ===============================

Float Function TryAddLiquidToContainer(String liquidID, String containerID, Float amount, Bool includeLimitCapacity = false)
    if !LiquidConfigs.HasLiquid(liquidID) || !ContainersConfigs.HasContainer(containerID)
        return amount
    endif

    Float liquidVolume = LiquidConfigs.GetVolume(liquidID)
    Float neededVolume = liquidVolume * amount

    Float limitMod = 0.0
    if includeLimitCapacity
        limitMod = ContainersConfigs.GetLimitCapacityMod(containerID)
    endif
    Float remaining = GetRemainingContainerCapacity(containerID, limitMod)

    if remaining <= 0.0
        return amount
    endif

    Float fitAmount = remaining / liquidVolume
    if fitAmount >= amount
        LiquidData.AddAmount(containerID, liquidID, amount)
        return 0.0
    else
        LiquidData.AddAmount(containerID, liquidID, fitAmount)
        return amount - fitAmount
    endif
EndFunction

Int Function TryAddObjectToContainer(String objectID, String containerID, Int count, Bool includeLimitCapacity = false)
    if !ObjectConfigs.HasObject(objectID) || !ContainersConfigs.HasContainer(containerID)
        return count
    endif

    Float objectVolume = ObjectConfigs.GetVolume(objectID)
    Float neededVolume = objectVolume * count

    Float limitMod = 0.0
    if includeLimitCapacity
        limitMod = ContainersConfigs.GetLimitCapacityMod(containerID)
    endif
    Float remaining = GetRemainingContainerCapacity(containerID, limitMod)

    if remaining <= 0.0
        return count
    endif

    Int fitCount = Math.Floor(remaining / objectVolume)
    if fitCount >= count
        ObjectData.TryCreateObjectInstance(containerID, objectID, count)
        return 0
    else
        ObjectData.TryCreateObjectInstance(containerID, objectID, fitCount)
        return count - fitCount
    endif
EndFunction

Int Function TryInsertObjectToContainer(String objectID, String containerID, Int count, Bool includeLimitCapacity = false)
    if !CanInsertObject(objectID, containerID)
        return count
    endif
    return TryAddObjectToContainer(objectID, containerID, count, includeLimitCapacity)
EndFunction

; ===============================
; Liquid/Object Removal
; ===============================

Float Function TryRemoveLiquidFromContainer(String liquidID, String containerID, Float amount)
    if !LiquidConfigs.HasLiquid(liquidID) || !ContainersConfigs.HasContainer(containerID)
        return amount
    endif

    Float currentAmount = LiquidData.GetAmount_Cached(containerID, liquidID)
    if currentAmount >= amount
        LiquidData.RemoveAmount(containerID, liquidID, amount)
        return 0.0
    else
        LiquidData.RemoveAmount(containerID, liquidID, currentAmount)
        return amount - currentAmount
    endif
EndFunction

Int Function TryRemoveObjectFromContainer(String objectID, String containerID, Int count)
    if !ObjectConfigs.HasObject(objectID) || !ContainersConfigs.HasContainer(containerID)
        return count
    endif

    Int[] instanceIDs = ObjectData.GetInstancesByContainerAndObject_Cached(containerID, objectID)
    if instanceIDs == None
        return count
    endif

    Int actualCount = instanceIDs.Length
    Int toRemove = count
    if count > actualCount
        toRemove = actualCount
    endif

    Int i = 0
    while i < toRemove
        ObjectData.RemoveInstance(instanceIDs[i])
        i += 1
    endwhile

    return count - toRemove
EndFunction

Float Function TryExtractLiquidFromContainer(String liquidID, String containerID, Float amount)
    return TryRemoveLiquidFromContainer(liquidID, containerID, amount)
EndFunction

Int Function TryExtractObjectFromContainer(String objectID, String containerID, Int count)
    if !CanExtractObject(objectID, containerID)
        return count
    endif
    return TryRemoveObjectFromContainer(objectID, containerID, count)
EndFunction
