ScriptName IF_Core_ConfigStorage_Liquids extends Quest ;+

;==============================
; Constants and Properties
;==============================
String Property DefaultConfigsPath = "IF/Liquids/" AutoReadOnly

String Property KEY_NAME = "name" AutoReadOnly
String Property KEY_VOLUME = "volume" AutoReadOnly
String Property KEY_CONTAINERS = "container_name" AutoReadOnly
String Property KEY_MORPH_PACKS = "morphs_pack_name" AutoReadOnly
String Property KEY_VALUES = "value" AutoReadOnly

IF_Core_ConfigStorage_MorphPacks Property MorphPacks Auto
IF_Core_ConfigStorage_Containers Property Containers Auto

Function Initialize()
EndFunction

;==============================
; Utility
;==============================
String Function GetPathIfExists(String id)
    String path = DefaultConfigsPath + id + ".json"
    String[] all = JsonUtil.JsonInFolder(DefaultConfigsPath)
    if all == None
        return ""
    endif

    int i = 0
    while i < all.Length
        if all[i] == id + ".json"
            return path
        endif
        i += 1
    endwhile
    return ""
EndFunction

;==============================
; Access Functions
;==============================
Bool Function HasLiquid(String id)
    return GetPathIfExists(id) != ""
EndFunction

Float Function GetVolume(String id)
    String path = GetPathIfExists(id)
    if path == ""
        return -1.0
    endif
    return JsonUtil.GetFloatValue(path, KEY_VOLUME)
EndFunction

String[] Function GetContainers(String id)
    String path = GetPathIfExists(id)
    if path == ""
        return None
    endif

    int count = JsonUtil.StringListCount(path, KEY_CONTAINERS)
    if count <= 0
        return None
    endif

    String[] result = Utility.CreateStringArray(count)
    int i = 0
    while i < count
        result[i] = JsonUtil.StringListGet(path, KEY_CONTAINERS, i)
        i += 1
    endwhile
    return result
EndFunction

Int Function GetMorphsForContainer_JArray(String id, String containerID)
    String path = GetPathIfExists(id)
    if path == ""
        return 0
    endif

    int count = JsonUtil.StringListCount(path, KEY_CONTAINERS)
    int morphCount = JsonUtil.StringListCount(path, KEY_MORPH_PACKS)

    if count <= 0 || morphCount <= 0
        return 0
    endif

    Int jArrayResult = JArray.object()

    int i = 0
    while i < count && i < morphCount
        String tContainer = JsonUtil.StringListGet(path, KEY_CONTAINERS, i)

        if tContainer == containerID
            String tMorph = JsonUtil.StringListGet(path, KEY_MORPH_PACKS, i)
            JArray.addStr(jArrayResult, tMorph)
        endif
        i += 1
    endwhile

    return jArrayResult
EndFunction

Int Function GetMorphValuesForContainer_JArray(String id, String containerID)
    String path = GetPathIfExists(id)
    if path == ""
        return 0
    endif

    int count = JsonUtil.StringListCount(path, KEY_CONTAINERS)
    int valueCount = JsonUtil.FloatListCount(path, KEY_VALUES)

    if count <= 0 || valueCount <= 0
        return 0
    endif

    Int jArrayResult = JArray.object()

    int i = 0
    while i < count && i < valueCount
        String tContainer = JsonUtil.StringListGet(path, KEY_CONTAINERS, i)

        if tContainer == containerID
            Float tValue = JsonUtil.FloatListGet(path, KEY_VALUES, i)
            JArray.addFlt(jArrayResult, tValue)
        endif
        i += 1
    endwhile

    return jArrayResult
EndFunction

String[] Function GetAllLiquidIDs()
    return JsonUtil.JsonInFolder(DefaultConfigsPath)
EndFunction
