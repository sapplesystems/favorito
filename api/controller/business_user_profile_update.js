var db = require('../config/db');
var bcrypt = require('bcrypt');



exports.updateProfilePhoto = function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        var update_columns = " updated_by='" + id + "', updated_at=now() ";

        if (!req.file || req.file.filename == '') {
            return res.status(403).json({ status: 'error', message: 'Profile image not found' });
        }

        if (req.file && req.file.filename != '') {
            update_columns += ", photo='" + req.file.filename + "' ";
        }

        var sql = "update business_master set " + update_columns + " where id='" + id + "'";
        db.query(sql, function(err, rows, fields) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Business user profile photo could not be updated.' });
            }
            return res.status(200).json({ status: 'success', message: 'Business user profile photo updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.updateProfile = async function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;
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

        if (req.body.location != '' && req.body.location != null) {
            update_columns += ", location='" + req.body.location + "' ";
        }
        if (req.body.by_appointment_only != 'undefined' && req.body.by_appointment_only != '' && req.body.by_appointment_only != null) {
            update_columns += ", by_appointment_only='" + req.body.by_appointment_only + "' ";
        }


        if (req.body.working_hours != '' && req.body.working_hours != null) {
            if (req.body.working_hours === 'Select Hours') {
                saveBusinessHours(business_id, req.body.business_hours);
            }
            if (req.body.working_hours === 'Always Open') {
                let days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                var business_hours_always_open = []
                for (let i = 0; i < days.length; i++) {
                    business_hours_always_open.push({ business_days: days[i], business_start_hours: "00:00", business_end_hours: "23:59" })
                }
                saveBusinessHours(business_id, business_hours_always_open);

            }
            update_columns += ", working_hours='" + req.body.working_hours + "' ";
        }

        if (website_arr != '' && website_arr != undefined) {
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

        if (req.body.business_name && req.body.business_phone && address_arr && req.body.pincode && req.body.town_city && req.body.state_id && req.body.country_id && req.body.location & req.body.working_hours && website_arr && req.body.business_email) {
            update_columns += ", is_profile_completed='1' ";
        } else {
            update_columns += ", is_profile_completed='0' ";
        }

        var sql = "update business_master set " + update_columns + " where id='" + id + "'";
        db.query(sql, function(err, rows, fields) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Business user profile could not be updated.', err });
            }
            return res.status(200).json({ status: 'success', message: 'Business user profile updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

function saveBusinessHours(business_id, business_hours) {
    try {
        var sql = "delete from business_hours where business_id='" + business_id + "'";
        db.query(sql, function(err, rows, fields) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Business user profile could not be updated.' });
            } else {
                var arr_len = business_hours.length;
                for (var i = 0; i < arr_len; i++) {
                    var day = business_hours[i]['business_days'];
                    var start_time = business_hours[i]['business_start_hours'];
                    var end_time = business_hours[i]['business_end_hours'];
                    db.query("insert into business_hours(business_id, `day`, start_hours, end_hours) values('" + business_id + "','" + day + "','" + start_time + "','" + end_time + "')");
                }
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

exports.run_query = (sql, param = false) => {
    if (param == false) {
        return new Promise((resolve, reject) => {
            db.query(sql, (error, result) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    } else {
        return new Promise((resolve, reject) => {
            db.query(sql, param, (error, result) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    }
}