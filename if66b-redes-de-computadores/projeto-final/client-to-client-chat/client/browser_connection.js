const browserServerIo = require('socket.io')

const serverConnection = {

  browserSocket : null,

  createServer : function (httpServer)
  {
    return browserServerIo(httpServer)
  },

  setEventListeners : function (browserServer, browserMessageSent, browserNameSelection, browserChatRequest, disconnect)
  {
    browserServer.on('connection', browserSocket =>
    {
      console.log('<^  Browser')

      serverConnection.browserSocket = browserSocket

      browserSocket.on('remoteClientMessageSent', data => { console.log('<   Browser (message sent)'); browserMessageSent(data) })
      browserSocket.on('remoteClientNameSelection', data => { console.log('<   Browser (name change)'); browserNameSelection(data) })
      browserSocket.on('remoteClientChatRequest', data => { console.log('<   Browser (chat request)'); browserChatRequest(data) })
      browserSocket.on('disconnect', data => { console.log('<^  Browser') })
    })
  }
}

module.exports = serverConnection
