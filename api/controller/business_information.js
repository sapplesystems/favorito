var db = require('../config/db');

/**
 * FETCH BUSINESS USER PROFILE INFORMATION (BUSINESS USER) START HERE
 */
exports.getBusinessInformation = function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;
        var sql = "SELECT business_informations.id AS business_information_id, business_id, business_categories.id AS category_id, business_categories.category_name, \n\
        sub_categories as sub_categories_id, (SELECT GROUP_CONCAT(sub_category_name) FROM business_sub_categories \n\
        WHERE FIND_IN_SET(id, business_informations.sub_categories) AND deleted_at IS NULL) AS sub_categories_name, \n\
        tags, price_range, payment_method, attributes \n\
        FROM business_informations INNER JOIN business_categories \n\
        ON business_informations.categories = business_categories.id \n\
        WHERE business_id='"+ business_id + "' AND business_informations.deleted_at IS NULL \n\
        AND business_categories.deleted_at IS NULL";
        db.query(sql, function (err, rows, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(403).send({ status: 'error', message: 'No recored found.' });
            } else {
                /*var sub_categories_id = rows[0].sub_categories_id;
                var sub_categories_name = rows[0].sub_categories_name;
                rows[0].sub_categories_id = sub_categories_id.split(',');
                rows[0].sub_categories_name = sub_categories_name.split(',');*/

                var q = "select id, type, asset_url as photo from business_uploads where business_id='" + business_id + "' and is_deleted='0' and deleted_at is null";
                db.query(q, function (e, r, f) {
                    rows[0].photos = r;
                    return res.status(200).json({ status: 'success', message: 'success', data: rows[0] });
                });
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * BUSINESS USER PROFILE INFORMATION (BUSINESS USER) START HERE
 */
exports.getBusinessInformationUpdate = function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        var update_columns = " modified_by='" + id + "', updated_at=now() ";
        if (req.body.categories != '' && req.body.categories != 'undefined' && req.body.categories != null) {
            update_columns += ", categories='" + req.body.categories + "' ";
        }
        if (req.body.sub_categories != '' && req.body.sub_categories != 'undefined' && req.body.sub_categories != null) {
            var sub_categories = req.body.sub_categories;
            sub_categories = sub_categories.join();
            update_columns += ", sub_categories='" + sub_categories + "' ";
        }
        if (req.body.tags != '' && req.body.tags != 'undefined' && req.body.tags != null) {
            update_columns += ", `tags`='" + req.body.tags + "' ";
        }
        if (req.body.price_range != '' && req.body.price_range != 'undefined' && req.body.price_range != null) {
            update_columns += ", price_range='" + req.body.price_range + "' ";
        }
        if (req.body.payment_method != '' && req.body.payment_method != 'undefined' && req.body.payment_method != null) {
            update_columns += ", payment_method='" + req.body.payment_method + "' ";
        }
        if (req.body.attributes != '' && req.body.attributes != 'undefined' && req.body.attributes != null) {
            var attributes = req.body.attributes;
            attributes = attributes.join();
            update_columns += ", attributes='" + attributes + "' ";
        }

        var sql = "update business_informations set " + update_columns + " where business_id='" + business_id + "'";
        db.query(sql, function (err, rows, fields) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(403).json({ status: 'error', message: 'No recored found.' });
            } else {
                return res.status(200).json({ status: 'success', message: 'Information updated successfully.' });
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * BUSINESS OWNER PROFILE ADD ANOTHER BRANCH
 */
exports.addPhotos = function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        if (req.files && req.files.length) {
            var file_count = req.files.length;
            for (var i = 0; i < file_count; i++) {
                var filename = req.files[i].filename;
                var sql = "INSERT INTO `business_uploads`(business_id, asset_url, uploaded_by) \n\
                        VALUES ('"+ business_id + "','" + filename + "','" + id + "')";
                db.query(sql);
            }
            return res.status(200).json({ status: 'success', message: 'Photo uploaded successfully.' });
        } else {
            return res.status(200).json({ status: 'success', message: 'No photo found to upload.' });
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};