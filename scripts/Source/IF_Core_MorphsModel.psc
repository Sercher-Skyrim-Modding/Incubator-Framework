ScriptName IF_Core_MorphsModel extends Quest

;==============================
; Dependencies
;==============================
IF_Core_ConfigStorage_Objects    Property ObjectConfigs    Auto  
IF_Core_ConfigStorage_Liquids    Property LiquidConfigs    Auto  
IF_Core_ConfigStorage_Containers Property ContainerConfigs Auto  
IF_Core_ConfigStorage_MorphPacks Property MorphPacksConfig Auto
IF_Core_ConfigStorage_Morphs     Property MorphsConfig     Auto
IF_Core_DataController           Property DataCtrl         Auto  

;==============================
; Cached Contributions
;==============================
Int Property MorphPacksCache Auto Hidden  
Int Property MorphsCache Auto Hidden  

;==============================
; Initialization
;==============================
Function Initialize()
    MorphPacksCache = JMap.object()
    MorphsCache = JMap.object()
EndFunction

;==============================
; Update Cycle
;==============================
Function Update()
    MorphPacksCache = JMap.object()
    MorphsCache = JMap.object()
    UpdateObjectContributions()
    UpdateLiquidContributions()
    ApplyMorphPackToMorphs()
EndFunction

;==============================
; Reset
;==============================
Function Reset()
    MorphPacksCache = JMap.object()
    MorphsCache = JMap.object()
EndFunction

;==============================
; Object Contributions
;==============================
Function UpdateObjectContributions()
    String[] allObjIDs = ObjectConfigs.GetAllObjectIDs()
    if allObjIDs == None
        return
    endif

    int i = 0
    while i < allObjIDs.Length
        String objID = allObjIDs[i]
        String[] confContainers = ObjectConfigs.GetObjectContainers(objID)
        if confContainers != None
            int cCount = confContainers.Length
            int c = 0
            while c < cCount
                String contID = confContainers[c]
                Int objCount = DataCtrl.GetObjectAmountInContainer(objID, contID)
                if objCount > 0
                    String[] morphPacks = ObjectConfigs.GetMorphsForContainer(objID, c)
                    Float[] mods   = ObjectConfigs.GetMorphValuesForContainer(objID, c)
                    int mCount = morphPacks.Length
                    int m = 0
                    while m < mCount
                        Float total = mods[m] * objCount
                        AddToMorphPackCache(morphPacks[m], total)
                        m += 1
                    endwhile
                endif
                c += 1
            endwhile
        endif
        i += 1
    endwhile
EndFunction

;==============================
; Liquid Contributions
;==============================
Function UpdateLiquidContributions()
    String[] allLiqIDs = LiquidConfigs.GetAllLiquidIDs()
    if allLiqIDs == None
        return
    endif

    int i = 0
    while i < allLiqIDs.Length
        String liqID = allLiqIDs[i]
        String[] confContainers = LiquidConfigs.GetContainers(liqID)
        if confContainers != None
            int c = 0
            while c < confContainers.Length
                String contID = confContainers[c]
                Float liqAmount = DataCtrl.GetLiquidAmountInContainer(liqID, contID)
                if liqAmount > 0.0
                    String[] morphPacks = LiquidConfigs.GetMorphsForContainer(liqID, contID)
                    Float[] mods = LiquidConfigs.GetMorphValuesForContainer(liqID, contID)
                    int m = 0
                    while m < morphPacks.Length
                        Float total = mods[m] * liqAmount
                        AddToMorphPackCache(morphPacks[m], total)
                        m += 1
                    endwhile
                endif
                c += 1
            endwhile
        endif
        i += 1
    endwhile
EndFunction

;==============================
; Cache Morph Pack Manipulation
;==============================
Function AddToMorphPackCache(String morphPackName, Float value)
    if !JMap.hasKey(MorphPacksCache, morphPackName)
        JMap.setFlt(MorphPacksCache, morphPackName, value)
    else
        Float prev = JMap.getFlt(MorphPacksCache, morphPackName)
        JMap.setFlt(MorphPacksCache, morphPackName, prev + value)
    endif
