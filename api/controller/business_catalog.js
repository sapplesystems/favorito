var db = require('../config/db');

/**
 * LIST ALL CATALOG
 */
exports.listCatalog = function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        var cond = '';
        if (req.body.catalog_id != '' && req.body.catalog_id != 'undefined' && req.body.catalog_id != null) {
            cond = " AND c.id='" + req.body.catalog_id + "' ";
        }

        var sql = "SELECT c.id,catalog_title,catalog_price,catalog_desc,product_url,product_id,GROUP_CONCAT(p.id) AS photos_id,GROUP_CONCAT(p.photos) AS photos \n\
                FROM business_catalogs AS c  \n\
                LEFT JOIN business_catalog_photos AS p ON  \n\
                c.id=p.business_catalog_id \n\
                WHERE c.business_id='"+ business_id + "' " + cond + " AND c.deleted_at IS NULL AND p.deleted_at IS NULL \n\
                GROUP BY c.id";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * FIND CATALOG BY ID
 */
exports.findCatalog = function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        if (req.body.catalog_id == '' || req.body.catalog_id == 'undefined' || req.body.catalog_id == null) {
            return res.status(404).json({ status: 'error', message: 'Catalog id not found.' });
        }

        var cond = " AND c.id='" + req.body.catalog_id + "' ";

        var sql = "SELECT c.id,catalog_title,catalog_price,catalog_desc,product_url,product_id,GROUP_CONCAT(p.id) AS photos_id,GROUP_CONCAT(p.photos) AS photos \n\
                FROM business_catalogs AS c  \n\
                LEFT JOIN business_catalog_photos AS p ON  \n\
                c.id=p.business_catalog_id \n\
                WHERE c.business_id='"+ business_id + "' " + cond + " AND c.deleted_at IS NULL AND p.deleted_at IS NULL \n\
                GROUP BY c.id";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};



/**
 * BUSINESS CATALOG ADD
 */
exports.addCatalog = function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        if (req.body.catalog_title == '' || req.body.catalog_title == 'undefined' || req.body.catalog_title == null) {
            return res.status(404).json({ status: 'error', message: 'Catalog title not found.' });
        } else if (req.body.catalog_price == '' || req.body.catalog_price == 'undefined' || req.body.catalog_price == null) {
            return res.status(404).json({ status: 'error', message: 'Catalog price not found.' });
        } else if (req.body.catalog_desc == '' || req.body.catalog_desc == 'undefined' || req.body.catalog_desc == null) {
            return res.status(404).json({ status: 'error', message: 'Catalog description not found.' });
        } else if (req.body.product_url == '' || req.body.product_url == 'undefined' || req.body.product_url == null) {
            return res.status(404).json({ status: 'error', message: 'Product url not found.' });
        } else if (req.body.product_id == '' || req.body.product_id == 'undefined' || req.body.product_id == null) {
            return res.status(404).json({ status: 'error', message: 'Product id not found.' });
        }

        var postval = {
            business_id: business_id,
            catalog_title: req.body.catalog_title,
            catalog_price: req.body.catalog_price,
            catalog_desc: req.body.catalog_desc,
            product_url: req.body.product_url,
            product_id: req.body.product_id
        };

        var sql = "INSERT INTO business_catalogs set ?";

        db.query(sql, postval, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Catalog saved successfully.' });
            /*else {
                var last_insert_id = result.insertId;
                if (req.files && req.files.length) {
                    var file_count = req.files.length;
                    for (var i = 0; i < file_count; i++) {
                        var filename = req.files[i].filename;
                        var sql = "INSERT INTO `business_catalogs_photos`(business_id, business_catalog_id, photos) \n\
                                    VALUES ('"+ business_id + "','" + last_insert_id + "','" + filename + "')";
                        db.query(sql);
                    }
                    return res.status(200).json({ status: 'success', message: 'Catalog saved successfully.' });
                } else {
                    var sql = "INSERT INTO `business_catalogs_photos`(business_id, business_catalog_id) \n\
                                    VALUES ('"+ business_id + "','" + last_insert_id + "')";
                    db.query(sql, function (e, r) {
                        return res.status(200).json({ status: 'success', message: 'Catalog saved successfully.' });
                    });
                }
            }*/
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * BUSINESS CATALOG UPDATE
 */
exports.updateCatalog = function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        if (req.body.catalog_id == '' || req.body.catalog_id == 'undefined' || req.body.catalog_id == null) {
            return res.status(404).json({ status: 'error', message: 'Catelog id not found.' });
        }

        var catalog_id = req.body.catalog_id;

        var update_columns = " updated_at=now() ";

        if (req.body.catalog_title != '' && req.body.catalog_title != 'undefined' && req.body.catalog_title != null) {
            update_columns += ", catalog_title='" + req.body.catalog_title + "' ";
        }
        if (req.body.catalog_price != '' && req.body.catalog_price != 'undefined' && req.body.catalog_price != null) {
            update_columns += ", catalog_price='" + req.body.catalog_price + "' ";
        }
        if (req.body.catalog_desc != '' && req.body.catalog_desc == 'undefined' && req.body.catalog_desc != null) {
            update_columns += ", catalog_desc='" + req.body.catalog_desc + "' ";
        }
        if (req.body.product_url != '' && req.body.product_url != 'undefined' && req.body.product_url != null) {
            update_columns += ", product_url='" + req.body.product_url + "' ";
        }
        if (req.body.product_id != '' && req.body.product_id != 'undefined' && req.body.product_id != null) {
            update_columns += ", product_id='" + req.body.product_id + "' ";
        }

        var sql = "UPDATE business_catalogs SET " + update_columns + " WHERE id='" + catalog_id + "' AND business_id='" + business_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({
                status: 'success',
                message: 'Job updated successfully.',
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * BUSINESS CATALOG ADD PHOTO
 */
exports.addPhotos = function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        if (req.body.catalog_id == '' || req.body.catalog_id == 'undefined' || req.body.catalog_id == null) {
            return res.status(404).json({ status: 'error', message: 'Catelog id not found.' });
        }
        var catalog_id = req.body.catalog_id;

        if (req.files && req.files.length) {
            var file_count = req.files.length;
            for (var i = 0; i < file_count; i++) {
                var filename = req.files[i].filename;
                var sql = "INSERT INTO `business_catalog_photos`(business_id, business_catalog_id, photos) \n\
                        VALUES ('"+ business_id + "','" + catalog_id + "','" + filename + "')";
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