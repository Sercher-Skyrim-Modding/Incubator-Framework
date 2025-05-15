ScriptName IF_Core_ConfigStorage_Objects extends Quest ;+

String Property DefaultConfigsPath = "IF/Objects/" AutoReadOnly
String Property KEY_NAME = "name" AutoReadOnly
String Property KEY_VOLUME = "volume" AutoReadOnly
String Property KEY_SIZE = "size" AutoReadOnly
String Property KEY_INSERTION_SIZE = "insertion_size" AutoReadOnly
String Property KEY_EXTRACTION_SIZE = "extraction_size" AutoReadOnly
String Property KEY_CONTAINERS = "container_name" AutoReadOnly
String Property KEY_MORPH_PACKS = "morphs_pack_name" AutoReadOnly
String Property KEY_VALUES = "value" AutoReadOnly

IF_Core_ConfigStorage_Morphs Property Morphs Auto
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
Bool Function HasObject(String id)
    return GetPathIfExists(id) != ""
EndFunction

Int Function GetAllObjectIDs_JArray()
    String[] fileList = JsonUtil.JsonInFolder(DefaultConfigsPath)
    if fileList == None
        return 0
    endif

    Int result = JArray.object()
    int i = 0
    while i < fileList.Length
        String path = DefaultConfigsPath + fileList[i]
        String id = JsonUtil.GetStringValue(path, KEY_NAME)
        JArray.addStr(result, id)
        i += 1
    endwhile

    return result
EndFunction


Float Function GetVolume(String id)
    String path = GetPathIfExists(id)
    if path == ""
        return 0.0
    endif
    return JsonUtil.GetFloatValue(path, KEY_VOLUME)
EndFunction

Float Function GetSize(String id)
    String path = GetPathIfExists(id)
    if path == ""
        return 0.0
    endif
    return JsonUtil.GetFloatValue(path, KEY_SIZE)
EndFunction

Float Function GetInsertionSize(String id)
    String path = GetPathIfExists(id)
    if path == ""
        return 0.0
    endif
    return JsonUtil.GetFloatValue(path, KEY_INSERTION_SIZE)
EndFunction

Float Function GetExtractionSize(String id)
    String path = GetPathIfExists(id)
    if path == ""
        return 0.0
    endif
    return JsonUtil.GetFloatValue(path, KEY_EXTRACTION_SIZE)
EndFunction

String[] Function GetObjectContainers(String id)
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

    int containerCount = JsonUtil.StringListCount(path, KEY_CONTAINERS)
    int morphCount = JsonUtil.StringListCount(path, KEY_MORPH_PACKS)
    if containerCount <= 0 || morphCount <= 0
        return 0
    endif

    Int result = JArray.object()
    int i = 0
    while i < containerCount && i < morphCount
        String tContainer = JsonUtil.StringListGet(path, KEY_CONTAINERS, i)
        if tContainer == containerID
            String tMorph = JsonUtil.StringListGet(path, KEY_MORPH_PACKS, i)
            JArray.addStr(result, tMorph)
        endif
        i += 1
    endwhile
    return result
EndFunction

Int Function GetMorphValuesForContainer_JArray(String id, String containerID)
    String path = GetPathIfExists(id)
    if path == ""
        return 0
    endif

    int containerCount = JsonUtil.StringListCount(path, KEY_CONTAINERS)
    int valueCount = JsonUtil.FloatListCount(path, KEY_VALUES)
    if containerCount <= 0 || valueCount <= 0
        return 0
    endif

    Int result = JArray.object()
    int i = 0
    while i < containerCount && i < valueCount
        String tContainer = JsonUtil.StringListGet(path, KEY_CONTAINERS, i)
        if tContainer == containerID
            Float tValue = JsonUtil.FloatListGet(path, KEY_VALUES, i)
            JArray.addFlt(result, tValue)
        endif
        i += 1
    endwhile
    return result
EndFunction
