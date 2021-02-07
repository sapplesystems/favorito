// var mysql = require('mysql');
const mysql = require("mysql2")
var connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME
});

connection.connect(function(err) {
  if (err){
    console.log(err);
    throw err;
  } else {
    console.log('connected!');
  }
});

module.exports = connection;
