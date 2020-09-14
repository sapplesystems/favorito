var db = require('../config/db');

exports.updateProfile = function (req, res, next) {

  if (req.body.id == '' || req.body.id == null) {
    return res.json({ status: 'error', message: 'Id not found.' });
  } else if (req.body.business_id == '' || req.body.business_id == null) {
    return res.json({ status: 'error', message: 'Business id not found.' });
  }

  var id = req.body.id;
  var business_id = req.body.business_id;
  var address_arr = req.body.address;
  var website_arr = req.body.website;


  var update_columns = " updated_by='" + id + "', updated_at=now() ";

  if (req.body.business_name != '' && req.body.business_name != null) {
    update_columns += ", business_name='" + req.body.business_name + "' ";
  }
  if (req.body.business_phone != '' && req.body.business_phone != null) {
    update_columns += ", business_phone='" + req.body.business_phone + "' ";
  }
  if (req.body.landline != '' && req.body.landline != null) {
    update_columns += ", landline='" + req.body.landline + "' ";
  }
  if (address_arr && address_arr != 'undefined') {
    if (address_arr[0] != '') {
      update_columns += ", address1='" + address_arr[0] + "' ";
    }
    if (address_arr[1] != '') {
      update_columns += ", address2='" + address_arr[1] + "' ";
    }
    if (address_arr[2] != '') {
      address_arr.shift();
      address_arr.shift();
      var third_address = address_arr.join(', ');
      update_columns += ", address3='" + third_address + "' ";
    }
  }
  if (req.body.pincode != '' && req.body.pincode != null) {
    update_columns += ", pincode='" + req.body.pincode + "' ";
  }
  if (req.body.town_city != '' && req.body.town_city != null) {
    update_columns += ", town_city='" + req.body.town_city + "' ";
  }
  if (req.body.state_id != '' && req.body.state_id != null) {
    update_columns += ", state_id='" + req.body.state_id + "' ";
  }
  if (req.body.country_id != '' && req.body.country_id != null) {
    update_columns += ", country_id='" + req.body.country_id + "' ";
  }
  if (website_arr && website_arr != 'undefined') {
    update_columns += ", website='" + website_arr.join('|_|') + "' ";
  }
  if (req.body.business_email != '' && req.body.business_email != null) {
    update_columns += ", business_email='" + req.body.business_email + "' ";
  }
  if (req.body.short_description != '' && req.body.short_description != null) {
    update_columns += ", short_description='" + req.body.short_description + "' ";
  }
  if (req.file && req.file.filename != '') {
    update_columns += ", photo='" + req.file.filename + "' ";
  }

  var sql = "update business_users set " + update_columns + " where id='" + id + "'";
  db.query(sql, function (err, rows, fields) {
    if (err) {
      return res.status(500).send({ status: 'error', message: 'Business user profile could not be updated.' });
    } else {
      return res.status(200).json({ status: 'success', message: 'Business user profile updated successfully.' });
    }
  });
};