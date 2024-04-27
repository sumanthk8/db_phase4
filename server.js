import express from 'express';
import bodyParser from 'body-parser';
import { 
    addCustomer,
    customerCreditCheck, 
    dronePilotRoster, 
    droneTrafficControl, 
    mostPopularProducts, 
    ordersInProgress, 
    roleDistribution, 
    storeSalesOverview
} from './database.js';

const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(express.json());

const urlencodedParser = bodyParser.urlencoded({ extended: false })

app.get('/', (req, res) => {
    res.render('index.ejs')
});

app.get('/customers', (req, res) => {
    res.render('customers/customers.ejs')
});

app.get('/customers/add-customer', (req, res) => {
    res.render('customers/add-customer.ejs')
});

app.post('/customers/add-customer', urlencodedParser, async (req, res) => {
    const input = req.body;
    await addCustomer(
        input.uname,
        input.firstName,
        input.lastName,
        input.address,
        input.birthdate === '' ? null : input.birthdate,
        parseInt(input.rating),
        parseInt(input.credit)
    )
    res.render('index.ejs')
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
    res.render('views/role-distribution.ejs', {
        roleDistribution: rows
    })
});

app.get('/views/customer-credit-check', async (req, res) => {
    const rows = await customerCreditCheck();
    res.render('views/customer-credit-check.ejs', {
        customerCreditCheck: rows
    })
});

app.get('/views/drone-traffic-control', async (req, res) => {
    const rows = await droneTrafficControl();
    res.render('views/drone-traffic-control.ejs', {
        droneTrafficControl: rows
    })
});

app.get('/views/most-popular-products', async (req, res) => {
    const rows = await mostPopularProducts();
    res.render('views/most-popular-products.ejs', {
        mostPopularProducts: rows
    })
});

app.get('/views/drone-pilot-roster', async (req, res) => {
    const rows = await dronePilotRoster();
    res.render('views/drone-pilot-roster.ejs', {
        dronePilotRoster: rows
    })
});

app.get('/views/store-sales-overview', async (req, res) => {
    const rows = await storeSalesOverview();
    res.render('views/store-sales-overview.ejs', {
        storeSalesOverview: rows
    })
});

app.get('/views/orders-in-progress', async (req, res) => {
    const rows = await ordersInProgress();
    res.render('views/orders-in-progress.ejs', {
        ordersInProgress: rows
    })
});

const port = 8080;
app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
});