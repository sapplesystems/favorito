var db = require('../config/db');
var bcrypt = require('bcrypt');

exports.changePassword = function (req, res, next) {
  try {
    if (req.body.old_password == '' || req.body.old_password == 'undefined' || req.body.old_password == null) {
      return res.status(403).json({ status: 'error', message: 'Old password not found.' });
    } else if (req.body.new_password == '' || req.body.new_password == 'undefined' || req.body.new_password == null) {
      return res.status(403).json({ status: 'error', message: 'New password not found.' });
    } else if (req.body.confirm_password == '' || req.body.confirm_password == 'undefined' || req.body.confirm_password == null) {
      return res.status(403).json({ status: 'error', message: 'Confirm passwod not found.' });
    } else if (req.body.new_password != req.body.confirm_password) {
      return res.status(403).json({ status: 'error', message: 'New password and confirm password does not match.' });
    } else {
      var sql = "select * from business_users where business_id='" + req.userdata.business_id + "' and is_deleted=0 and deleted_at is null";
      db.query(sql, function (err, result) {
        if (err) {
          return res.json({ status: 'error', message: 'Something went wrong.', data: err });
        } else {
          if (result.length === 0) {
            return res.status(403).json({ status: 'error', message: 'Incorrect business id' });
          }
          bcrypt.compare(req.body.old_password, result[0].password, function (err, enc_result) {
            if (err) {
              return res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            } else if (enc_result === false) {
              return res.status(403).json({ status: 'error', message: 'Old pssword does not match.', data: err });
            } else {
              bcrypt.hash(req.body.new_password, 10, function (err, hash) {
                var uq = "UPDATE business_users SET `password`='" + hash + "', org_password='" + req.body.new_password + "' WHERE business_id='" + req.userdata.business_id + "'";
                db.query(uq, function (error, resp) {
                  if (error) {
                    return res.status(403).json({ status: 'error', message: 'Password could not be changed.' });
                  }
                  return res.status(403).json({ status: 'error', message: 'Password changed successfully.' });
                });
              });
            }
          });
        }
      });
    }
  } catch (e) {
    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
  }
};