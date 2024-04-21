const { 
    createPool
 } = require('mysql2');

 const pool = createPool({
    host: "localhost",
    user: "root",
    password: "password",
    database: "drone_dispatch"
 }).promise();


async function customerView() {
    const [rows] = await pool.query(`select * from customer_credit_check`);
    return rows;
 }

 async function main() {
    const test = await customerView();
    console.log(test);
}

main();
 