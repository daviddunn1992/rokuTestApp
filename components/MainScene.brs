
function init()
  m.top.setFocus(true)

  m.container = m.top.findNode("Container")

  GenerateHomeScreen()
end function


function GenerateHomeScreen() 
  m.HomeScreen = CreateObject("roSGNode", "HomeScene")
  m.HomeScreen.observeField("itemSelected", "onHomeScreenItemSelected") 
  'm.HomeScreen.observeField("backSelected", "onBackSelected") 'handled to exit app'
  m.container.appendChild(m.HomeScreen)
  m.HomeScreen.setFocus(true)
end function

function onHomeScreenItemSelected(event)
  m.HomeScreen.visible = false
  m.DetailsScreen = CreateObject("roSGNode", "DetailsScene")
  m.DetailsScreen.itemDetailsData = event.getData()
  m.DetailsScreen.observeField("backSelected", "onBackSelected") 
  m.container.appendChild(m.DetailsScreen)
  m.DetailsScreen.setFocus(true)
end function

function onBackSelected()
  currentViewInt = m.container.getChildCount()-1
  if (currentViewInt > 0)
  	m.container.removeChildIndex(currentViewInt)
  	m.container.getChild(currentViewInt-1).visible = true
  	m.container.getChild(currentViewInt-1).setFocus(true)
  end if 
end function

