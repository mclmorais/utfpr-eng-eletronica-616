'use strict'

const net = require('net')
const readline = require('readline')

const args = process.argv.slice(2)
const HOST = args[0]
const PORT = 4567

const rl = readline.createInterface({
  input  : process.stdin,
  output : process.stdout
})

const client = new net.Socket()

client.connect(PORT, HOST, onClientConnected)

function onClientConnected ()
{
  console.log(`Cliente conectado a ${HOST}:${PORT}`)
}

client.on('data', data => console.log(`Cliente recebeu: ${data}`))

client.on('close', () => 'Cliente fechado')

client.on('error', error => console.log(error))

rl.on('line', input =>
{
  console.log(`Enviando mensagem: ${input}`)
  client.write(`${input}\0`)
})
