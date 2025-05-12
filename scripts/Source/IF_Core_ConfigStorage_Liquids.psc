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

Int Property LiquidCache Auto
IF_Core_ConfigStorage_MorphPacks Property MorphPacks Auto
IF_Core_ConfigStorage_Containers Property Containers Auto

;==============================
; Initialization and Cache Handling
;==============================
Function Initialize()
    LoadAndCacheLiquids()
EndFunction

Function RefreshCache()
    LoadAndCacheLiquids()
EndFunction

Function ClearCache()
    LiquidCache = 0
EndFunction

Function LoadAndCacheLiquids()
    ClearCache()
    LiquidCache = JMap.object()

    String[] fileList = JsonUtil.JsonInFolder(DefaultConfigsPath)
    if fileList == None
        return
    endif

    int i = 0
    while i < fileList.Length
        String file = fileList[i]
        String path = DefaultConfigsPath + file

        String id = JsonUtil.GetStringValue(path, KEY_NAME)
        Float volume = JsonUtil.GetFloatValue(path, KEY_VOLUME)

        int morphCount = JsonUtil.StringListCount(path, KEY_MORPH_PACKS)
        int valueCount = JsonUtil.FloatListCount(path, KEY_VALUES)
        int containerCount = JsonUtil.StringListCount(path, KEY_CONTAINERS)
        int entryCount = morphCount
        if valueCount < entryCount
            entryCount = valueCount
        endif
        if containerCount < entryCount
            entryCount = containerCount
        endif

        Int tMap = JMap.object()
        JMap.setFlt(tMap, KEY_VOLUME, volume)
        Int containerMap = JMap.object()

        int j = 0
        while j < entryCount
            String tContainer = JsonUtil.StringListGet(path, KEY_CONTAINERS, j)
            String tMorph = JsonUtil.StringListGet(path, KEY_MORPH_PACKS, j)
            Float tValue = JsonUtil.FloatListGet(path, KEY_VALUES, j)

            ;ConsoleUtil.PrintMessage("[IF Core] Liquids Init: tContainer " + tContainer)
            ;ConsoleUtil.PrintMessage("[IF Core] Liquids Init: tMorph " + tMorph)
            ;ConsoleUtil.PrintMessage("[IF Core] Liquids Init: tValue " + tValue)

            
            ;ConsoleUtil.PrintMessage("[IF Core] HasContainer: " + Containers.HasContainer(tContainer) )
            ;ConsoleUtil.PrintMessage("[IF Core] HasMorph Init: " + MorphPacks.HasMorphPack(tMorph))

            if Containers.HasContainer(tContainer) && MorphPacks.HasMorphPack(tMorph)
                
                if !JMap.hasKey(containerMap, tContainer)
                    JMap.setObj(containerMap, tContainer, JMap.object())
                endif
                
                Int entry = JMap.getObj(containerMap, tContainer)


                if !JMap.hasKey(entry, KEY_MORPH_PACKS)
                    JMap.setObj(entry, KEY_MORPH_PACKS, JArray.object())
                endif

                Int morphsArr = JMap.getObj(entry, KEY_MORPH_PACKS)
                JArray.addStr(morphsArr, tMorph)
                JArray.addStr(morphsArr, "")
                JArray.addStr(morphsArr, "123")

                if !JMap.hasKey(entry, KEY_VALUES)
                    JMap.setObj(entry, KEY_VALUES, JArray.object())
                endif

                Int valuesArr = JMap.getObj(entry, KEY_VALUES)
                JArray.addFlt(valuesArr, tValue)                    
                
                ConsoleUtil.PrintMessage("[IF Core] Liquids Init: tContainer " + tContainer)
                ConsoleUtil.PrintMessage("[IF Core] Liquids Init: tMorph " + tMorph)
                ConsoleUtil.PrintMessage("[IF Core] Liquids Init: tValue " + tValue)
                
                ConsoleUtil.PrintMessage("[IF Core] morphsArr obj = " + morphsArr)
                ConsoleUtil.PrintMessage("[IF Core] valuesArr obj = " + valuesArr)

                String[] debugMorphs = JArray.asStringArray(morphsArr)
                Float[] debugValues = JArray.asFloatArray(JMap.getObj(entry, KEY_VALUES))
                ConsoleUtil.PrintMessage("[IF Core] Debug morph count: " + debugMorphs.Length)
                ConsoleUtil.PrintMessage("[IF Core] Debug value count: " + debugValues.Length)
            endif

            j += 1
        endwhile

        JMap.setObj(tMap, "dataByContainer", containerMap)
        JMap.setObj(LiquidCache, id, tMap)

        i += 1
    endwhile
