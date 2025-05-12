ScriptName IF_Core_ConfigStorage_Containers extends Quest ;-

String Property DefaultConfigsPath = "IF/Containers/" AutoReadOnly

String Property KEY_NAME = "name" AutoReadOnly
String Property KEY_MIN_CAP = "min_capacity" AutoReadOnly
String Property KEY_MAX_CAP = "max_capacity" AutoReadOnly
String Property KEY_LIM_CAP = "limit_capacity_mod" AutoReadOnly
String Property KEY_MIN_GATE = "min_gate_size" AutoReadOnly
String Property KEY_MAX_GATE = "max_gate_size" AutoReadOnly
String Property KEY_LIM_GATE = "limit_gate_size_mod" AutoReadOnly
String Property KEY_EXT_SPEED = "capacity_extension_speed" AutoReadOnly
String Property KEY_REG_SPEED = "capacity_regeneration_speed" AutoReadOnly
String Property KEY_GATE_EXT = "gate_size_extension_speed" AutoReadOnly
String Property KEY_GATE_REG = "gate_size_regeneration_speed" AutoReadOnly

Int Property ContainerCache Auto

Function Initialize()
    LoadAndCacheContainers()
EndFunction

Function LoadAndCacheContainers()
    ClearCache()
    ContainerCache = JMap.object()

    String[] files = JsonUtil.JsonInFolder(DefaultConfigsPath)
    if files == None
        return
    endif

    int i = 0
    while i < files.Length
        String path = DefaultConfigsPath + files[i]
        String id = JsonUtil.GetStringValue(path, KEY_NAME)

        Int entry = JMap.object()
        JMap.setFlt(entry, KEY_MIN_CAP, JsonUtil.GetFloatValue(path, KEY_MIN_CAP))
        JMap.setFlt(entry, KEY_MAX_CAP, JsonUtil.GetFloatValue(path, KEY_MAX_CAP))
        JMap.setFlt(entry, KEY_LIM_CAP, JsonUtil.GetFloatValue(path, KEY_LIM_CAP))
        JMap.setFlt(entry, KEY_MIN_GATE, JsonUtil.GetFloatValue(path, KEY_MIN_GATE))
        JMap.setFlt(entry, KEY_MAX_GATE, JsonUtil.GetFloatValue(path, KEY_MAX_GATE))
        JMap.setFlt(entry, KEY_LIM_GATE, JsonUtil.GetFloatValue(path, KEY_LIM_GATE))
        JMap.setFlt(entry, KEY_EXT_SPEED, JsonUtil.GetFloatValue(path, KEY_EXT_SPEED))
        JMap.setFlt(entry, KEY_REG_SPEED, JsonUtil.GetFloatValue(path, KEY_REG_SPEED))
        JMap.setFlt(entry, KEY_GATE_EXT, JsonUtil.GetFloatValue(path, KEY_GATE_EXT))
        JMap.setFlt(entry, KEY_GATE_REG, JsonUtil.GetFloatValue(path, KEY_GATE_REG))

        JMap.setObj(ContainerCache, id, entry)
        i += 1
    endwhile
EndFunction

Function ClearCache()
    ContainerCache = 0
EndFunction

Float Function GetContainerFloat(String id, String tKey)
    if ContainerCache == 0
        return 0.0
    endif
    if !JMap.hasKey(ContainerCache, id)
        return 0.0
    endif
    Int entry = JMap.getObj(ContainerCache, id)
    if entry == 0 || !JMap.hasKey(entry, tKey)
        return 0.0
    endif
    return JMap.getFlt(entry, tKey)
EndFunction

Bool Function HasContainer(String id)
    return ContainerCache != 0 && JMap.hasKey(ContainerCache, id)
EndFunction

Int Function GetContainerDataCached(String id)
    if ContainerCache == 0 || !JMap.hasKey(ContainerCache, id)
        return 0
    endif
    return JMap.getObj(ContainerCache, id)
EndFunction

Function RefreshCache()
    LoadAndCacheContainers()
EndFunction

String[] Function GetAllContainerIDs()
    if ContainerCache == 0
        return None
    endif
    return JMap.allKeysPArray(ContainerCache) 
EndFunction

;==============================
; Direct Access Convenience Functions
;==============================
Float Function GetMinCapacity(String id)
    return GetContainerFloat(id, KEY_MIN_CAP)
EndFunction

Float Function GetMaxCapacity(String id)
    return GetContainerFloat(id, KEY_MAX_CAP)
EndFunction

Float Function GetLimitCapacityMod(String id)
    return GetContainerFloat(id, KEY_LIM_CAP)
EndFunction

Float Function GetMinGateSize(String id)
    return GetContainerFloat(id, KEY_MIN_GATE)
EndFunction

Float Function GetMaxGateSize(String id)
    return GetContainerFloat(id, KEY_MAX_GATE)
EndFunction

Float Function GetLimitGateSizeMod(String id)
    return GetContainerFloat(id, KEY_LIM_GATE)
EndFunction

Float Function GetCapacityExtensionSpeed(String id)
    return GetContainerFloat(id, KEY_EXT_SPEED)
EndFunction

Float Function GetCapacityRegenerationSpeed(String id)
    return GetContainerFloat(id, KEY_REG_SPEED)
EndFunction

Float Function GetGateExtensionSpeed(String id)
    return GetContainerFloat(id, KEY_GATE_EXT)
EndFunction

Float Function GetGateRegenerationSpeed(String id)
    return GetContainerFloat(id, KEY_GATE_REG)
EndFunction



;/
    Float maxCapacity = ContainerRef.GetContainerFloat("MyContainer", ContainerRef.KEY_MAX_CAP)
    Float gateExtensionSpeed = ContainerRef.GetContainerFloat("MyContainer", ContainerRef.KEY_GATE_EXT)
/;

;/
    Int data = ContainerRef.GetContainerDataCached("MyContainer")
    if data != 0
        Float minCap = JMap.getFlt(data, ContainerRef.KEY_MIN_CAP)
        Float maxCap = JMap.getFlt(data, ContainerRef.KEY_MAX_CAP)
        Float limitMod = JMap.getFlt(data, ContainerRef.KEY_LIM_CAP)
        Float gateMin = JMap.getFlt(data, ContainerRef.KEY_MIN_GATE)
        Float gateMax = JMap.getFlt(data, ContainerRef.KEY_MAX_GATE)
        Float gateLimit = JMap.getFlt(data, ContainerRef.KEY_LIM_GATE)
        Float extSpeed = JMap.getFlt(data, ContainerRef.KEY_EXT_SPEED)
        Float regSpeed = JMap.getFlt(data, ContainerRef.KEY_REG_SPEED)
        Float gateExt = JMap.getFlt(data, ContainerRef.KEY_GATE_EXT)
        Float gateReg = JMap.getFlt(data, ContainerRef.KEY_GATE_REG)
    endif
/;