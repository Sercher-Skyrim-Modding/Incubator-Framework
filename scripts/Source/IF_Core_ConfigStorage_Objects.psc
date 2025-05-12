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

Int Property ObjectCache Auto
IF_Core_ConfigStorage_Morphs Property Morphs Auto
IF_Core_ConfigStorage_Containers Property Containers Auto

Function Initialize()
    RefreshCache()
EndFunction

Function RefreshCache()
    ClearCache()
    ObjectCache = JMap.object()
    String[] files = JsonUtil.JsonInFolder(DefaultConfigsPath)
    if files == None
        return
    endif

    int i = 0
    while i < files.Length
        String path = DefaultConfigsPath + files[i]
        String id = JsonUtil.GetStringValue(path, KEY_NAME)

        Float volume = JsonUtil.GetFloatValue(path, KEY_VOLUME)
        Float size = JsonUtil.GetFloatValue(path, KEY_SIZE)
        Float insertionSize = JsonUtil.GetFloatValue(path, KEY_INSERTION_SIZE)
        Float extractionSize = JsonUtil.GetFloatValue(path, KEY_EXTRACTION_SIZE)

        int containerCount = JsonUtil.StringListCount(path, KEY_CONTAINERS)
        int morphCount = JsonUtil.StringListCount(path, KEY_MORPH_PACKS)
        int valueCount = JsonUtil.FloatListCount(path, KEY_VALUES)
        int morphLimit = morphCount

        if valueCount < morphCount
            morphLimit = valueCount
        endif

        Int containerList = JArray.object()
        Int dataList = JArray.object()

        int j = 0
        while j < containerCount
            String tContainer = JsonUtil.StringListGet(path, KEY_CONTAINERS, j)
            if Containers.HasContainer(tContainer)
                Int morphNames = JArray.object()
                Int morphValues = JArray.object()

                int m = j
                while m < morphLimit
                    String morph = JsonUtil.StringListGet(path, KEY_MORPH_PACKS, m)
                    Float val = JsonUtil.FloatListGet(path, KEY_VALUES, m)
                    if Morphs.HasMorph(morph)
                        JArray.addStr(morphNames, morph)
                        JArray.addFlt(morphValues, val)
                    endif
                    m += containerCount
                endwhile

                JArray.addStr(containerList, tContainer)

                Int data = JMap.object()
                JMap.setObj(data, KEY_MORPH_PACKS, morphNames)
                JMap.setObj(data, KEY_VALUES, morphValues)
                JArray.addObj(dataList, data)
            endif
            j += 1
        endwhile

        Int entry = JMap.object()
        JMap.setFlt(entry, KEY_VOLUME, volume)
        JMap.setFlt(entry, KEY_SIZE, size)
        JMap.setFlt(entry, KEY_INSERTION_SIZE, insertionSize)
        JMap.setFlt(entry, KEY_EXTRACTION_SIZE, extractionSize)
        JMap.setObj(entry, KEY_CONTAINERS, containerList)
        JMap.setObj(entry, "dataByContainer", dataList)
        JMap.setObj(ObjectCache, id, entry)

        i += 1
    endwhile
EndFunction

Function ClearCache()
    ObjectCache = 0
EndFunction

Function RefreshCacheExternal()
    RefreshCache()
EndFunction

Bool Function HasObject(String id)
    if ObjectCache == 0
        return false
    endif
    return JMap.hasKey(ObjectCache, id)
EndFunction

Int Function GetObjectDataCached(String id)
    if ObjectCache == 0 || !JMap.hasKey(ObjectCache, id)
        return 0
    endif
    return JMap.getObj(ObjectCache, id)
EndFunction

String[] Function GetAllObjectIDs()
    if ObjectCache == 0
        return None
    endif
    return JMap.allKeysPArray(ObjectCache)
EndFunction

Float Function GetVolume(String id)
    Int entry = GetObjectDataCached(id)
    if entry == 0
        return 0.0
    endif
    return JMap.getFlt(entry, KEY_VOLUME)
EndFunction

Float Function GetSize(String id)
    Int entry = GetObjectDataCached(id)
    if entry == 0
        return 0.0
    endif
    return JMap.getFlt(entry, KEY_SIZE)
EndFunction

Float Function GetInsertionSize(String id)
    Int entry = GetObjectDataCached(id)
    if entry == 0
        return 0.0
    endif
    return JMap.getFlt(entry, KEY_INSERTION_SIZE)
EndFunction

Float Function GetExtractionSize(String id)
    Int entry = GetObjectDataCached(id)
    if entry == 0
        return 0.0
    endif
    return JMap.getFlt(entry, KEY_EXTRACTION_SIZE)
EndFunction

String[] Function GetObjectContainers(String id)
    Int entry = GetObjectDataCached(id)
    if entry == 0
        return None
    endif
    return JArray.asStringArray(JMap.getObj(entry, KEY_CONTAINERS))
EndFunction

Int Function GetDataByContainer(String id)
    Int entry = GetObjectDataCached(id)
    if entry == 0
        return 0
    endif
    return JMap.getObj(entry, "dataByContainer")
EndFunction

String[] Function GetMorphsForContainer(String id, int index)
    Int containerData = GetDataByContainer(id)
    if containerData == 0
        return None
    endif
    Int data = JArray.getObj(containerData, index)
    return JArray.asStringArray(JMap.getObj(data, KEY_MORPH_PACKS))
EndFunction

Float[] Function GetMorphValuesForContainer(String id, int index)
    Int containerData = GetDataByContainer(id)
    if containerData == 0
        return None
    endif
    Int data = JArray.getObj(containerData, index)
    return JArray.asFloatArray(JMap.getObj(data, KEY_VALUES))
EndFunction


;/
    String tID = "BlackCube"

    if IF_Core_ConfigStorage_Objects.HasObject(tID)
        Float volume = IF_Core_ConfigStorage_Objects.GetVolume(tID)
        Float size = IF_Core_ConfigStorage_Objects.GetSize(tID)
        Float insertionSize = IF_Core_ConfigStorage_Objects.GetInsertionSize(tID)
        Float extractionSize = IF_Core_ConfigStorage_Objects.GetExtractionSize(tID)

        String[] tContainers = IF_Core_ConfigStorage_Objects.GetObjectContainers(tID)
        int count = tContainers.Length
        int i = 0
        while i < count
            String containerName = tContainers[i]
            String[] morphs = IF_Core_ConfigStorage_Objects.GetMorphsForContainer(tID, i)
            Float[] values = IF_Core_ConfigStorage_Objects.GetMorphValuesForContainer(tID, i)

            Debug.Trace("Container: " + containerName)
            int j = 0
            while j < morphs.Length
                Debug.Trace("  Morph: " + morphs[j] + " Value: " + values[j])
                j += 1
            endwhile
            i += 1
        endwhile
    endif
/;