EndFunction

;==============================
; Access Functions
;==============================
Int Function GetLiquidDataCached(String id)
    if LiquidCache == 0 || !JMap.hasKey(LiquidCache, id)
        return 0
    endif
    return JMap.getObj(LiquidCache, id)
EndFunction

Bool Function HasLiquid(String id)
    return LiquidCache != 0 && JMap.hasKey(LiquidCache, id)
EndFunction

Float Function GetVolume(String id)
    Int data = GetLiquidDataCached(id)
    if data == 0
        return -1.0
    endif
    return JMap.getFlt(data, KEY_VOLUME)
EndFunction

String[] Function GetContainers(String id)
    Int data = GetLiquidDataCached(id)
    if data == 0
        return None
    endif
    Int map = JMap.getObj(data, "dataByContainer")
    return JMap.allKeysPArray(map)
EndFunction

String[] Function GetMorphsForContainer(String id, String containerID)
    Int tmap = JMap.getObj(data, "dataByContainer")
    ConsoleUtil.PrintMessage("map = " + tmap)
    ConsoleUtil.PrintMessage("has container: " + JMap.hasKey(tmap, containerID))

    Int data = GetLiquidDataCached(id)
    if data == 0
        return None
    endif
    Int map = JMap.getObj(data, "dataByContainer")
    if !JMap.hasKey(map, containerID)
        return None
    endif
    Int entry = JMap.getObj(map, containerID)
    return JArray.asStringArray(JMap.getObj(entry, KEY_MORPH_PACKS))
EndFunction

Float[] Function GetMorphValuesForContainer(String id, String containerID)
    Int tmap = JMap.getObj(data, "dataByContainer")
    ConsoleUtil.PrintMessage("map = " + tmap)
    ConsoleUtil.PrintMessage("has container: " + JMap.hasKey(tmap, containerID))

    Int data = GetLiquidDataCached(id)
    if data == 0
        return None
    endif
    Int map = JMap.getObj(data, "dataByContainer")
    if !JMap.hasKey(map, containerID)
        return None
    endif
    Int entry = JMap.getObj(map, containerID)
    return JArray.asFloatArray(JMap.getObj(entry, KEY_VALUES))
EndFunction

String[] Function GetAllLiquidIDs()
    if LiquidCache == 0
        return None
    endif
    return JMap.allKeysPArray(LiquidCache)
EndFunction



;/
    IF_Core_ConfigStorage_Liquids configLiquids = SomeReferenceToConfigLiquids

    String tID = "BlackLiquid"

    if configLiquids.HasLiquid(tID)
        ; Получаем объем
        Float volume = configLiquids.GetVolume(tID)

        ; Получаем все контейнеры, в которых она участвует
        String[] containers = configLiquids.GetContainers(tID)
        if containers != None
            int i = 0
            while i < containers.Length
                String container = containers[i]

                ; Получаем список морфов, на которые влияет жидкость в этом контейнере
                String[] morphs = configLiquids.GetMorphsForContainer(tID, container)

                ; Получаем значения влияния этих морфов
                Float[] values = configLiquids.GetMorphValuesForContainer(tID, container)

                ; Выводим в лог
                Debug.Trace("Container: " + container)
                int j = 0
                while morphs != None && values != None && j < morphs.Length && j < values.Length
                    Debug.Trace("  Morph: " + morphs[j] + ", Value: " + values[j])
                    j += 1
                endwhile

                i += 1
            endwhile
        endif
    endif
/;