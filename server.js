import express from 'express';
import bodyParser from 'body-parser';
import { 
    addCustomer,
    addDrone,
    addDronePilot,
    addOrderLine,
    addProduct,
    beginOrder,
    cancelOrder,
    customerCreditCheck, 
    deliverOrder, 
    dronePilotRoster, 
    droneTrafficControl, 
    increaseCustomerCredits, 
    mostPopularProducts, 
    ordersInProgress, 
    removeCustomer, 
    removeDrone, 
    removeDronePilot, 
    removeProduct, 
    repairRefuelDrone, 
    roleDistribution, 
    storeSalesOverview,
    swapDroneControl
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

app.get('/customers/increase-customer-credits', (req, res) => {
    res.render('customers/increase-customer-credits.ejs')
});

app.post('/customers/increase-customer-credits', urlencodedParser, async (req, res) => {
    const input = req.body;
    await increaseCustomerCredits(
        input.uname,
        parseInt(input.money)
    )
    res.render('index.ejs')
});

app.get('/customers/remove-customer', (req, res) => {
    res.render('customers/remove-customer.ejs')
});

app.post('/customers/remove-customer', urlencodedParser, async (req, res) => {
    const input = req.body;
    await removeCustomer(
        input.uname
    )
    res.render('index.ejs')
});

app.get('/products', (req, res) => {
    res.render('products/products.ejs')
});

app.get('/products/add-product', (req, res) => {
    res.render('products/add-product.ejs')
});

app.post('/products/add-product', urlencodedParser, async (req, res) => {
    const input = req.body;
    await addProduct(
        input.barcode,
        input.pname,
        parseInt(input.weight)
    )
    res.render('index.ejs')
});

app.get('/products/remove-product', (req, res) => {
    res.render('products/remove-product.ejs')
});

app.post('/products/remove-product', urlencodedParser, async (req, res) => {
    const input = req.body;
    await removeProduct(
        input.barcode
    )
    res.render('index.ejs')
});

app.get('/drones', (req, res) => {
    res.render('drones/drones.ejs')
});

app.get('/drones/add-drone', (req, res) => {
    res.render('drones/add-drone.ejs')
});

app.post('/drones/add-drone', urlencodedParser, async (req, res) => {
    const input = req.body;
    await addDrone(
        input.storeID,
        input.droneTag,
        parseInt(input.capacity),
        parseInt(input.remainingTrips),
        input.pilot
    )
    res.render('index.ejs')
});

app.get('/drones/repair-refuel-drone', (req, res) => {
    res.render('drones/repair-refuel-drone.ejs')
});

app.post('/drones/repair-refuel-drone', urlencodedParser, async (req, res) => {
    const input = req.body;
    await repairRefuelDrone(
        input.storeID,
        input.droneTag,
        parseInt(input.refueledTrips)
    )
    res.render('index.ejs')
});

app.get('/drones/remove-drone', (req, res) => {
    res.render('drones/remove-drone.ejs')
});

app.post('/drones/remove-drone', urlencodedParser, async (req, res) => {
    const input = req.body;
    await removeDrone(
        input.storeID,
        input.droneTag
    )
    res.render('index.ejs')
});

app.get('/drone-pilots', (req, res) => {
    res.render('drone-pilots/drone-pilots.ejs')
});

app.get('/drone-pilots/add-drone-pilot', (req, res) => {
    res.render('drone-pilots/add-drone-pilot.ejs')
});

app.post('/drone-pilots/add-drone-pilot', urlencodedParser, async (req, res) => {
    const input = req.body;
    await addDronePilot(
        input.uname,
        input.firstName,
        input.lastName,
        input.address,
        input.birthdate === '' ? null : input.birthdate,
        input.taxID,
        parseInt(input.service),
        parseInt(input.salary),
        input.licenseID,
        parseInt(input.experience)
    )
    res.render('index.ejs')
});

app.get('/drone-pilots/swap-drone-control', (req, res) => {
    res.render('drone-pilots/swap-drone-control.ejs')
});

app.post('/drone-pilots/swap-drone-control', urlencodedParser, async (req, res) => {
    const input = req.body;
    await swapDroneControl(
        input.incomingPilot,
        input.outgoingPilot
    )
    res.render('index.ejs')
});

app.get('/drone-pilots/remove-drone-pilot', (req, res) => {
    res.render('drone-pilots/remove-drone-pilot.ejs')
});

app.post('/drone-pilots/remove-drone-pilot', urlencodedParser, async (req, res) => {
    const input = req.body;
    await removeDronePilot(
        input.uname
    )
    res.render('index.ejs')
});

app.get('/orders', (req, res) => {
    res.render('orders/orders.ejs')
});

app.get('/orders/begin-order', (req, res) => {
    res.render('orders/begin-order.ejs')
});

app.post('/orders/begin-order', urlencodedParser, async (req, res) => {
    const input = req.body;
    await beginOrder(
        input.orderID,
        input.soldOn,
        input.purchasedBy,
        input.carrierStore,
        input.carrierTag,
        input.barcode,
        parseInt(input.price),
        parseInt(input.quantity)
    )
    res.render('index.ejs')
});

app.get('/orders/add-order-line', (req, res) => {
    res.render('orders/add-order-line.ejs')
});

app.post('/orders/add-order-line', urlencodedParser, async (req, res) => {
    const input = req.body;
    await addOrderLine(
        input.orderID,
        input.barcode,
        parseInt(input.price),
        parseInt(input.quantity)
    )
    res.render('index.ejs')
});

app.get('/orders/deliver-order', (req, res) => {
    res.render('orders/deliver-order.ejs')
});

app.post('/orders/deliver-order', urlencodedParser, async (req, res) => {
    const input = req.body;
    await deliverOrder(
        input.orderID
    )
    res.render('index.ejs')
});

app.get('/orders/cancel-order', (req, res) => {
    res.render('orders/cancel-order.ejs')
});

app.post('/orders/cancel-order', urlencodedParser, async (req, res) => {
    const input = req.body;
    await cancelOrder(
        input.orderID
    )
    res.render('index.ejs')
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