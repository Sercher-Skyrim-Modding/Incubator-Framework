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