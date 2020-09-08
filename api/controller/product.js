var db = require('../config/db');

exports.getAllProducts = function (req, res, next) {
  var sql = "SELECT id, `name`, sku, market_price FROM products WHERE deleted_at IS NULL";
  db.query(sql, function (err, rows, fields) {
    if (err) {
      res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
    }
    res.status(200).json({ status: 'success', message: 'success', data: rows });
    //res.json(rows);
  });
};