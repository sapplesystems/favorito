var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

exports.businessDetail = async function(req, res, next) {
    await exports.getBusinessDetail(req, res)
}

// Details of business by business id 
exports.getBusinessDetail = async function(req, res) {
    try {
        business_id = req.body.business_id
        var sql = "SELECT id,business_id,business_name,postal_code,business_phone,landline,reach_whatsapp, \n\
        business_email,concat('" + img_path + "',photo) as photo, address1,address2,address3,pincode,town_city,state_id,country_id, \n\
        location, by_appointment_only, working_hours, website,short_description,business_status \n\
        FROM business_master WHERE business_id='" + business_id + "' and is_activated=1 and deleted_at is null";
        await db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

/**
 * LIST ALL CATALOG
 */
exports.getListCatalog = function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.body.business_id;
        var cond = '';
        if (req.body.catalog_id != '' && req.body.catalog_id != 'undefined' && req.body.catalog_id != null) {
            cond = " AND c.id='" + req.body.catalog_id + "' ";
        }

        var sql = "SELECT c.id,catalog_title,catalog_price,catalog_desc,product_url,product_id,GROUP_CONCAT(p.id) AS photos_id,GROUP_CONCAT('" + img_path + "',p.photos) AS photos \n\
                FROM business_catalogs AS c  \n\
                LEFT JOIN business_catalog_photos AS p ON  \n\
                c.id=p.business_catalog_id \n\
                WHERE c.business_id='" + business_id + "' " + cond + " AND c.deleted_at IS NULL AND p.deleted_at IS NULL \n\
                GROUP BY c.id";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.all_business_reviewlist = function(req, res, next) {
    try {
        var business_id = req.body.business_id;
        var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%Y-%m-%d') as review_date, \n\
        DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY id DESC";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            if (result.length > 0) {
                return res.status(200).json({ status: 'success', message: 'success', data: result });
            } else {
                return res.status(200).json({ status: 'success', message: 'NO Data Found', data: [] });
            }

        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};