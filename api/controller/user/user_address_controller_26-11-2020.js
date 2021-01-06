var db = require('../../config/db');

exports.getAddress = async function(req, res, next) {
    if (req.userdata.business_id) {
        var sql = "SELECT address1, address2, address3, pincode, town_city, state_id, country_id, location FROM business_master WHERE business_id = '" + req.userdata.business_id + "'";
    } else if (req.userdata.id) {
        var sql = "SELECT * FROM business_master WHERE id = '" + req.userdata.id + "'";
    } else {
        return res.status(500).json({ status: 'failed', message: 'Something went wrong.' });
    }
    try {
        db.query(sql, function(err, result) {
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        })
    } catch (error) {
        return res.status(500).json({ status: 'failed', message: 'Something went wrong.', error: error });
    }
}