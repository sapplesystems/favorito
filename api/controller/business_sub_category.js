var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

/*SELECT ALL BUSINESS CATEGORY*/
exports.all_business_sub_category = function(req, res, next) {
    try {
        if (req.body.category_id == '' || req.body.category_id == 'undefined' || req.body.category_id == null) {
            return res.status(403).json({ status: 'error', message: 'Business category id required' });
        }
        var sql = "SELECT id, category_name as `sub_category_name` FROM business_categories WHERE parent_id='" + req.body.category_id + "' and is_activated='1' and deleted_at IS NULL";
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


exports.all_business_main_category = function(req, res, next) {
    try {
        if (req.body.business_type_id == '' || req.body.business_type_id == 'undefined' || req.body.business_type_id == null) {
            return res.status(403).json({ status: 'error', message: 'Business type id required' });
        }
        var sql = "SELECT id, category_name as `sub_category_name` FROM business_categories WHERE business_type_id='" + req.body.business_type_id + "' and parent_id=0 and is_activated='1' and deleted_at IS NULL";
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

// return data from the all_business_sub_category table
exports.getSubCategoriesByBusiness = async(req, res) => {
    if (req.body.business_id) {
        business_id = req.body.business_id
    } else {
        return res.status(400).json({ status: 'error', message: 'business_id is missing' });
    }
    var sql = `SELECT b_s_c.sub_category_id as category_id, b_c.category_name as sub_category_name FROM business_sub_category as b_s_c JOIN business_categories as b_c WHERE b_s_c.sub_category_id = b_c.id AND b_s_c.business_id = '${business_id}'`

    try {
        var result = await exports.run_query(sql)
        return res.status(200).json({ status: 'success', message: 'success', data: result });

    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong', error });
    }
}

exports.deleteSubCategory = async(req, res) => {
    if (req.userdata.business_id && req.body.sub_category_id) {
        var sql_delete_sub_category = ` DELETE \n\
        FROM business_sub_category \n\
        WHERE business_id = '${req.userdata.business_id}' AND sub_category_id = '${req.body.sub_category_id}'`
            //  delete item also

        var sql_get_category_menu_id = `SELECT id \n\
        FROM business_menu_category \n\
        WHERE business_id = '${req.userdata.business_id}' AND category_id = '${req.body.sub_category_id}'`


        var sql_menu_category = `DELETE \n\
        FROM business_menu_category \n\
        WHERE business_id = '${req.userdata.business_id}' AND category_id = '${req.body.sub_category_id}'`
        try {
            //  put check here

            result_category_menu_id = await exports.run_query(sql_get_category_menu_id)
            var sql_delete_menu_item = `DELETE \n\
            FROM business_menu_item \n\
            WHERE business_id = '${req.userdata.business_id}' AND menu_category_id = '${result_category_menu_id[0].id}'`


            result = await exports.run_query(sql_delete_menu_item)
            await exports.run_query(sql_delete_sub_category)
            await exports.run_query(sql_menu_category)

            return res.status(200).json({ status: 'success', message: 'Deleted successfull' });
        } catch (error) {
            return res.status(400).json({ status: 'error', message: 'Something went wrong', error });
        }
    } else {
        return res.status(400).json({ status: 'error', message: 'sub_category_id is missing' });
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
                    console.log(error)
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    }
}