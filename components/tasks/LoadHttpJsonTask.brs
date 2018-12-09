sub init()
	m.top.id = "LoadHttpJsonTask"
	m.top.functionName = "getContent"
end sub

sub getContent()
	m.port = CreateObject("roMessagePort")
	sendRequest()
end sub


sub sendRequest()
	uri = m.top.uri
	m.urlTransfer = createObject("roUrlTransfer")
	m.urlTransfer.setUrl(uri)
	m.urlTransfer.setMessagePort(m.port)
	m.urlTransfer.retainBodyOnError(true)

    requestSuccess = m.urlTransfer.asyncGetToString()

    if (requestSuccess)
		listenToRequest()
    end if
end sub

sub listenToRequest()
	m.isRunning = True
	while(m.isRunning)
		msg = m.port.waitMessage(0)
		msgType = type(msg)
		returnedPayload = {}
		if (msgType = "roUrlEvent" AND m.isRunning)
			m.isRunning = False
			if (msg.getResponseCode() = 200 AND msg.getString() <> "")
				returnedPayload.body = msg.getString()
				m.top.response = returnedPayload
			else 
				m.isRunning = true
			end if
		end if
	end while
end sub





