var db = require('../config/db');
var offer_status_drop_down = ['Activated', 'Deactivated'];
var offer_type_drop_down = ['New User Offer', 'Current Offer'];

/**
 * FETCH ALL OFFER
 */
exports.all_offers = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var where_condition = " WHERE business_id='" + business_id + "' AND deleted_at IS NULL ";
        if (req.body.offer_id != '' && req.body.offer_id != 'undefined' && req.body.offer_id != null) {
            where_condition += " AND id = '" + req.body.offer_id + "'";
        }
        if (req.body.offer_type != '' && req.body.offer_type != 'undefined' && req.body.offer_type != null) {
            where_condition += " AND offer_type = '" + req.body.offer_type + "'";
        }
        if (req.body.offer_status != '' && req.body.offer_status != 'undefined' && req.body.offer_status != null) {
            where_condition += " AND offer_status = '" + req.body.offer_status + "'";
        }
        var sql = "SELECT id,offer_title,offer_description,offer_type,offer_status,total_activated,total_redeemed FROM business_offers " + where_condition;
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            
            return res.status(200).json({
                status: 'success',
                message: 'success',
                offer_status_drop_down: offer_status_drop_down,
                //commented by parag data: (result.length === 1) ? result[0] : result
				data:  result
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * STATIC DROP DONW DETAI TO CREATE THE NOTIFICATION
 */
exports.dd_verbose = function (req, res, next) {
    try {
        var verbose = {};
        verbose.offer_status_drop_down = offer_status_drop_down;
        verbose.offer_type_drop_down = offer_type_drop_down;
        return res.status(200).json({ status: 'success', message: 'success', data: verbose });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * CREATE NEW OFFER
 */
exports.add_offer = function (req, res, next) {
    try {
        if (req.body.offer_title == '' || req.body.offer_title == 'undefined' || req.body.offer_title == null) {
            return res.status(403).json({ status: 'error', message: 'Offer title not found.' });
        } else if (req.body.offer_description == '' || req.body.offer_description == 'undefined' || req.body.offer_description == null) {
            return res.status(403).json({ status: 'error', message: 'Offer description not found.' });
        } else if (req.body.offer_type == '' || req.body.offer_type == 'undefined' || req.body.offer_type == null) {
            return res.status(403).json({ status: 'error', message: 'Offer type not found.' });
        } else if (req.body.offer_status == '' || req.body.offer_status == 'undefined' || req.body.offer_status == null) {
            return res.status(403).json({ status: 'error', message: 'Offer status not found.' });
        }

        var business_id = req.userdata.business_id;
        var offer_title = req.body.offer_title;
        var offer_description = req.body.offer_description;
        var offer_type = req.body.offer_type;
        var offer_status = req.body.offer_status;

        var postval = {
            business_id: business_id,
            offer_title: offer_title,
            offer_description: offer_description,
            offer_type: offer_type,
            offer_status: offer_status
        };

        var sql = "INSERT INTO business_offers set ?";
        db.query(sql, postval, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Offer created successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * EDIT OFFER
 */exports.edit_offer = function (req, res, next) {
    try {
        if (req.body.offer_id == '' || req.body.offer_id == 'undefined' || req.body.offer_id == null) {
            return res.status(403).json({ status: 'error', message: 'Offer id not found.' });
        }
        var offer_id = req.body.offer_id;
        var update_columns = " updated_at=now() ";
        if (req.body.offer_title != '' && req.body.offer_title != 'undefined' && req.body.offer_title != null) {
            update_columns += ", offer_title='" + req.body.offer_title + "'";
        }
        if (req.body.offer_description != '' && req.body.offer_description != 'undefined' && req.body.offer_description != null) {
            update_columns += ", offer_description='" + req.body.offer_description + "'";
        }
        if (req.body.offer_type != '' && req.body.offer_type != 'undefined' && req.body.offer_type != null) {
            update_columns += ", offer_type='" + req.body.offer_type + "'";
        }
        if (req.body.offer_status != '' && req.body.offer_status != 'undefined' && req.body.offer_status != null) {
            update_columns += ", offer_status='" + req.body.offer_status + "'";
        }

        var sql = "update business_offers set " + update_columns + " where id='" + offer_id + "'";
        db.query(sql, function (err, rows, fields) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Business user profile could not be updated.' });
            }
            return res.status(200).json({ status: 'success', message: 'Offer updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};