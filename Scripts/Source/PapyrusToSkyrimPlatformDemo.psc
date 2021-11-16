scriptName PapyrusToSkyrimPlatformDemo extends ConnectedToSkyrimPlatform

; TODO : Ask SkyrimPlatform for a Value (just like await)

; TODO HAVE DEFAULT LISTENERS WHICH CONTAIN A *UNIQUE* ID IN THE SKSE MOD EVENT NAME (customizable) - instead of 'LISTEN'

event OnConnectedInit()
    Listen("HelloFromSkyrimPlatform")
    Listen("PleaseReplyToMe")

    Utility.WaitMenuMode(3)
    int params = JMap.object()
    JMap.setStr(params, "foo", "bar")
    int stuffFromSkyrimPlatform = GetData("PleaseReplyToMe", params)
    Debug.MessageBox("Got Stuff Back from Skyrim Platform: " + JObjectToJson.ToJson(stuffFromSkyrimPlatform))

    Utility.WaitMenuMode(2)
    int msg = JMap.object()
    JMap.setStr(msg, "text", "Hello from Papyrus!")
    SendData("HelloFromPapyrus", msg)
endEvent

event OnData(string skseModEventName, int dataRef, string replyId)
    if skseModEventName == "PleaseReplyToMe" ; await Async
        int response = JMap.object()
        JMap.setStr(response, "value", "We got this value from Skyrim Platform: " + JMap.getStr(dataRef, "value"))
        Reply(response, replyId)
    else
        string json = JObjectToJson.ToJson(dataRef)
        Debug.MessageBox("Papyrus got a message from Skyrim Platform " + skseModEventName + " " + dataRef + " " + replyId + " " + json)
        int response = JMap.object()
        JMap.setStr(response, "responseText", "Hi, I received this data: " + json)
        Reply(response, replyId)
    endIf
endEvent
