sub Init()
  m.Poster = m.top.findNode("itemImage")
  m.vLayout = m.top.findNode("vLayoutGroup")
end sub

sub itemContentChanged()
  item = m.top.itemContent
 
  if(m.Poster <> Invalid AND item.HDPosterUrl <> Invalid and item.HDPosterUrl <> "")
    m.Poster.uri = item.HDPosterUrl
  end if
end sub

function onFocusPercent()
  resizeImage()
end function

function resizeImage()
  if (m.Poster <> Invalid)
    m.Poster.width  = m.top.width
    m.Poster.height = m.top.height 
  end if
end function


