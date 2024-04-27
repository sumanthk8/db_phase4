import express from 'express';
import { roleDistribution } from './database.js';

const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));

app.get('/', (req, res) => {
    res.render('index.ejs')
});

app.get('/customers', (req, res) => {
    res.render('customers/customers.ejs')
});

app.get('/products', (req, res) => {
    res.render('products/products.ejs')
});

app.get('/drones', (req, res) => {
    res.render('drones/drones.ejs')
});

app.get('/drone-pilots', (req, res) => {
    res.render('drone-pilots/drone-pilots.ejs')
});

app.get('/orders', (req, res) => {
    res.render('orders/orders.ejs')
});

app.get('/views', (req, res) => {
    res.render('views/views.ejs')
});

app.get('/views/role-distribution', async (req, res) => {
    const rows = await roleDistribution();
    // console.log(rows[0].category);
    res.render('views/role-distribution.ejs', {
        roleDistribution: rows
    })
});

const port = 8080;
app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
});