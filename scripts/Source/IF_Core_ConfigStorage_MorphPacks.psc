ScriptName IF_Core_ConfigStorage_MorphPacks extends Quest ;-

String Property DefaultConfigsPath = "IF/MorphPacks/" AutoReadOnly

String Property KEY_PACK_NAME = "morphs_pack_name" AutoReadOnly
String Property KEY_NAMES = "packs_names" AutoReadOnly
String Property KEY_VALUES = "packs_modificators" AutoReadOnly

Int Property MorphPackCache Auto
IF_Core_ConfigStorage_Morphs Property Morphs Auto

Function Initialize()
    LoadAndCacheMorphPacks()
EndFunction

Function RefreshCache()
    LoadAndCacheMorphPacks()
EndFunction

Function LoadAndCacheMorphPacks()
    ClearCache()
    MorphPackCache = JMap.object()

    String[] fileList = JsonUtil.JsonInFolder(DefaultConfigsPath)
    if fileList == None
        return
    endif

    int i = 0
    while i < fileList.Length
        String path = DefaultConfigsPath + fileList[i]
        String id = JsonUtil.GetStringValue(path, KEY_PACK_NAME)

        int countNames = JsonUtil.StringListCount(path, KEY_NAMES)
        int countValues = JsonUtil.FloatListCount(path, KEY_VALUES)
        int count = countNames
        if countValues < count
            count = countValues
        endif

        Int morphNames = JArray.object()
        Int maxValues = JArray.object()

        int j = 0
        while j < count
            String morphName = JsonUtil.StringListGet(path, KEY_NAMES, j)
            Float maxValue = JsonUtil.FloatListGet(path, KEY_VALUES, j)

            if Morphs.HasMorph(morphName)
                JArray.addStr(morphNames, morphName)
                JArray.addFlt(maxValues, maxValue)
            endif
            j += 1
        endwhile

        Int entry = JMap.object()
        JMap.setStr(entry, KEY_PACK_NAME, id)
        JMap.setObj(entry, KEY_NAMES, morphNames)
        JMap.setObj(entry, KEY_VALUES, maxValues)

        JMap.setObj(MorphPackCache, id, entry)
        i += 1
    endwhile
EndFunction

Function ClearCache()
    MorphPackCache = 0
EndFunction

Bool Function HasMorphPack(String id)
    return MorphPackCache != 0 && JMap.hasKey(MorphPackCache, id)
EndFunction

Int Function GetPackDataCached(String id)
    if MorphPackCache == 0 || !JMap.hasKey(MorphPackCache, id)
        return 0
    endif
    return JMap.getObj(MorphPackCache, id)
EndFunction

String[] Function GetAllPackIDs()
    if MorphPackCache == 0
        return None
    endif
    return JMap.allKeysPArray(MorphPackCache)
EndFunction

String[] Function GetMorphNames(String id)
    Int entry = GetPackDataCached(id)
    if entry == 0
        return None
    endif
    return JArray.asStringArray(JMap.getObj(entry, KEY_NAMES))
EndFunction

Float[] Function GetMorphModificators(String id)
    Int entry = GetPackDataCached(id)
    if entry == 0
        return None
    endif
    return JArray.asFloatArray(JMap.getObj(entry, KEY_VALUES))
EndFunction

Int Function GetMorphCount(String id)
    Int entry = GetPackDataCached(id)
    if entry == 0
        return 0
    endif
    return JArray.count(JMap.getObj(entry, KEY_NAMES))
EndFunction
