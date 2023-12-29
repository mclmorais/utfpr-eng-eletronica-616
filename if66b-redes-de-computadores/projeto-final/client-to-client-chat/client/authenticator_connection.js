const authenticatorClientIo = require('socket.io-client')

const serverConnection = {

  createSocket : function (address = 'localhost', port)
  {
    const url = `http://${address}:${port}/`
    console.log(`(i) Connecting to authenticator at ${url}`)

    return authenticatorClientIo.connect(url, { reconnection : true })
  },

  setEventListeners : function (mainServerSocket, internalIp, userListUpdate, selfUserUpdate)
  {
    mainServerSocket.on('connect', () =>
    {
      console.log('^>  Authenticator')

      mainServerSocket.emit('internalIpUpdate', internalIp)

      mainServerSocket.on('userListUpdate', data => { console.log('<   Server (user list)'); userListUpdate(data) })
      mainServerSocket.on('selfUserUpdate', data => { console.log('<   Server (authentication)'); selfUserUpdate(data) })
    })
  }
}

module.exports = serverConnection
