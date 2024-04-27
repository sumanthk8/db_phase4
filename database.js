import mysql from 'mysql2';

import dotenv from 'dotenv';
dotenv.config();

const pool = mysql.createPool({
   host: process.env.MYSQL_HOST,
   user: process.env.MYSQL_USER,
   password: process.env.MYSQL_PASSWORD,
   database: process.env.MYSQL_DATABASE,
}).promise();


// Create

export async function addCustomer(uname, firstName, lastName, address, birthdate, rating, credit) {
   const result = await pool.query(`
      call add_customer(?, ?, ?, ?, ?, ?, ?)
   `, [uname, firstName, lastName, address, birthdate, rating, credit]);
   
   return result;
}

export async function addDronePilot(uname, firstName, lastName, address, birthdate, taxID, service, salary, licenseID, experience) {
   const result = await pool.query(`
      call add_drone_pilot(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
   `, [uname, firstName, lastName, address, birthdate, taxID, service, salary, licenseID, experience]);

   return result;
}

export async function addProduct(barcode, pname, weight) {
   const result = await pool.query(`
      call add_product(?, ?, ?)
   `, [barcode, pname, weight]);

   return result;
}

export async function addDrone(storeID, droneTag, capacity, remainingTrips, pilot) {
   const result = await pool.query(`
      call add_drone(?, ?, ?, ?, ?)
   `, [storeID, droneTag, capacity, remainingTrips, pilot]);

   return result;
}

// Update

export async function increaseCustomerCredits(uname, money) {
   const result = await pool.query(`
      call increase_customer_credits(?, ?)
   `, [uname, money]);

   return result;
}

export async function swapDroneControl(incomingPilot, outgoingPilot) {
   const result = await pool.query(`
      call swap_drone_control(?, ?)
   `, [incomingPilot, outgoingPilot]);

   return result;
}

export async function repairRefuelDrone(droneStore, droneTag, refueledTrips) {
   const result = await pool.query(`
      call repair_refuel_drone(?, ?, ?)
   `, [droneStore, droneTag, refueledTrips]);

   return result;
}

export async function beginOrder(orderID, soldOn, purchasedBy, carrierStore, carrierTag, barcode, price, quantity) {
   const result = await pool.query(`
      call begin_order(?, ?, ?, ?, ?, ?, ?, ?)
   `, [orderID, soldOn, purchasedBy, carrierStore, carrierTag, barcode, price, quantity]);

   return result;
}

export async function addOrderLine(orderID, barcode, price, quantity) {
   const result = await pool.query(`
      call add_order_line(?, ?, ?, ?)
   `, [orderID, barcode, price, quantity]);

   return result;
}

export async function deliverOrder(orderID) {
   const result = await pool.query(`
      call deliver_order(?)
   `, [orderID]);

   return result;
}

export async function cancelOrder(orderID) {
   const result = await pool.query(`
      call cancel_order(?)
   `, [orderID]);

   return result;
}

// Read

export async function roleDistribution() {
    const [rows] = await pool.query(`select * from role_distribution`);
    return rows;
}

export async function customerCreditCheck() {
   const [rows] = await pool.query(`select * from customer_credit_check`);
   return rows;
}

export async function droneTrafficControl() {
   const [rows] = await pool.query(`select * from drone_traffic_control`);
   return rows;
}

export async function mostPopularProducts() {
   const [rows] = await pool.query(`select * from most_popular_products`);
   return rows;
}

export async function dronePilotRoster() {
   const [rows] = await pool.query(`select * from drone_pilot_roster`);
   return rows;
}

export async function storeSalesOverview() {
   const [rows] = await pool.query(`select * from store_sales_overview`);
   return rows;
}

// Delete

export async function removeCustomer(uname) {
   const result = await pool.query(`
      call remove_customer(?)
   `, [uname]);

   return result;
}

export async function removeDronePilot(uname) {
   const result = await pool.query(`
      call remove_drone_pilot(?)
   `, [uname]);

   return result;
}

export async function removeProduct(barcode) {
   const result = await pool.query(`
      call remove_product(?)
   `, [barcode]);

   return result;
}

export async function removeDrone(storeID, droneTag) {
   const result = await pool.query(`
      call remove_drone(?, ?)
   `, [storeID, droneTag]);

   return result;
}