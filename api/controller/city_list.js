var db = require('../config/db');

exports.getStateCityList = function (req, res, next) {
  if (req.body.state_id == '' || req.body.state_id == 'undefined' || req.body.state_id == null) {
    return res.status(500).send({ status: 'error', message: 'State id not found.' });
  }
  var sql = "SELECT id, `city` from cities where state_id='" + req.body.state_id + "' order by city";
  db.query(sql, function (err, rows, fields) {
    if (err) {
      return res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
    }
    return res.status(200).json({ status: 'success', message: 'success', data: rows });
  });
};