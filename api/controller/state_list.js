var db = require('../config/db');

exports.getAllStateList = function (req, res, next) {
  try {
    var sql = "SELECT id, `state` from states order by state";
    db.query(sql, function (err, rows, fields) {
      if (err) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
      }
      return res.status(200).json({ status: 'success', message: 'success', data: rows });
    });
  } catch (e) {
    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
  }
};