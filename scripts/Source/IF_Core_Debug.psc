ScriptName IF_Core_Debug extends Quest

; ===============================
; References
; ===============================
    IF_Core_DataController              Property DataController Auto
        
    IF_Core_ConfigManager               Property ConfigManager Auto
    IF_Core_ConfigStorage_Containers    Property ConfigStorage_Containers Auto
    IF_Core_ConfigStorage_Liquids       Property ConfigStorage_Liquids Auto
    IF_Core_ConfigStorage_Objects       Property ConfigStorage_Objects Auto
    IF_Core_ConfigStorage_Morphs        Property ConfigStorage_Morphs Auto
    IF_Core_ConfigStorage_MorphPacks    Property ConfigStorage_MorphPacks Auto
    IF_Core_ConfigStorage_Stats         Property ConfigStorage_Stats Auto

                
    IF_Core_DataManager                 Property DataManager Auto
    IF_Core_DataStorage_Stats           Property DataStorage_Stats Auto
    IF_Core_DataStorage_Objects         Property DataStorage_Objects Auto
    IF_Core_DataStorage_Liquids         Property DataStorage_Liquids Auto
    IF_Core_DataStorage_Containers      Property DataStorage_Containers Auto


Event OnInit()
    StorageUtil.SetFormValue(None, "IF_Core_Debug_Instance", Self)
EndEvent

; ==============================
; === Debug Logging ===
; ==============================
Function Log(String tMessage)
    ConsoleUtil.PrintMessage("[IF Debug] " + tMessage)
EndFunction


; ==============================
; === Data Controller ===
; ==============================

Function getObjectAmount(String objectID, String containerID)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    int count = DataController.GetObjectAmountInContainer(objectID, containerID)
    Log((count as String) + " " + objectID + " are stored in " + containerID)
EndFunction

Function getLiquidAmount(String liquidID, String containerID)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    Float amount = DataController.GetLiquidAmountInContainer(liquidID, containerID)
    Log((amount as String) + " " + liquidID + " are stored in " + containerID)
EndFunction


Function getObjectIDs(String containerID)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] objectsIDs = DataController.GetAllLiquidIDsInContainer(containerID)
    int i = 0
    while (i < objectsIDs.Length)
        Log((objectsIDs[i] as String) + " is stored in " + containerID)
        i += 1
    endwhile
EndFunction

Function getLiquidIDs(String containerID)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] liquidIDs = DataController.GetAllObjectIDsInContainer(containerID)
    int i = 0
    while (i < liquidIDs.Length)
        Log((liquidIDs[i] as String) + " is stored in " + containerID)
        i += 1
    endwhile
EndFunction


Function getRemainingCap(String containerID)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    Float capacity = DataController.GetRemainingContainerCapacity(containerID)
    Log((capacity as String) + " capacity left in the " + containerID)
EndFunction

Function getRemainingCapLimit(String containerID)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    Float capacity = DataController.GetRemainingContainerCapacityWithLimit(containerID)
    Log((capacity as String) + " limit-capacity left in the " + containerID)
EndFunction


Function addObject(String objectID, String containerID, Int count, Bool includeLimitCapacity)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    int remainingCount = DataController.TryAddObjectToContainer(objectID, containerID, count, includeLimitCapacity)

    if (count == remainingCount)
        Log("Failed to add " + (count as String) + " " + objectID + " to the " + containerID)
    else 
        Log(((count - remainingCount) as String) + " " + objectID + " were added to the " + containerID + ". " + (remainingCount as String) + " was returned")
    endif     
EndFunction

Function insertObject(String objectID, String containerID, Int count, Bool includeLimitCapacity)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    int remainingCount = DataController.TryInsertObjectToContainer(objectID, containerID, count, includeLimitCapacity)

    if (count == remainingCount)
        Log("Failed to insert " + (count as String) + " " + objectID + " to the " + containerID)
    else 
        Log(((count - remainingCount) as String) + " " + objectID + " were inserted to the " + containerID + ". " + (remainingCount as String) + " was returned")
    endif    
EndFunction


