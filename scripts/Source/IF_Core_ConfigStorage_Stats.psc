ScriptName IF_Core_ConfigStorage_Stats extends Quest ;-

String Property DefaultConfigsPath = "IF/Stats/" AutoReadOnly

String Property KEY_STAT_NAME = "stat_name" AutoReadOnly
String Property KEY_MORPH_PACKS = "morphs_pack_name" AutoReadOnly
String Property KEY_VALUES = "value" AutoReadOnly

Int Property StatCache Auto
IF_Core_ConfigStorage_MorphPacks Property MorphPacks Auto

Function Initialize()
    RefreshCache()
EndFunction

Function RefreshCache()
    ClearCache()
    StatCache = JMap.object()
    String[] fileList = JsonUtil.JsonInFolder(DefaultConfigsPath)
    if fileList == None
        return
    endif

    int i = 0
    while i < fileList.Length
        String fileName = fileList[i]
        String fullPath = DefaultConfigsPath + fileName

        String statID = JsonUtil.GetStringValue(fullPath, KEY_STAT_NAME)
        int morphCount = JsonUtil.StringListCount(fullPath, KEY_MORPH_PACKS)
        int valueCount = JsonUtil.FloatListCount(fullPath, KEY_VALUES)
        int count = morphCount
        if valueCount < morphCount
            count = valueCount
        endif

        Int morphs = JArray.object()
        Int values = JArray.object()

        int j = 0
        while j < count
            String tMorph = JsonUtil.StringListGet(fullPath, KEY_MORPH_PACKS, j)
            Float tVal = JsonUtil.FloatListGet(fullPath, KEY_VALUES, j)
            if MorphPacks.HasMorphPack(tMorph)
                JArray.addStr(morphs, tMorph)
                JArray.addFlt(values, tVal)
            endif
            j += 1
        endwhile

        Int entry = JMap.object()
        JMap.setObj(entry, KEY_MORPH_PACKS, morphs)
        JMap.setObj(entry, KEY_VALUES, values)
        JMap.setObj(StatCache, statID, entry)

        i += 1
    endwhile
EndFunction

Function RefreshCacheExternal()
    RefreshCache()
EndFunction

Function ClearCache()
    StatCache = 0
EndFunction

Bool Function HasStat(String id)
    if StatCache == 0
        return false
    endif
    return JMap.hasKey(StatCache, id)
EndFunction

Int Function GetStatDataCached(String id)
    if StatCache == 0 || !JMap.hasKey(StatCache, id)
        return 0
    endif
    return JMap.getObj(StatCache, id)
EndFunction

String[] Function GetAllStatIDs()
    if StatCache == 0
        return None
    endif
    return JMap.allKeysPArray(StatCache)
EndFunction

String[] Function GetStatMorphs(String id)
    Int data = GetStatDataCached(id)
    if data == 0
        return None
    endif
    return JArray.asStringArray(JMap.getObj(data, KEY_MORPH_PACKS))
EndFunction

Float[] Function GetStatValues(String id)
    Int data = GetStatDataCached(id)
    if data == 0
        return None
    endif
    return JArray.asFloatArray(JMap.getObj(data, KEY_VALUES))
EndFunction


;/
    String[] morphs = ConfigStats.GetStatMorphs("Sanity")
    Float[] values = ConfigStats.GetStatValues("Sanity")

    if morphs != None && values != None
        int count = morphs.Length
        int i = 0
        while i < count
            Debug.Trace("MorphPack: " + morphs[i] + " | Modifier: " + values[i])
            i += 1
        endwhile
    endif
/;