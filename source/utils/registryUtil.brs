function addToRegistryList(dataItem)
  m.appStorage = CreateObject("roRegistrySection", "reg_bbcDavidAppTest")
  if (m.appStorage.Exists("arrayOfLinks"))
    linksList = ParseJson(m.appStorage.Read("arrayOfLinks"))
    linksList.push(dataItem)
    m.appStorage.Write("arrayOfLinks", FormatJson(linksList))
    m.appStorage.Flush()
  else 
    linksList = []
    linksList.push(dataItem)
    m.appStorage.Write("arrayOfLinks", FormatJson(linksList))
    m.appStorage.Flush()    
  end if
end function

function deleteFromRegistryList(dataItem)
  m.appStorage = CreateObject("roRegistrySection", "reg_bbcDavidAppTest")
  if (m.appStorage.Exists("arrayOfLinks"))
    linksListNew = []
    existingLinksList = ParseJson(m.appStorage.Read("arrayOfLinks"))
    for each x in existingLinksList
      if (x <> dataItem) linksListNew.push(x)
    end for 
    m.appStorage.Write("arrayOfLinks", FormatJson(linksListNew))
    m.appStorage.Flush()   
  end if
end function

function linkExistInStorageReadLaterList(link) as Boolean
  m.appStorage = CreateObject("roRegistrySection", "reg_bbcDavidAppTest")
  if (m.appStorage.Exists("arrayOfLinks"))
    linksList = ParseJson(m.appStorage.Read("arrayOfLinks"))
    for each x in linksList
      if (x = link) return true
    end for 
  end if 
  return false
end function

function registryListSize() as Integer
  m.appStorage = CreateObject("roRegistrySection", "reg_bbcDavidAppTest")
  if (m.appStorage.Exists("arrayOfLinks"))
    return ParseJson(m.appStorage.Read("arrayOfLinks")).count()
  end if
  return 0
end function