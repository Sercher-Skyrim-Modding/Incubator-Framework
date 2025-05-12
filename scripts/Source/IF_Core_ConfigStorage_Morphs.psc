ScriptName IF_Core_ConfigStorage_Morphs extends Quest ;-

String Property DefaultConfigsPath = "IF/Morphs/" AutoReadOnly

String Property KEY_NAME = "morph_name" AutoReadOnly
String Property KEY_MAX_VALUE = "max_value" AutoReadOnly
String Property KEY_MIN_VALUE = "min_value" AutoReadOnly

Int MorphCache

Function Initialize()
    LoadAndCacheMorphs()
EndFunction

Function LoadAndCacheMorphs()
    ClearCache()
    MorphCache = JMap.object()

    String[] files = JsonUtil.JsonInFolder(DefaultConfigsPath)
    if files == None
        return
    endif
    
    int i = 0
    while i < files.Length
        String path = DefaultConfigsPath + files[i] 
        String id = JsonUtil.GetStringValue(path, KEY_NAME)

        Int entry = JMap.object()
        JMap.setFlt(entry, KEY_MIN_VALUE, JsonUtil.GetFloatValue(path, KEY_MIN_VALUE))
        JMap.setFlt(entry, KEY_MAX_VALUE, JsonUtil.GetFloatValue(path, KEY_MAX_VALUE))
        JMap.setObj(MorphCache, id, entry)
        i += 1
    endwhile
EndFunction

; External API
Function ClearCache()
    MorphCache = 0
EndFunction

Function RefreshCache()
    LoadAndCacheMorphs()
EndFunction


Float Function GetMorphFloat(String id, String tKey)
    if MorphCache == 0
        return 0.0
    endif
    if !JMap.hasKey(MorphCache, id)
        return 0.0
    endif
    Int entry = JMap.getObj(MorphCache, id)
    if entry == 0 || !JMap.hasKey(entry, tKey)
        return 0.0
    endif
    return JMap.getFlt(entry, tKey)
EndFunction

Bool Function HasMorph(String id)
    if MorphCache == 0
        return false
    endif
    return JMap.hasKey(MorphCache, id)
EndFunction

String[] Function GetAllMorphIDs()
    ConsoleUtil.PrintMessage("[IF Core] Morphs Init: MorphCache id " + MorphCache)
    if MorphCache == 0
        return None
    endif

    ConsoleUtil.PrintMessage("[IF Core] Morphs Init: MorphCache count " + JMap.allKeysPArray(MorphCache).Length)
    return JMap.allKeysPArray(MorphCache) 
EndFunction
