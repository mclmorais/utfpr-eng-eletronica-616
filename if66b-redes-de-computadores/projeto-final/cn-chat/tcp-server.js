'use strict'

const net = require('net')

const HOST = 'localhost'
const PORT = 3000

const server = net.createServer(onClientConnected)

server.listen(PORT, HOST, () => console.log(`Listening on ${server.address().address}:${server.address().port}`))

function onClientConnected (socket)
{
  const remoteAddress = `${socket.remoteAddress}:${socket.remotePort}`
  console.log(`Novo cliente conectado: ${remoteAddress}`)

  socket.on('data', data =>
  {
    console.log(`${remoteAddress} enviou: ${data}`)
  })

  socket.on('close', () => console.log(`Conexão fechada com ${remoteAddress}`))

  socket.on('error', error => console.log(`Erro na conexão com ${remoteAddress}: ${error}`))
}
