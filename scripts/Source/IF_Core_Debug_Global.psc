Scriptname IF_Core_Debug_Global Hidden

IF_Core_Debug Function Instance() global
    Form questForm = StorageUtil.GetFormValue(None, "IF_Core_Debug_Instance")
    return questForm as IF_Core_Debug
EndFunction


Function getObjectAmount(String objectID, String containerID) global
    if Instance() != None
        Instance().getObjectAmount(objectID, containerID)
    endif
EndFunction

Function getLiquidAmount(String liquidID, String containerID) global
    if Instance() != None
        Instance().getLiquidAmount(liquidID, containerID)
    endif
EndFunction

Function getObjectIDs(String containerID) global
    if Instance() != None
        Instance().getObjectIDs(containerID)
    endif
EndFunction

Function getLiquidIDs(String containerID) global
    if Instance() != None
        Instance().getLiquidIDs(containerID)
    endif
EndFunction

Function getRemainingCap(String containerID) global
    if Instance() != None
        Instance().getRemainingCap(containerID)
    endif
EndFunction

Function getRemainingCapLimit(String containerID) global
    if Instance() != None
        Instance().getRemainingCapLimit(containerID)
    endif
EndFunction

Function addObject(String objectID, String containerID, Int count, Bool includeLimitCapacity) global
    if Instance() != None
        Instance().addObject(objectID, containerID, count, includeLimitCapacity)
    endif
EndFunction

Function insertObject(String objectID, String containerID, Int count, Bool includeLimitCapacity) global
    if Instance() != None
        Instance().insertObject(objectID, containerID, count, includeLimitCapacity)
    endif
EndFunction

Function addLiquid(String liquidID, String containerID, Float amount, Bool includeLimitCapacity) global
    if Instance() != None
        Instance().addLiquid(liquidID, containerID, amount, includeLimitCapacity)
    endif
EndFunction

Function insertLiquid(String liquidID, String containerID, Float amount, Bool includeLimitCapacity) global
    if Instance() != None
        Instance().insertLiquid(liquidID, containerID, amount, includeLimitCapacity)
    endif
EndFunction

Function removeObject(String objectID, String containerID, Int count) global
    if Instance() != None
        Instance().removeObject(objectID, containerID, count)
    endif
EndFunction

Function extractObject(String objectID, String containerID, Int count) global
    if Instance() != None
        Instance().extractObject(objectID, containerID, count)
    endif
EndFunction

Function removeLiquid(String liquidID, String containerID, Float amount) global
    if Instance() != None
        Instance().removeLiquid(liquidID, containerID, amount)
    endif
EndFunction

Function extractLiquid(String liquidID, String containerID, Float amount) global
    if Instance() != None
        Instance().extractLiquid(liquidID, containerID, amount)
    endif
EndFunction

; Configs
Function configsReload() global
    if Instance() != None
        Instance().configsReload()
    endif
EndFunction

Function configsUpdateCaches() global
    if Instance() != None
        Instance().configsUpdateCaches()
    endif
EndFunction

Function configsContainersHas(String id) global
    if Instance() != None
        Instance().configsContainersHas(id)
    endif
EndFunction

Function configsContainersShow(String id) global
    if Instance() != None
        Instance().configsContainersShow(id)
    endif
EndFunction

Function configsContainersShowAll() global
    if Instance() != None
        Instance().configsContainersShowAll()
    endif
EndFunction

Function configsLiquidsHas(String id) global
    if Instance() != None
        Instance().configsLiquidsHas(id)
    endif
EndFunction

Function configsLiquidsShow(String id) global
    if Instance() != None
        Instance().configsLiquidsShow(id)
    endif
EndFunction

Function configsLiquidsShowAll() global
    if Instance() != None
        Instance().configsLiquidsShowAll()
    endif
EndFunction

Function configsObjectsHas(String id) global
    if Instance() != None
        Instance().configsObjectsHas(id)
    endif
EndFunction

Function configsObjectsShow(String id) global
    if Instance() != None
        Instance().configsObjectsShow(id)
    endif
