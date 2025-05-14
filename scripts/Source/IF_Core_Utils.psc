Scriptname IF_Core_Utils extends Quest


String Function RemoveJsonExt(String file) global
    if file == ""
        return file
    endif

    int fileLength = StringUtil.GetLength(file)
    int suffixLength = 5 

    if StringUtil.Find(file, ".json") == (fileLength - suffixLength)
        return StringUtil.Substring(file, 0, fileLength - suffixLength)
    endif

    return file
EndFunction


String[] Function GetStringArraySafe(int jArray) global
    if jArray == 0
        return None
    endif

    int count = JArray.count(jArray)
    if count <= 0
        return None
    endif

    String[] result = Utility.CreateStringArray(count)
    int i = 0
    while i < count
        result[i] = JArray.getStr(jArray, i)
        i += 1
    endwhile

    return result
EndFunction
