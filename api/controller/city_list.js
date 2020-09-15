var db = require('../config/db');

exports.getStateCityList = function (req, res, next) {
  var condition = "";
  if (req.body.state_id != '' && req.body.state_id != 'undefined' && req.body.state_id != null) {
    condition = "where state_id='" + req.body.state_id + "'";
  }
  var sql = "SELECT id, `city` from cities " + condition + " order by city";
  db.query(sql, function (err, rows, fields) {
    if (err) {
      return res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
    }
    return res.status(200).json({ status: 'success', message: 'success', data: rows });
  });
};