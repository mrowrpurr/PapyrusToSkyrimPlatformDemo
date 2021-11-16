import {
    Debug,
    on,
    once,
    printConsole,
    Utility,
    Game
} from "skyrimPlatform"
import { listenForPapyrusEvents, onPapyrusEvent, sendPapyrusEvent, sendPapyrusEventAsync, replyToPapyrus } from "papyrusToSkyrimPlatform"
import { isTypeOnlyImportOrExportDeclaration } from '../node_modules/typescript/lib/typescript'

let hasReceivedMessage = false

let runItNow = false

export let main = () => {
    listenForPapyrusEvents()

    once("update", async () => {
        sendPapyrusEvent("HelloFromSkyrimPlatform", { simpleEvent: "some data" })

        const response = await sendPapyrusEventAsync("PleaseReplyToMe", { "value": "Hello" })
        Debug.messageBox(`RESPONSE: ${JSON.stringify(response)}`)
    })

    onPapyrusEvent((event) => {
        if (event.eventName == "PapyrusToSkyrimPlatform:GetDataEvents") {
            replyToPapyrus(event.eventName, event.replyId, { someData: `You passed us: ${JSON.stringify(event.data)}` })

        } else {
            if (event.replyId) {
                Debug.messageBox(`Skyrim Platform got a reply from Papyrus: ${event.eventName} ${event.replyId} Data: ${JSON.stringify(event.data)}`)

            } else {
                Debug.messageBox(`Skyrim Platform got a message from Papyrus: ${event.eventName} Data: ${JSON.stringify(event.data)}`)
                if (!hasReceivedMessage) {
                    hasReceivedMessage = true
                    sendPapyrusEvent("HelloFromSkyrimPlatform", { hello: "This is a reply from Skyrim Platform!" })
                }
            }
        }
    })
}