Function addLiquid(String liquidID, String containerID, Float amount, Bool includeLimitCapacity)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    Float remaining = DataController.TryAddLiquidToContainer(liquidID, containerID, amount, includeLimitCapacity)

    if (amount == remaining)
        Log("Failed to add " + (amount as String) + " " + liquidID + " to the " + containerID)
    else 
        Log(((amount - remaining) as String) + " " + liquidID + " were added to the " + containerID + ". " + (remaining as String) + " was returned")
    endif    
EndFunction

Function insertLiquid(String liquidID, String containerID, Float amount, Bool includeLimitCapacity)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    Float remaining = DataController.TryAddLiquidToContainer(liquidID, containerID, amount, includeLimitCapacity)

    if (amount == remaining)
        Log("Failed to insert " + (amount as String) + " " + liquidID + " to the " + containerID)
    else 
        Log(((amount - remaining) as String) + " " + liquidID + " were inserted to the " + containerID + ". " + (remaining as String) + " was returned")
    endif    
EndFunction


Function removeObject(String objectID, String containerID, Int count)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    int notRemoved = DataController.TryRemoveObjectFromContainer(objectID, containerID, count)

    if (count == notRemoved)
        Log("Failed to remove " + (count as String) + " " + objectID + " from the " + containerID)
    else 
        Log(((count - notRemoved) as String) + " " + objectID + " were removed from the " + containerID + ". " + (notRemoved as String) + " failed to remove")
    endif     
EndFunction

Function extractObject(String objectID, String containerID, Int count)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    int notExtracted = DataController.TryExtractObjectFromContainer(objectID, containerID, count)

    if (count == notExtracted)
        Log("Failed to extract " + (count as String) + " " + objectID + " from the " + containerID)
    else 
        Log(((count - notExtracted) as String) + " " + objectID + " were extracted from the " + containerID + ". " + (notExtracted as String) + " failed to extract")
    endif    
EndFunction


Function removeLiquid(String liquidID, String containerID, Float amount)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    Float notRemoved = DataController.TryRemoveLiquidFromContainer(liquidID, containerID, amount)  

    if (amount == notRemoved)
        Log("Failed to remove " + (amount as String) + " " + liquidID + " from the " + containerID)
    else 
        Log(((amount - notRemoved) as String) + " " + liquidID + " were removed from the " + containerID + ". " + (notRemoved as String) + " failed to remove")
    endif  
EndFunction

Function extractLiquid(String liquidID, String containerID, Float amount)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    Float notExtracted = DataController.TryExtractLiquidFromContainer(liquidID, containerID, amount)

    if (amount == notExtracted)
        Log("Failed to extract " + (amount as String) + " " + liquidID + " from the " + containerID)
    else 
        Log(((amount - notExtracted) as String) + " " + liquidID + " were extracted from the " + containerID + ". " + (notExtracted as String) + " failed to extract")
    endif    
EndFunction



; ==============================
; === Configs ===
; ==============================

Function configsReload()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    Log("All Configs was reloaded!")
EndFunction

Function configsUpdateCaches()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    ConfigManager.RefreshAllCaches()
    Log("All Config's caches have been updated!")
EndFunction


