ScriptName IF_Core_ConfigStorage_Stats extends Quest ;-

String Property DefaultConfigsPath = "IF/Stats/" AutoReadOnly

String Property KEY_STAT_NAME = "stat_name" AutoReadOnly
String Property KEY_MORPH_PACKS = "morphs_pack_name" AutoReadOnly
String Property KEY_VALUES = "value" AutoReadOnly

IF_Core_ConfigStorage_MorphPacks Property MorphPacks Auto

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
Bool Function HasStat(String id)
    return GetPathIfExists(id) != ""
EndFunction

Int Function GetAllStatIDs_JArray()
    String[] fileList = JsonUtil.JsonInFolder(DefaultConfigsPath)
    if fileList == None
        return 0
    endif

    Int result = JArray.object()
    int i = 0
    while i < fileList.Length
        String path = DefaultConfigsPath + fileList[i]
        String id = JsonUtil.GetStringValue(path, KEY_STAT_NAME)
        JArray.addStr(result, id)
        i += 1
    endwhile

    return result
EndFunction


Int Function GetStatMorphs_JArray(String id)
    String path = GetPathIfExists(id)
    if path == ""
        return 0
    endif

    int morphCount = JsonUtil.StringListCount(path, KEY_MORPH_PACKS)
    int valueCount = JsonUtil.FloatListCount(path, KEY_VALUES)
    int count = morphCount
    if valueCount < morphCount
        count = valueCount
    endif

    Int result = JArray.object()
    int i = 0
    while i < count
        String tMorph = JsonUtil.StringListGet(path, KEY_MORPH_PACKS, i)
        if MorphPacks.HasMorphPack(tMorph)
            JArray.addStr(result, tMorph)
        endif
        i += 1
    endwhile
    return result
EndFunction

Int Function GetStatValues_JArray(String id)
    String path = GetPathIfExists(id)
    if path == ""
        return 0
    endif

    int morphCount = JsonUtil.StringListCount(path, KEY_MORPH_PACKS)
    int valueCount = JsonUtil.FloatListCount(path, KEY_VALUES)
    int count = morphCount
    if valueCount < morphCount
        count = valueCount
    endif

    Int result = JArray.object()
    int i = 0
    while i < count
        String tMorph = JsonUtil.StringListGet(path, KEY_MORPH_PACKS, i)
        if MorphPacks.HasMorphPack(tMorph)
            Float tVal = JsonUtil.FloatListGet(path, KEY_VALUES, i)
            JArray.addFlt(result, tVal)
        endif
        i += 1
    endwhile
    return result
EndFunction
