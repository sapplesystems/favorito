var mysql = require('mysql');
var connection = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME
});




// var connection = mysql.createConnection({
//     host: "localhost",
//     port: "3306",
//     user: "root",
//     password: "rohit123",
//     database: "obedient_dev",
//     multipleStatements: true,
//   });

connection.connect(function(err) {
    if (err) {
        console.log(err);
        throw err;
    } else {
        console.log('connected!');
    }
});
module.exports = connection;