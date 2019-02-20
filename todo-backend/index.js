const express = require('express')
const bodyParser = require('body-parser')
const Pusher = require('pusher')
const app = express()

app.use(bodyParser.json())

var pusher = new Pusher({
    appId: "719238",
    key: "2d88a674e241b1eaa239",
    secret: "7bd125dd8605cf00bd9a",
    cluster: "us2"
});

app.post('/addItem', function (req, res) {
    pusher.trigger('todo', 'addItem', {text: req.body.value});
    res.send(200);
})

app.listen(process.env.PORT || 5000);