var db = require('../../config/db');

exports.getAddress = async function(req, res, next) {
    if (req.userdata.business_id) {
        var sql = "SELECT address1, address2, address3, pincode, town_city, state_id, country_id, location FROM business_master WHERE business_id = '" + req.userdata.business_id + "'";
    } else if (req.userdata.id) {
        var sql = "SELECT id, user_id, city, state, pincode, country, landmark,address, default_address FROM user_address WHERE user_id = '" + req.userdata.id + "'";
        var sql_name = "SELECT first_name, last_name FROM users WHERE id = '" + req.userdata.id + "'"

    } else {
        return res.status(500).json({ status: 'failed', message: 'Something went wrong.' });
    }
    try {
        var user_name
        db.query(sql_name, function(err, result) {
            user_name = `${result[0].first_name} ${result[0].last_name}`
        })
        db.query(sql, function(err, result) {
            return res.status(200).json({ status: 'success', message: 'success', data: { user_name: user_name, addresses: result } });
            // return res.status(200).json({ status: 'success', message: 'success', data: result });
        })
    } catch (error) {
        return res.status(500).json({ status: 'failed', message: 'Something went wrong.', error: error });
    }
}

//  on work 
exports.changeDefaultAddress = async function(req, res, next) {
    if (req.body.default_address_id == null || req.body.default_address_id == undefined || req.body.default_address_id == '') {
        return res.status(400).json({ status: 'failed', message: 'Something went wrong.' });
    }
    var user_id = req.userdata.id
    var sql = "UPDATE user_address SET default_address=0 WHERE user_id='" + user_id + "'";
    update_result = await exports.executeSql(sql, res)
    if (parseInt(update_result.affectedRows) > 0) {
        var sql = "UPDATE user_address SET default_address=1 WHERE id='" + req.body.default_address_id + "'";
        update_result_2 = await exports.executeSql(sql, res)
        if (update_result_2) {
            res.status(200).send({ status: 'success', message: 'update done' })
        }
    }
}

exports.changeAddress = async function(req, res, next) {
    var set = "updated_at=NOW() "
    if (req.userdata.business_id) {
        if (req.userdata.address1 || req.userdata.business_id || req.userdata.business_id) {
            if (req.body.address1) {
                set += ", address1 = '" + req.body.address1 + "'"
            }
            if (req.body.address2) {
                set += ", address2 = '" + req.body.address2 + "'"
            }
            if (req.body.address3) {
                set += ", address3 = '" + req.body.address3 + "'"
            }
            try {
                var sql = "UPDATE business_master SET " + set + " WHERE business_id='" + req.userdata.business_id + "'";
                update_result = await exports.executeSql(sql, res)
                if (parseInt(update_result.affectedRows) > 0) {
                    return res.status(200).send({ status: 'success', message: 'update done' })
                }
            } catch (error) {
                return res.status(400).json({ status: 'failed', message: 'Something went wrong' });
            }
        } else {
            return res.status(400).json({ status: 'failed', message: 'New address is missing' });
        }
    } else if (req.userdata.id) {
        // For update the user address by the address id
        if (req.body.address_id) {
            var set = "updated_at=NOW() "
            if (req.body.city) {
                set += ", city = '" + req.body.city + "'"
            }
            if (req.body.state) {
                set += ", state = '" + req.body.state + "'"
            }
            if (req.body.pincode) {
                set += ", pincode = '" + req.body.pincode + "'"
            }
            if (req.body.country) {
                set += ", country = '" + req.body.country + "'"
            }
            if (req.body.landmark) {
                set += ", landmark = '" + req.body.landmark + "'"
            }
            if (req.body.address) {
                set += ", address = '" + req.body.address + "'"
            }
            try {
                var sql = "UPDATE user_address SET " + set + " WHERE id='" + req.body.address_id + "'";
                update_result = await exports.executeSql(sql, res)
                if (parseInt(update_result.affectedRows) > 0) {
                    return res.status(200).send({ status: 'success', message: 'update done' })
                }
            } catch (error) {
                return res.status(400).json({ status: 'failed', message: 'Something went wrong' });
            }

        } else {
            try {

                if (req.body.city) {
                    city = req.body.city
                }
                if (req.body.state) {
                    state = req.body.state
                }
                if (req.body.pincode) {
                    pincode = req.body.pincode
                }
                if (req.body.country) {
                    country = req.body.country
                }
                if (req.body.landmark) {
                    landmark = req.body.landmark
                }
                if (req.body.address) {
                    address = req.body.address
                }
                var user_id = req.userdata.id
                data_to_enter = {
                    city: city,
                    state: state,
                    pincode: pincode,
                    country: country,
                    landmark: landmark,
                    address: address,
                    user_id: user_id
                }

                var sql = "INSERT user_address SET ?";
                db.query(sql, data_to_enter, function(err, result) {
                    if (err) {
                        return res.status(400).json({ status: 'failed', message: 'Something went wrong', error: err });
                    } else {
                        return res.status(200).send({ status: "success", message: "insert successfull" })
                    }
                })
            } catch (error) {
                return res.status(400).json({ status: 'failed', message: 'Something went wrong' });
            }
        }
    }
}


exports.executeSql = function(sql, res) {
    return new Promise(function(resolve, reject) {
        db.query(sql, function(err, result) {
            if (err) {
                console.log('file change')

                return res.status(500).send({ status: "failed", message: "error occured", error: err })
            } else {
                return resolve(result)
            }
        })

    })
}