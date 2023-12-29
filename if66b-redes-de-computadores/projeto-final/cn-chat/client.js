'use strict'

// includes and definitions
const PORT = 4567
const HOST = '127.0.0.1'
const dgram = require('dgram')
const readline = require('readline')

// configuration
const rl = readline.createInterface({
  input  : process.stdin,
  output : process.stdout
})

const client = dgram.createSocket('udp4')
client.bind(33333)

client.on('listening', function ()
{
  client.setBroadcast(true)

  const address = client.address()
  console.log(`Socket open - ${address.address}:${address.port}`)
  console.log('Type a message:')
})

rl.on('line', input =>
{
  client.send(input, 0, input.length, PORT, HOST, function (err, bytes)
  {
    if (err) throw err
    console.log(`UDP message "${input}" sent to ${HOST}:${PORT}\n`)
  })
})

// rl.question('What do you think of Node.js? ', (answer) =>
// {
//   // TODO: Log the answer in a database
//   console.log(`Thank you for your valuable feedback: ${answer}`);

//   rl.close();
// });