EndFunction

;==============================
; Final Morph Calculation
;==============================
Function ApplyMorphPackToMorphs()
    String[] packNames = GetAllMorphPackNames()
    if packNames == None
        return
    endif

    int i = 0
    while i < packNames.Length
        String packID = packNames[i]
        Float packValue = GetMorphPackTotal(packID)

        if MorphPacksConfig.HasMorphPack(packID)
            String[] morphs = MorphPacksConfig.GetMorphNames(packID)
            Float[] mods = MorphPacksConfig.GetMorphModificators(packID)
            int m = 0
            while m < morphs.Length
                String morphID = morphs[m]
                Float mod = mods[m]
                Float rawValue = packValue * mod

                if MorphsConfig.HasMorph(morphID)
                    Float minVal = MorphsConfig.GetMorphFloat(morphID, MorphsConfig.KEY_MIN_VALUE)
                    Float maxVal = MorphsConfig.GetMorphFloat(morphID, MorphsConfig.KEY_MAX_VALUE)
                    Float clamped = rawValue
                    if clamped < minVal
                        clamped = minVal
                    elseif clamped > maxVal
                        clamped = maxVal
                    endif
                    AddToMorphCache(morphID, clamped)
                endif
                m += 1
            endwhile
        endif
        i += 1
    endwhile
EndFunction

;==============================
; Morphs Cache
;==============================
Function AddToMorphCache(String morphID, Float value)
    Float current = 0.0
    if JMap.hasKey(MorphsCache, morphID)
        current = JMap.getFlt(MorphsCache, morphID)
    endif

    Float total = current + value

    if MorphsConfig.HasMorph(morphID)
        Float minVal = MorphsConfig.GetMorphFloat(morphID, MorphsConfig.KEY_MIN_VALUE)
        Float maxVal = MorphsConfig.GetMorphFloat(morphID, MorphsConfig.KEY_MAX_VALUE)

        if total < minVal
            total = minVal
        elseif total > maxVal
            total = maxVal
        endif
    endif

    JMap.setFlt(MorphsCache, morphID, total)
EndFunction

String[] Function GetAllMorphPackNames()
    return JMap.allKeysPArray(MorphPacksCache)
EndFunction

Float[] Function GetAllMorphPackValues()
    String[] keys = GetAllMorphPackNames()
    if keys == None
        return None
    endif

    Int arr = JArray.object()
    int i = 0
    while i < keys.Length
        Float val = JMap.getFlt(MorphPacksCache, keys[i])
        JArray.addFlt(arr, val)
        i += 1
    endwhile

    return JArray.asFloatArray(arr)
EndFunction

Float Function GetMorphPackTotal(String morphPackName)
    if !JMap.hasKey(MorphPacksCache, morphPackName)
        return 0.0
    endif
    return JMap.getFlt(MorphPacksCache, morphPackName)
EndFunction

String[] Function GetAllMorphNames()
    return JMap.allKeysPArray(MorphsCache)
EndFunction

Float Function GetMorphValue(String morphName)
    if !JMap.hasKey(MorphsCache, morphName)
        return 0.0
    endif
    return JMap.getFlt(MorphsCache, morphName)
EndFunction



;/
    IF_Core_MorphsModel model = SomeQuestRef as IF_Core_MorphsModel
    model.Update()

    String[] morphPacks = model.GetAllMorphPackNames()
    Float[] morphPackValues = model.GetAllMorphPackValues()

    ; Получение значения конкретного морфпака
    Float breastPack = model.GetMorphPackTotal("BreastExpansion")

    ; Все морфы
    String[] morphs = model.GetAllMorphNames()

    ; Итоговое значение морфа
    Float hipValue = model.GetMorphValue("Hips")
/;