
sub Main()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    m.global = screen.getGlobalNode()
    m.global.AddField("localConfig", "assocarray", false)
    m.global.AddField("localisationEnText", "assocarray", false)
    m.global.localConfig = parseJSON(ReadAsciiFile("pkg:/config.json"))
    m.global.localisationEnText = parseJSON(ReadAsciiFile("pkg:/en.json"))

    scene = screen.CreateScene("MainScene")
    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

