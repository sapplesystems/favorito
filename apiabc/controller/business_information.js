var db = require('../config/db');
var dd_verbose = {
    static_payment_method: ['Cash Only', 'Cash & Cards', 'Favorito Pay'],
    static_price_range: [10, 100, 1000, 10000]
};
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

/**
 * FETCH BUSINESS USER PROFILE INFORMATION (BUSINESS USER) START HERE
 */
exports.getBusinessInformation = async function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        dd_verbose.tag_list = await exports.getTagList();
        dd_verbose.attribute_list = await exports.geAttributeList();

        var sql = "SELECT business_informations.id AS business_information_id, business_id, business_categories.id AS category_id, business_categories.category_name, \n\
        sub_categories as sub_categories_id, (SELECT GROUP_CONCAT(category_name) FROM business_categories \n\
        WHERE FIND_IN_SET(id, business_informations.sub_categories) AND deleted_at IS NULL) AS sub_categories_name, \n\
        tags, price_range, payment_method, attributes \n\
        FROM business_informations INNER JOIN business_categories \n\
        ON business_informations.categories = business_categories.id \n\
        WHERE business_id='" + business_id + "' AND business_informations.deleted_at IS NULL \n\
        AND business_categories.deleted_at IS NULL";
        db.query(sql, async function(err, rows, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(403).send({ status: 'error', message: 'No recored found.' });
            } else {
                var sub_categories_id = rows[0].sub_categories_id;
                var tags = rows[0].tags;
                var attributes = rows[0].attributes;
                rows[0].sub_categories = await exports.getSubCategories(sub_categories_id);
                rows[0].tags = await exports.getTags(tags);
                rows[0].attributes = await exports.getAttributes(attributes);
                rows[0].payment_method = (rows[0].payment_method).split(',');
                rows[0].photos = await exports.getBusinessInformationUploads(business_id);
                return res.status(200).json({ status: 'success', message: 'success', dd_verbose: dd_verbose, data: rows[0] });
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * BUSINESS USER PROFILE INFORMATION (BUSINESS USER) START HERE
 */
exports.getBusinessInformationUpdate = function(req, res, next) {
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
            var tags = req.body.tags;
            tags = tags.join();
            update_columns += ", `tags`='" + tags + "' ";
        }
        if (req.body.price_range != '' && req.body.price_range != 'undefined' && req.body.price_range != null) {
            update_columns += ", price_range='" + req.body.price_range + "' ";
        }
        if (req.body.payment_method != '' && req.body.payment_method != 'undefined' && req.body.payment_method != null) {
            var pm = req.body.payment_method;
            pm = pm.join();
            update_columns += ", payment_method='" + pm + "' ";
        }
        if (req.body.attributes != '' && req.body.attributes != 'undefined' && req.body.attributes != null) {
            var attributes = req.body.attributes;
            attributes = attributes.join();
            update_columns += ", attributes='" + attributes + "' ";
        }

        var sql = "update business_informations set " + update_columns + " where business_id='" + business_id + "'";
        db.query(sql, function(err, rows, fields) {
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
exports.addPhotos = async function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        if (req.files && req.files.length) {
            var file_count = req.files.length;
            for (var i = 0; i < file_count; i++) {
                var filename = req.files[i].filename;
                var sql = "INSERT INTO `business_uploads`(business_id, asset_url, uploaded_by) \n\
                        VALUES ('" + business_id + "','" + filename + "','" + id + "')";
                db.query(sql);
            }
            var data = await exports.getBusinessInformationUploads(business_id);
            return res.status(200).json({ status: 'success', message: 'Photo uploaded successfully.', data: data });
        } else {
            return res.status(200).json({ status: 'success', message: 'No photo found to upload.' });
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


exports.getTagList = function(req, res, next) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = "SELECT id,tag_name FROM business_tags_master where deleted_at is null";
            db.query(sql, function(err, result) {
                resolve(result);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.geAttributeList = function(req, res, next) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = "SELECT id,attribute_name FROM business_attributes_master where deleted_at is null";
            db.query(sql, function(err, result) {
                resolve(result);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.getSubCategories = function(sub_category_ids) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = "SELECT id, category_name as `sub_category_name` FROM business_categories \n\
            WHERE id IN(" + sub_category_ids + ") AND deleted_at IS NULL";
            db.query(sql, function(err, result) {
                resolve(result);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.getTags = function(tag_ids) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = "SELECT id, tag_name FROM business_tags_master \n\
            WHERE id IN(" + tag_ids + ") AND deleted_at IS NULL";
            db.query(sql, function(err, result) {
                resolve(result);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.getAttributes = function(attibute_ids) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = "SELECT id, attribute_name FROM business_attributes_master \n\
            WHERE id IN(" + attibute_ids + ") AND deleted_at IS NULL";
            db.query(sql, function(err, result) {
                resolve(result);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.getBusinessInformationUploads = function(business_id) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = "select id, type, concat('" + img_path + "',asset_url) as photo from business_uploads where business_id='" + business_id + "' and is_deleted='0' and deleted_at is null";
            db.query(sql, function(err, result) {
                resolve(result)
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};