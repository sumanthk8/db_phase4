const express = require('express');
const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));

app.get('/', (req, res) => {
    res.render('index.ejs')
});

app.get('/customers', (req, res) => {
    res.render('objects/customers.ejs')
});

const port = 8080;
app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
});