Function configsContainersHas(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    bool has = ConfigStorage_Containers.HasContainer(id)
    if (has)
        Log(id + " was found in configs.") 
    else
        Log(id + " was not found in configs.") 
    endif  
EndFunction

Function configsContainersShow(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    if (ConfigStorage_Containers.HasContainer(id))
        Log("== " + id + " ======================")
        Log("Min Capacity: "                    + ConfigStorage_Containers.GetMinCapacity(id))
        Log("Max Capacity: "                    + ConfigStorage_Containers.GetMaxCapacity(id))
        Log("Limit Capacity Mod: "              + ConfigStorage_Containers.GetLimitCapacityMod(id))
        Log("Min Gate Size: "                   + ConfigStorage_Containers.GetMinGateSize(id))
        Log("Max Gate Size: "                   + ConfigStorage_Containers.GetMaxGateSize(id))
        Log("Limit Gate Size Mod: "             + ConfigStorage_Containers.GetLimitGateSizeMod(id))
        Log("Capacity Extension Speed: "        + ConfigStorage_Containers.GetCapacityExtensionSpeed(id))
        Log("Capacity Regeneration Speed: "     + ConfigStorage_Containers.GetCapacityRegenerationSpeed(id))
        Log("Gate Size Extension Speed: "       + ConfigStorage_Containers.GetGateExtensionSpeed(id))
        Log("Gate Size Regeneration Speed: "    + ConfigStorage_Containers.GetGateRegenerationSpeed(id))
        Log("====================================")
    else
        Log(id + " was not found in configs.") 
    endif
EndFunction

Function configsContainersShowAll()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] containerIDs = ConfigStorage_Containers.GetAllContainerIDs()
    int i = 0
    while (i < containerIDs.Length)
        Log((containerIDs[i] as String) + " was found in configs.") 
        i += 1
    endwhile
EndFunction


Function configsLiquidsHas(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    bool has = ConfigStorage_Liquids.HasLiquid(id)
    if (has)
        Log(id + " was found in configs.") 
    else
        Log(id + " was not found in configs.") 
    endif  
EndFunction

Function configsLiquidsShow(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    if (ConfigStorage_Liquids.HasLiquid(id))
        Log("== " + id + " ======================")
        Log("Volume: " + ConfigStorage_Liquids.GetVolume(id))
        
        String[] tContainers = ConfigStorage_Liquids.GetContainers(id)
        
        if tContainers != None
            int i = 0
            while i < tContainers.Length
                String tContainer = tContainers[i]
                Int morphs = ConfigStorage_Liquids.GetMorphsForContainer_JArray(id, tContainer)
                Int values = ConfigStorage_Liquids.GetMorphValuesForContainer_JArray(id, tContainer)

                ;Log("morphs getStr " + jArray.getStr(morphs, 0))
                ;Log("values getStr " + jArray.getFlt(values, 0))

                Log("= " + tContainer + " ==========")
                int j = 0
                while morphs != 0 && values != 0 && j < jArray.count(morphs) && j < jArray.count(values)
                    Log("MorphPack: " + jArray.getStr(morphs, j, "null") + ", Value: " + jArray.getFlt(values, j, 0.0))
                    j += 1
                endwhile
                i += 1
            endwhile
        endif
        Log("====================================")
    else
        Log(id + " was not found in configs.") 
    endif
EndFunction

Function configsLiquidsShowAll()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    int liquidIDs = ConfigStorage_Liquids.GetAllLiquidIDs_JArray()
    int i = 0
    while (i < jArray.count(liquidIDs))
        Log(jArray.getStr(liquidIDs, i, "null") + " was found in configs.") 
        i += 1
    endwhile
EndFunction


Function configsObjectsHas(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    bool has = ConfigStorage_Objects.HasObject(id)
    if (has)
        Log(id + " was found in configs.") 
    else
        Log(id + " was not found in configs.") 
    endif  
EndFunction

Function configsObjectsShow(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    if (ConfigStorage_Objects.HasObject(id))
        Log("== " + id + " ======================")
        Log("Volume: "          + ConfigStorage_Objects.GetVolume(id))
        Log("Size: "            + ConfigStorage_Objects.GetSize(id))
        Log("Insertion Size: "   + ConfigStorage_Objects.GetInsertionSize(id))
        Log("Extraction Size: "  + ConfigStorage_Objects.GetExtractionSize(id))
        
        String[] tContainers = ConfigStorage_Objects.GetObjectContainers(id)
        if tContainers != None
            int i = 0
            while i < tContainers.Length
                String tContainer = tContainers[i]
                Int morphs = ConfigStorage_Objects.GetMorphsForContainer_JArray(id, tContainer)
                Int values = ConfigStorage_Objects.GetMorphValuesForContainer_JArray(id, tContainer)

                ;Log("morphs getStr " + jArray.getStr(morphs, 0))
                ;Log("values getStr " + jArray.getFlt(values, 0))

                Log("= " + tContainer + " ==========")
                int j = 0
                while morphs != 0 && values != 0 && j < jArray.count(morphs) && j < jArray.count(values)
                    Log("MorphPack: " + jArray.getStr(morphs, j, "null") + ", Value: " + jArray.getFlt(values, j, 0.0))
                    j += 1
                endwhile
                i += 1
            endwhile
        endif
        Log("====================================")
    else
        Log(id + " was not found in configs.") 
    endif
EndFunction

Function configsObjectsShowAll()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] objectIDs = ConfigStorage_Objects.GetAllObjectIDs()
    int i = 0
    while (i < objectIDs.Length)
        Log((objectIDs[i] as String) + " was found in configs.") 
        i += 1
    endwhile
EndFunction


Function configsMorphsHas(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    bool has = ConfigStorage_Morphs.HasMorph(id)
    if (has)
        Log(id + " was found in configs.") 
    else
        Log(id + " was not found in configs.") 
    endif  
EndFunction

Function configsMorphsShow(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    if (ConfigStorage_Morphs.HasMorph(id))
        Log("== " + id + " ======================")
        Log("Min Value: "   + ConfigStorage_Morphs.GetMorphFloat(id, ConfigStorage_Morphs.KEY_MIN_VALUE))
        Log("Max Value: "   + ConfigStorage_Morphs.GetMorphFloat(id, ConfigStorage_Morphs.KEY_MAX_VALUE))
        Log("====================================")
    else
        Log(id + " was not found in configs.") 
    endif
EndFunction

Function configsMorphsShowAll()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] morphIDs = ConfigStorage_Morphs.GetAllMorphIDs()
    int i = 0
    while (i < morphIDs.Length)
        Log((morphIDs[i] as String) + " was found in configs.") 
        i += 1
    endwhile
EndFunction


Function configsMorphPacksHas(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    bool has = ConfigStorage_MorphPacks.HasMorphPack(id)
    if (has)
        Log(id + " was found in configs.") 
    else
        Log(id + " was not found in configs.") 
    endif  
EndFunction

Function configsMorphPacksShow(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    if (ConfigStorage_MorphPacks.HasMorphPack(id))
        Log("== " + id + " ======================")
        
        String[] tMorphs = ConfigStorage_MorphPacks.GetMorphNames(id)
        Float[] tMods = ConfigStorage_MorphPacks.GetMorphModificators(id)
        
        if tMorphs != None
            int i = 0
            while i < tMorphs.Length
                String tMorph = tMorphs[i]
                Float tMod = tMods[i]
                Log("Morph: " + tMorph + ", Mod: " + tMod)
                i += 1
            endwhile
        endif
        Log("====================================")
    else
        Log(id + " was not found in configs.") 
    endif

    Log("")
EndFunction

Function configsMorphPacksShowAll()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] packIDs = ConfigStorage_MorphPacks.GetAllPackIDs()
    int i = 0
    while (i < packIDs.Length)
        Log((packIDs[i] as String) + " was found in configs.") 
        i += 1
    endwhile
EndFunction


Function configsStatsHas(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    bool has = ConfigStorage_Stats.HasStat(id)
    if (has)
        Log(id + " was found in configs.") 
    else
        Log(id + " was not found in configs.") 
    endif  
EndFunction

Function configsStatsShow(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    if (ConfigStorage_Stats.HasStat(id))
        Log("== " + id + " ======================")
        
        Int morphs = ConfigStorage_Stats.GetStatMorphs_JArray(id)
        Int values = ConfigStorage_Stats.GetStatValues_JArray(id)
        
        int j = 0
        while morphs != 0 && values != 0 && j < jArray.count(morphs) && j < jArray.count(values)
            Log("MorphPack: " + jArray.getStr(morphs, j, "null") + ", Value: " + jArray.getFlt(values, j, 0.0))
            j += 1
        endwhile
        
        Log("====================================")
    else
        Log(id + " was not found in configs.") 
    endif
EndFunction

Function configsStatsShowAll()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] statIDs = ConfigStorage_Stats.GetAllStatIDs()
    int i = 0
    while (i < statIDs.Length)
        Log((statIDs[i] as String) + " was found in configs.") 
        i += 1
    endwhile
EndFunction



; ==============================
; === Data ===
; ==============================

Function dataReload()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    DataManager.Initialize()
    Log("All Data was reinitialized!")
EndFunction

Function dataUpdateCaches()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    DataManager.UpdateAllCaches()
    Log("All Data's caches have been updated!")
EndFunction



Function dataContsHas(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    bool has = DataStorage_Containers.HasContainerID(id)
    if (has)
        Log(id + " was found in data.") 
    else
        Log(id + " was not found in data.") 
    endif  
EndFunction

Function dataContsShowAll()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] containerIDs = DataStorage_Containers.GetAllContainerIDs()
    int i = 0
    while (i < containerIDs.Length)
        Log((containerIDs[i] as String) + " was found in data.") 
        i += 1
    endwhile
EndFunction

Function dataContsGetCap(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    if (DataStorage_Containers.HasContainerID(id))
        Log("== " + id + " ======================")
        Log("Current Capacity: "        + DataStorage_Containers.GetCapacity(id))
        Log("Current Capacity Cashed: " + DataStorage_Containers.GetCapacity_Cached(id))
        Log("====================================")
    else
        Log(id + " was not found in data.") 
    endif
EndFunction

Function dataContsSetCap(String id, Float value)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 
    
    if (DataStorage_Containers.HasContainerID(id))
        DataStorage_Containers.SetCapacity(id, value)
        Log(id + " capacity was set to " + value) 
    else
        Log(id + " was not found in data.") 
    endif
EndFunction

Function dataContsGetGate(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    if (DataStorage_Containers.HasContainerID(id))
        Log("== " + id + " ======================")
        Log("Current Gate Size: "        + DataStorage_Containers.GetGateSize(id))
        Log("Current Gate Size Cashed: " + DataStorage_Containers.GetGateSize_Cached(id))
        Log("====================================")
    else
        Log(id + " was not found in data.") 
    endif
EndFunction

Function dataContsSetGate(String id, Float value)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 
    
    if (DataStorage_Containers.HasContainerID(id))
        DataStorage_Containers.SetGateSize(id, value)
        Log(id + " gase size was set to " + value) 
    else
        Log(id + " was not found in data.") 
    endif
EndFunction



Function dataLiquidsHas(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    bool has = DataStorage_Liquids.HasLiquidID(id)
    if (has)
        Log(id + " was found in data.") 
    else
        Log(id + " was not found in data.") 
    endif  
EndFunction

Function dataLiquidsShowAll()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] liquidIDs = DataStorage_Liquids.GetAllLiquidIDs()
    int i = 0
    while (i < liquidIDs.Length)
        Log((liquidIDs[i] as String) + " was found in data.") 
        i += 1
    endwhile
EndFunction

Function dataLiquidsGet(String id, String containerID)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    if (DataStorage_Liquids.HasLiquidID(id))
        Log("=== " + id + " ---> " + containerID + " ===")
        Log("Current Amount: "        + DataStorage_Liquids.GetAmount(id, containerID))
        Log("====================================")
    else
        Log(id + " was not found in " + containerID) 
    endif
EndFunction

Function dataLiquidsSet(String id, String containerID, Float value)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 
    
    if (DataStorage_Liquids.HasLiquidID(id))
        DataStorage_Liquids.SetAmount(id, containerID, value)
        Log(value + " " + id + " was set to " + value) 
    else
        Log(id + " was not found in data.") 
    endif
EndFunction



Function dataObjectsShowAll()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] objIDs = DataStorage_Objects.GetAllInstanceIDs()
    int i = 0
    while (i < objIDs.Length)
        Log((objIDs[i] as String) + " was found in data.") 
        i += 1
    endwhile
EndFunction

Function dataObjectsShow(Int id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    Log("")
EndFunction

Function dataObjectsSetProgress(Int instanceID, Float delta)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    Log("")
EndFunction



Function dataStatsHas(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    bool has = DataStorage_Stats.HasStat(id)
    if (has)
        Log(id + " was found in data.") 
    else
        Log(id + " was not found in data.") 
    endif  
    
EndFunction

Function dataStatsShowAll()
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    string[] statIDs = DataStorage_Stats.GetAllStatIDs()
    int i = 0
    while (i < statIDs.Length)
        Log((statIDs[i] as String) + " was found in data.") 
        i += 1
    endwhile
EndFunction

Function dataStatsGet(String id)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 

    if (DataStorage_Stats.HasStat(id))
        Log("== " + id + " ======================")
        Log("Current Value: "   + DataStorage_Stats.GetBaseValue(id))
        Log("====================================")
    else
        Log(id + " was not found in data.") 
    endif
EndFunction

Function dataStatsSet(String id, Float value)
    ConfigManager.RefreshAllCaches()
    DataManager.UpdateAllCaches() 
    
    if (DataStorage_Stats.HasStat(id))
        DataStorage_Stats.SetBaseValue(id, value)
        Log(id + " was set to " + value) 
    else
        Log(id + " was not found in data.") 
    endif
EndFunction
