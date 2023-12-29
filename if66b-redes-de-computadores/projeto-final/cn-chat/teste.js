const express = require('express')
const app = express()
const port = 4567

app.get('/', (req, res) => res.send('UAU TENHO UM SERVIDOR QUE INCRIVEL!'))

app.get('/segunda', (req, res) => res.send('SEGUNDA ROTA UAU!'))

app.listen(port, () => console.log(`Example app listening on port ${port}!`))