
function init()
  m.link = Invalid
  m.mainPosterImage = m.top.findNode("mainPosterImage")
  m.title = m.top.findNode("title")
  m.desc = m.top.findNode("desc")
  m.bookmarkBtn = m.top.findNode("bookmarkBtn")
  m.bookmarkBtn.observeField("buttonSelected","onButtonToggle")

  m.top.observeField("focusedChild", "onFocus")
  m.top.observeField("itemDetailsData","onItemDetailsData")
end function

function onItemDetailsData(event)
  if (event.getData() <> Invalid)
    m.mainPosterImage.uri = event.getData().img
    m.title.text = event.getData().title
    m.desc.text = event.getData().description
    m.link = event.getData().link
    m.bookmarkBtn.text = setBookmarkBtnText()
  end if
end function

function onFocus()
  if (m.top.hasFocus())
    m.bookmarkBtn.setFocus(true)
  end if
end function

function onButtonToggle()
  if (linkExistInStorageReadLaterList(m.link))
    deleteFromRegistryList(m.link)
  else 
    addToRegistryList(m.link)
  end if
  m.bookmarkBtn.text = setBookmarkBtnText() 
end function

function setBookmarkBtnText() as String
  if (linkExistInStorageReadLaterList(m.link))
     return m.global.localisationEnText.button_txt_remove
  else
     return m.global.localisationEnText.button_txt_add
  end if
end function


function onKeyEvent(key as String, press as Boolean) as Boolean
  handled = false
  if (key = "back")
    m.top.backSelected = true
    handled = true
  end if
  return handled
end function
