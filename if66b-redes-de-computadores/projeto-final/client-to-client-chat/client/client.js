const app                     = require('express')()
const http                    = require('http').createServer(app)
const peerClient              = require('socket.io-client')
const peerServer              = require('socket.io')
const path                    = require('path')
const open                    = require('open')
const authenticatorConnection = require('./authenticator_connection')
const browserConnection       = require('./browser_connection')
const internalIp              = require('internal-ip')
internalIp.v4.sync()
console.log(internalIp.v4.sync())
const args = process.argv.slice(2)

let users = []
const connectedUsers = []

let authentication

const authenticatorSocket   = authenticatorConnection.createSocket(args[0], 2999)
const browserServer         = browserConnection.createServer(http)

authenticatorConnection.setEventListeners(authenticatorSocket, internalIp.v4.sync() || args[1], onAuthenticatorUserListUpdate, onAuthenticatorAuthentication)
browserConnection.setEventListeners(browserServer, onBrowserMessageSent, onBrowserNameSelection, onBrowserChatRequest)

function onAuthenticatorAuthentication (data)
{
  authentication = data
  peerServer.listen(authentication.assignedPort).on('connection', onPeerConnection)
  console.log(`(i) authenticated as ${data.name}`)
  console.log(`(i) Receiving connections on port ${authentication.assignedPort}`)
}

function onAuthenticatorUserListUpdate (data)
{
  if (!authentication) return
  users = data.filter(u => u.id !== authentication.id)
  console.debug(`(i) User list: [${users.length > 0 ? users.map(u => u.name) : ' '}]`)
  browserServer.emit('localClientContactListUpdate', users)
}

function onBrowserMessageSent (data)
{
  const connection = connectedUsers.find(c => c.id === data.id)

  if (!connection)
  {
    console.log(`ERROR: NO CONNECTION FOUND! DATA : ${JSON.stringify(data, null, 2)}`)
    return
  }

  connection.messages.push({ type : 'sent', message : data.message })
  // console.log(getSimpleConnectedUsers())
  connection.socket.emit('localClientChatMessage', { id : authentication.id, message : data.message })
  console.log(`>   Peer ${connection.user.shortId} (message) [${connection.socket.id}]`)
}

function onBrowserNameSelection (data)
{
  console.log(`(i) Name: ${data}`)
  authenticatorSocket.emit('localClientNameSelected', data)
}

function onBrowserChatRequest (id)
{
  const user = users.find(u => u.id === id)
  const connection = connectedUsers.find(c => c.id === user.id)

  if (!connection)
  {
    console.log(`^>  Peer ${user.shortId}`)
    console.log(`(i) Connecting to ${user.shortId} (${user.name}) at [${user.remoteAddress}]:${user.assignedPort}`)
    const peerClientSocket = peerClient.connect(`http://[${user.remoteAddress}]:${user.assignedPort}`, { reconnection : true })
    peerClientSocket.on('localClientChatMessage', data => onPeerChatMessageReceived(data, peerClientSocket))
    peerClientSocket.on('connect', () => console.log(`(i) Emitter socket opened with ${user.shortId} (${user.name}) [${peerClientSocket.id}]`))
    peerClientSocket.emit('identification', authentication.id)
    connectedUsers.push({ id : user.id, socket : peerClientSocket, type : 'emitter', messages : [], user : user })
  }
  else
    console.log(`(i) Found existing connection to ${user.shortId} (${user.name}) [${connection.socket.id}]`)

  browserConnection.browserSocket.emit('localClientConverstionHistoryUpdate', connection ? connection.messages : [])
}

function getRandomPort (min, max)
{
  return Math.floor(Math.random() * (max - min) + min)
}

function onPeerConnection (socket)
{
  console.log(`<^  Peer ${socket.handshake.address}`)

  socket.on('identification', id =>
  {
    console.log('<   Peer (identification)')
    const user = users.find(u => u.id === id)
    if (!connectedUsers.find(c => c.id === id))
    {
      console.log(`(i) New connection with ${user.shortId} (${user.name})`)
      connectedUsers.push({ id : id, socket : socket, type : 'receiver', messages : [], user : user })
      console.log(`(i) Receiver socket opened with ${user.shortId} (${user.name}) [${socket.id}]`)
    }
    else
      console.log(`(i) Existing connection with ${user.shortId} (${user.name})`)

    // console.log(getSimpleConnectedUsers())
  })

  socket.on('localClientChatMessage', data => onPeerChatMessageReceived(data, socket))
}

function onPeerChatMessageReceived (data, socket)
{
  const connection = connectedUsers.find(c => c.id === data.id)

  if (!connection)
  {
    console.log(`ERROR: NO CONNECTION FOUND! DATA : ${JSON.stringify(data, null, 2)}`)
    return
  }
  console.log(`<   Peer ${connection.user.shortId} (message) [${socket.id}]`)
  connection.messages.push({ type : 'received', message : data.message })
  // console.log(getSimpleConnectedUsers())
  browserConnection.browserSocket.emit('messageReceived', data.message)
}

app.get('/', function (req, res)
{
  res.sendFile(path.join(__dirname, '/index-template.html'))
})

const browserPort = getRandomPort(3000, 4000)
http.listen(browserPort, function ()
{
  console.log(`(i) Browser UI available on port ${browserPort}`);

  (async () =>
  {
    await open(`http://localhost:${browserPort}`)
  })()
})
