var db = require('../config/db');

exports.getBusinessWorkingHoursDD = function (req, res, next) {
  var sql = "SELECT working_hours_dd from business_working_hours_dd";
  db.query(sql, function (err, rows, fields) {
    if (err) {
      return res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
    }
    return res.status(200).json({ status: 'success', message: 'success', data: rows });
  });
};