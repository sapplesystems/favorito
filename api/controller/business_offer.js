var db = require('../config/db');
var offer_status_drop_down = ['Activated', 'Deactivated'];
var offer_type_drop_down = ['New User Offer', 'Current Offer'];

/**
 * FETCH ALL OFFER
 */
exports.all_offers = function (req, res, next) {
    var business_id = req.userdata.business_id;
    var where_condition = " WHERE business_id='" + business_id + "' AND deleted_at IS NULL ";
    if (req.body.offer_type != '' && req.body.offer_type != 'undefined' && req.body.offer_type != null) {
        where_condition += " AND offer_type = '" + req.body.offer_type + "'";
    }
    if (req.body.offer_status != '' && req.body.offer_status != 'undefined' && req.body.offer_status != null) {
        where_condition += " AND offer_status = '" + req.body.offer_status + "'";
    }
    var sql = "SELECT offer_title,offer_description,offer_type,offer_status,total_activated,total_redeemed FROM business_offers " + where_condition;
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
        }
        return res.status(200).json({
            status: 'success',
            message: 'success',
            offer_status_drop_down: offer_status_drop_down,
            data: result
        });
    });
};

/**
 * STATIC DROP DONW DETAI TO CREATE THE NOTIFICATION
 */
exports.dd_verbose = function (req, res, next) {
    var verbose = {};
    verbose.offer_status_drop_down = offer_status_drop_down;
    verbose.offer_type_drop_down = offer_type_drop_down;
    return res.status(200).json({ status: 'success', message: 'success', data: verbose });
};


/**
 * CREATE NEW OFFER
 */
exports.add_offer = function (req, res, next) {
    if (req.body.offer_title == '' || req.body.offer_title == 'undefined' || req.body.offer_title == null) {
        return res.status(404).json({ status: 'error', message: 'Offer title not found.' });
    } else if (req.body.offer_description == '' || req.body.offer_description == 'undefined' || req.body.offer_description == null) {
        return res.status(404).json({ status: 'error', message: 'Offer description not found.' });
    } else if (req.body.offer_type == '' || req.body.offer_type == 'undefined' || req.body.offer_type == null) {
        return res.status(404).json({ status: 'error', message: 'Offer type not found.' });
    } else if (req.body.offer_status == '' || req.body.offer_status == 'undefined' || req.body.offer_status == null) {
        return res.status(404).json({ status: 'error', message: 'Offer status not found.' });
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
};