EndFunction

Function configsObjectsShowAll() global
    if Instance() != None
        Instance().configsObjectsShowAll()
    endif
EndFunction

Function configsMorphsHas(String id) global
    if Instance() != None
        Instance().configsMorphsHas(id)
    endif
EndFunction

Function configsMorphsShow(String id) global
    if Instance() != None
        Instance().configsMorphsShow(id)
    endif
EndFunction

Function configsMorphsShowAll() global
    if Instance() != None
        Instance().configsMorphsShowAll()
    endif
EndFunction

Function configsMorphPacksHas(String id) global
    if Instance() != None
        Instance().configsMorphPacksHas(id)
    endif
EndFunction

Function configsMorphPacksShow(String id) global
    if Instance() != None
        Instance().configsMorphPacksShow(id)
    endif
EndFunction

Function configsMorphPacksShowAll() global
    if Instance() != None
        Instance().configsMorphPacksShowAll()
    endif
EndFunction

Function configsStatsHas(String id) global
    if Instance() != None
        Instance().configsStatsHas(id)
    endif
EndFunction

Function configsStatsShow(String id) global
    if Instance() != None
        Instance().configsStatsShow(id)
    endif
EndFunction

Function configsStatsShowAll() global
    if Instance() != None
        Instance().configsStatsShowAll()
    endif
EndFunction

; Data
Function dataReload() global
    if Instance() != None
        Instance().dataReload()
    endif
EndFunction

Function dataUpdateCaches() global
    if Instance() != None
        Instance().dataUpdateCaches()
    endif
EndFunction

Function dataContsSas(String id) global
    if Instance() != None
        Instance().dataContsSas(id)
    endif
EndFunction

Function dataContsShowAll() global
    if Instance() != None
        Instance().dataContsShowAll()
    endif
EndFunction

Function dataContsGetCap(String containerID) global
    if Instance() != None
        Instance().dataContsGetCap(containerID)
    endif
EndFunction

Function dataContsSetCap(String containerID, Float value) global
    if Instance() != None
        Instance().dataContsSetCap(containerID, value)
    endif
EndFunction

Function dataContsGetGate(String containerID) global
    if Instance() != None
        Instance().dataContsGetGate(containerID)
    endif
EndFunction

Function dataContsSetGate(String containerID, Float value) global
    if Instance() != None
        Instance().dataContsSetGate(containerID, value)
    endif
EndFunction

Function dataLiquidsHas(String id) global
    if Instance() != None
        Instance().dataLiquidsHas(id)
    endif
EndFunction

Function dataLiquidsShowAll() global
    if Instance() != None
        Instance().dataLiquidsShowAll()
    endif
EndFunction

Function dataLiquidsGet(String liquidID, String containerID) global
    if Instance() != None
        Instance().dataLiquidsGet(liquidID, containerID)
    endif
EndFunction

Function dataLiquidsSet(String liquidID, String containerID, Float value) global
    if Instance() != None
        Instance().dataLiquidsSet(liquidID, containerID, value)
    endif
EndFunction

Function dataObjectsShowAll() global
    if Instance() != None
        Instance().dataObjectsShowAll()
    endif
EndFunction

Function dataObjectsShow(Int id) global
    if Instance() != None
        Instance().dataObjectsShow(id)
    endif
EndFunction

Function dataObjectsSetProgress(Int instanceID, Float delta) global
    if Instance() != None
        Instance().dataObjectsSetProgress(instanceID, delta)
    endif
EndFunction

Function dataStatsHas(String statID) global
    if Instance() != None
        Instance().dataStatsHas(statID)
    endif
EndFunction

Function dataStatsShowAll() global
    if Instance() != None
        Instance().dataStatsShowAll()
    endif
EndFunction

Function dataStatsGet(String statID) global
    if Instance() != None
        Instance().dataStatsGet(statID)
    endif
EndFunction

Function dataStatsSet(String statID, Float value) global
    if Instance() != None
        Instance().dataStatsSet(statID, value)
    endif
EndFunction
