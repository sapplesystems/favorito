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

        // var sql = "SELECT business_informations.id AS business_information_id, business_id, business_categories.id AS category_id, business_categories.category_name, \n\
        // sub_categories as sub_categories_id, (SELECT GROUP_CONCAT(category_name) FROM business_categories \n\
        // WHERE FIND_IN_SET(id, business_informations.sub_categories) AND deleted_at IS NULL) AS sub_categories_name, \n\
        // tags, price_range, payment_method, attributes \n\
        // FROM business_informations INNER JOIN business_categories \n\
        // ON business_informations.categories = business_categories.id \n\
        // WHERE business_id='" + business_id + "' AND business_informations.deleted_at IS NULL \n\
        // AND business_categories.deleted_at IS NULL";
        var sql = "SELECT business_informations.id AS business_information_id, business_id, business_categories.id AS category_id, business_categories.category_name, \n\
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
                // return res.send(await exports.getSubCategories(business_id))
                rows[0].sub_categories = await exports.getSubCategories(business_id);
                rows[0].tags = await exports.getTags(business_id);
                rows[0].attributes = await exports.getAttributes(business_id);
                if (rows[0].payment_method) {
                    rows[0].payment_method = (rows[0].payment_method).split(',');
                } else {
                    rows[0].payment_method = []
                }
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
exports.getBusinessInformationUpdate = async function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        var update_columns = " modified_by='" + id + "', updated_at=now() ";
        if (req.body.categories != '' && req.body.categories != 'undefined' && req.body.categories != null) {
            update_columns += ", categories='" + req.body.categories + "' ";
        }

        if (req.body.sub_categories != '' && req.body.sub_categories != 'undefined' && req.body.sub_categories != null) {
            all_sub_categories = []
            all_sub_categories_menu = []
            sub_categories = req.body.sub_categories
            var sql_get_business_type = `SELECT business_type_id FROM business_master WHERE business_id = '${business_id}'`
            var result_get_business_type = await exports.run_query(sql_get_business_type)
            sub_categories.forEach(element => {
                all_sub_categories.push([business_id, element])
                all_sub_categories_menu.push([business_id, result_get_business_type[0].business_type_id, element])
            });

            try {
                // This will work on update also
                var sql_sub_delete = `DELETE FROM business_sub_category WHERE business_id = '${business_id}'`
                await exports.run_query(sql_sub_delete)

                var sql_sub_category = 'INSERT INTO business_sub_category (business_id,sub_category_id) VALUES ?'
                await exports.run_query(sql_sub_category, [all_sub_categories])

                // check exist or not
                // checking the business_sub_category and inserting the data

                for (let i = 0; i < all_sub_categories_menu.length; i++) {
                    const element = all_sub_categories_menu[i];
                    sql_check_menu = ` SELECT COUNT(id) as count \n\
                    FROM business_menu_category \n\
                    WHERE business_id = '${business_id}' AND category_id = '${element[2]}'`
                    result_check_menu = await exports.run_query(sql_check_menu)
                    if (result_check_menu[0].count < 1) {
                        var sql_sub_category_menu = `INSERT INTO business_menu_category (business_id,menu_type_id,category_id) VALUES ('${business_id}','${element[1]}','${element[2]}')`
                        await exports.run_query(sql_sub_category_menu)
                    }
                }
            } catch (error) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
            }
        }
        if (req.body.tags != '' && req.body.tags != 'undefined' && req.body.tags != null) {
            all_tags = []
            tags = req.body.tags
            tags.forEach(element => {
                all_tags.push([business_id, element])
            });
            try {
                // This will work on update also
                var sql_tag_delete = `DELETE FROM business_tags WHERE business_id = '${business_id}'`
                await exports.run_query(sql_tag_delete)
                var sql_tag_insert = 'INSERT INTO business_tags (business_id,tag_id) VALUES ?'
                await exports.run_query(sql_tag_insert, [all_tags])
            } catch (error) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
            }
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
            all_attributes = []
            attributes = req.body.attributes
            attributes.forEach(element => {
                all_attributes.push([business_id, element])
            });
            try {
                // if the business_information is completed update the is_information_completed
                if (req.body.sub_categories && req.body.price_range && req.body.payment_method) {
                    sql_is_info_complete = `update business_master set is_information_completed = '1' where business_id = '${business_id}'`
                } else {
                    sql_is_info_complete = `update business_master set is_information_completed = '0' where business_id = '${business_id}'`
                }
                result_is_info_complete = await exports.run_query(sql_is_info_complete)

                // now checking for is_activated
                let sql_if_all_verified = `select is_verified, is_information_completed,is_profile_completed from business_master where business_id = '${business_id}'`
                let result_if_all_verified = await exports.run_query(sql_if_all_verified)
                if (result_if_all_verified[0].is_verified && result_if_all_verified[0].is_information_completed && result_if_all_verified[0].is_profile_completed) {
                    sql_update_is_activated = `update business_master set is_activated = 1 where business_id = '${business_id}'`
                    result_update_is_activated = await exports.run_query(sql_update_is_activated)
                }

                // This will work on update also
                var sql_attribute = `DELETE FROM business_attributes WHERE business_id = '${business_id}'`
                await exports.run_query(sql_attribute)
                var sql_attributes_insert = 'INSERT INTO business_attributes (business_id,attributes_id) VALUES ?'
                await exports.run_query(sql_attributes_insert, [all_attributes])
            } catch (error) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
            }
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
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', e });
    }
};

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
                    console.log(error)
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    }
}

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

exports.getSubCategories = function(business_id) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = `SELECT b_c.id as id, b_c.category_name as sub_category_name FROM business_sub_category as b_s_c JOIN business_categories as b_c WHERE b_s_c.sub_category_id = b_c.id AND b_s_c.business_id = '${business_id}'`
            db.query(sql, function(err, result) {
                resolve(result);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.getTags = function(business_id) {
    try {
        return new Promise(function(resolve, reject) {
            // var sql = "SELECT id, tag_name FROM business_tags_master \n\
            // WHERE id IN(" + tag_ids + ") AND deleted_at IS NULL";
            var sql = `SELECT b_t_m.id as id, b_t_m.tag_name as tag_name FROM business_tags as b_t JOIN business_tags_master as b_t_m WHERE b_t.tag_id = b_t_m.id AND b_t.business_id = '${business_id}'`
            db.query(sql, function(err, result) {
                resolve(result);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.getAttributes = function(business_id) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = `SELECT b_a_m.id as id, b_a_m.attribute_name as attribute_name FROM business_attributes as b_a JOIN business_attributes_master as b_a_m WHERE b_a.attributes_id = b_a_m.id AND b_a.business_id = '${business_id}'`
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