// Conexión a BD MySql
const mysql = require('mysql');

const mysqlConnection = mysql.createConnection({
    //host: 'localhost',
    //host: '173.249.158.24',
    host: 'db4free.net',
    //user: 'root',
    user: 'admi52351',
    password: 'Mayenr$2020',
    //database: 'admitt's
    database: 'admi52351_admitt'
});

mysqlConnection.connect(function(err) {
    if (err) {
        console.log(err);
        return;
    } else {
        console.log("La DB está conectada");
    }
});

module.exports = mysqlConnection;