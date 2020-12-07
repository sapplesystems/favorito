var mysql = require('mysql');

var connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME
});

connection.connect(function(err) {
  if (err){  
  console.log('error:',err);
    throw err;
  console.log('connected!');}
  else{
    console.log("DB not connected");
  }
}
);

module.exports = connection;
