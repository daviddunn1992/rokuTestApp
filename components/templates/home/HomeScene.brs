
function init()
  m.rowList = m.top.findNode("rowList")
  m.mainPosterImage = m.top.findNode("mainPosterImage")
  m.title = m.top.findNode("title")
  m.desc = m.top.findNode("desc")

  m.readLaterLabel = m.top.findNode("readLaterLabel")
  m.readLaterLabel.text = m.global.localisationEnText.button_instruction_home_screen_label_list
  m.readLaterLabel.visible = true

  m.labelListGroup = m.top.findNode("labelListGroup")
  m.labelList = m.top.findNode("labelList")
  m.labelList.observeField("itemSelected", "onLabelListSelected")

  m.top.observeField("focusedChild", "onFocus")

  m.gridImageWidth = 200
  m.gridImageHeight = 100

  m.pageData = Invalid
  m.labelListData = Invalid

  m.loadRemoteDataTask = CreateObject("roSGNode", "LoadHttpJsonTask")
  m.loadRemoteDataTask.uri = m.global.localConfig.url
  m.loadRemoteDataTask.observeField("response", "onRemoteDataResponse")
  m.loadRemoteDataTask.control = "RUN"
end function

function onFocus()
  if (m.top.hasFocus())
    setRowListFocus()
  end if 
end function

function onRemoteDataResponse(event)
  if (m.loadRemoteDataTask = Invalid OR m.loadRemoteDataTask.response = Invalid OR m.loadRemoteDataTask.response.body = Invalid)
    return 0
  end if
  m.loadRemoteDataTask.control = "STOP"
  gridData = event.getData().body
  setupGrid(gridData)
end function

function setupGrid(data as Dynamic)
  rowList = m.rowList
  drawRowListContentNodes(data)
  rowList.itemComponentName = "HomeScreenGridItem"
  rowList.itemSize=[m.gridImageWidth, m.gridImageHeight]
  rowList.itemSpacing="[20, 20]"
  rowList.numColumns="5"
  rowList.numRows="2"
  rowList.vertFocusAnimationStyle="floatingFocus"
  rowList.drawFocusFeedback = true

  m.rowList = rowList
  m.rowList.observeField("itemFocused","onitemFocused")
  m.rowList.observeField("itemSelected","onitemSelected")
  setRowListFocus()
end function


function drawRowListContentNodes(data as Dynamic) as Void
  m.gridParentNode = CreateObject("roSGNode","ContentNode")
  if (data <> Invalid)
    xmlData = CreateObject("roXMLElement")
    xmlData.parse(data)

    if (xmlData <> Invalid AND xmlData.channel <> Invalid AND xmlData.channel.item.count()>0)
      m.pageData = xmlData

      for i=0 to xmlData.channel.item.count()-1
        item = m.gridParentNode.createChild("ContentNode")
        item.id = i
        item.width = m.gridImageWidth
        item.height = m.gridImageHeight
        item.title = xmlData.channel.item[i].title.gettext() 
        item.HDPosterUrl = xmlData.channel.item[i].GetNamedElements("media:thumbnail")@url
        '###################################################'
        '###################################################
        '###placeholder can be used below due to image size issue from bbc rss feed###
        '"https://www.nhlaw.co.uk/wp-content/uploads/2018/01/placeholder-1170x1170.png"'
      end for 
    end if
  end if
  m.rowList.content = m.gridParentNode
end function


function onitemFocused(event)
  itemFocused = event.getData()
  if (m.pageData <> Invalid)
    m.mainPosterImage.uri = m.pageData.channel.item[itemFocused].GetNamedElements("media:thumbnail")@url
    m.title.text = m.pageData.channel.item[itemFocused].title.gettext() 
    m.desc.text = m.pageData.channel.item[itemFocused].description.gettext() 
  end if 
end function

function onitemSelected(event)
  itemSelected = event.getData()

  if (m.pageData <> Invalid)
    m.top.itemSelected = {
      title: m.pageData.channel.item[itemSelected].title.gettext(),
      description: m.pageData.channel.item[itemSelected].description.gettext(),
      link: m.pageData.channel.item[itemSelected].link.gettext(),
      img: m.pageData.channel.item[itemSelected].GetNamedElements("media:thumbnail")@url
    } 
  end if 
end function

function showReadList()
  m.appStorage = CreateObject("roRegistrySection", "reg_bbcDavidAppTest")
  if (m.appStorage.Exists("arrayOfLinks"))
    setupReadLaterList()

    m.labelListGroup.visible = true
    m.labelList.setFocus(true)
  else
    return 0 
  end if
end function

function hideOffLabelList()
  setRowListFocus()  
  m.labelListGroup.visible = false
end function



function setupReadLaterList()
  rootContent = createObject("roSGNode","ContentNode")
  rootContent.TITLE = m.global.localisationEnText.text_read_later

  'check if links are still valid since RSS updates often'
  m.labelListData = []
  linksList = ParseJson(m.appStorage.Read("arrayOfLinks"))
  if (m.pageData <> Invalid)
    for x=0 to m.pageData.channel.item.count()-1
      for each i in linksList
        if (i = m.pageData.channel.item[x].link.gettext()) m.labelListData.push(m.pageData.channel.item[x])
      end for 
    end for 
  end if

  for each x in m.labelListData
    sectionNode = rootContent.createChild("ContentNode")
    sectionNode.TITLE = x.title.gettext()
  end for

  m.labelList.content = rootContent
end function

function onLabelListSelected(event)
  itemSelected = event.getData()
  hideOffLabelList()

  m.top.itemSelected = {
      title: m.labelListData[itemSelected].title.gettext(),
      description: m.labelListData[itemSelected].description.gettext(),
      link: m.labelListData[itemSelected].link.gettext(),
      img: m.labelListData[itemSelected].GetNamedElements("media:thumbnail")@url
  } 
end function

function setRowListFocus()
  if (m.rowList <> Invalid)
    m.rowList.setFocus(true)
  end if
end function


function onKeyEvent(key as String, press as Boolean) as Boolean
  handled = false
  if (key = "options")
    showReadList()
    handled = true
  else if (key = "back")
    if (m.labelList.hasFocus())
      hideOffLabelList()
      handled = true
    end if 
  end if
  return handled
end function
