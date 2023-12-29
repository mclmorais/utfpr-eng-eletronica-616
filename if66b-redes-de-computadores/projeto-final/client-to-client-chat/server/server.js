
const io = require('socket.io').listen(2999)// (http)
const uuid = require('uuid/v4')

let users = []

io.on('connection', onPeerConnection)

console.log('(i) Awaiting connections')

function onPeerConnection (socket)
{
  const user = { name : null, id : uuid(), get shortId () { return this.id.slice(-6) }, assignedPort : selectPort(3000, 4000), remoteAddress : socket.handshake.address }
  socket.userId = user.id
  console.log(`<^  Peer ${user.shortId}`)

  socket.on('localClientNameSelected', name =>
  {
    if (users.find(u => u.id === socket.userId))
      return

    user.name = name
    socket.emit('selfUserUpdate', user)
    console.log(`<   Peer ${user.shortId} (name change: ${user.name})`)
    users.push(user)
    io.sockets.emit('userListUpdate', users)
  })

  socket.on('internalIpUpdate', internalIp =>
  {
    user.remoteAddress = internalIp
    console.log(`<   Peer ${user.shortId} (ip update: ${user.remoteAddress})`)
  })

  socket.on('disconnect', reason =>
  {
    console.log(`<v  Peer ${user.shortId} (${reason})`)
    users = users.filter(u => u.id !== socket.userId)
    io.sockets.emit('userListUpdate', users)
  })
}

function selectPort (min, max)
{
  return Math.floor(Math.random() * (max - min) + min)
  // TODO: check if any user already has the port
}
