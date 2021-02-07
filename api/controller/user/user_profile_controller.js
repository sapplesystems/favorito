var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var fs = require('fs')

exports.businessCarouselList = async function(req, res, next) {
    await exports.getCaruoselData(req, res)
}

exports.getCaruoselData = async function(req, res) {
    try {
        var business_id = null
        if (req.body.business_id != null && req.body.business_id != '' && req.body.business_id != undefined) {
            business_id = req.body.business_id
        } else if (req.userdata.business_id != null && req.userdata.business_id != '' && req.userdata.business_id != undefined) {
            business_id = req.body.business_id
        }

        if (business_id != null) {
            var sql = 'SELECT id, business_id, CONCAT("' + img_path + '",asset_url) as photo FROM business_uploads WHERE type = "Photo" AND business_id = "' + business_id + '"'
        } else {
            var sql = 'SELECT id, business_id, CONCAT("' + img_path + '",asset_url) as photo FROM business_uploads WHERE type = "Photo" GROUP BY business_id LIMIT 20'
        }

        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

exports.getUserReview = async function(req, res, next) {
    try {
        if (!req.userdata.id) {
            return res.status(400).json({ status: 'error', message: 'user_id is missing.' });
        }
        var sql = `SELECT id,business_id,reviews,created_at FROM business_reviews WHERE user_id = '${req.userdata.id}' AND b_to_u = 0 AND parent_id = 0`
        var result = await exports.run_query(sql)
        if (result == '') {
            return res.status(200).send({ status: 'success', message: 'No review found', data: result })
        }
        return res.status(200).send({ status: 'success', message: 'success', data: result })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.', error })
    }
}



exports.userProfilePhoto = async function(req, res, next) {
    if (req.userdata.id) {
        user_id = req.userdata.id
    }
    try {
        var sql = "SELECT concat('" + img_path + "',photo) as photo  FROM users WHERE id = '" + user_id + "' AND deleted_at IS NULL"
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            if (result && result[0] && result[0].photo) {
                result[0].photo = result[0].photo.trim()
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

exports.setUserProfilePhoto = async function(req, res, next) {
    try {
        if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
            user_id = req.userdata.id;
        } else if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
            user_id = req.body.id;
        } else {
            return res.status(500).json({ status: 'error', message: 'user_id is missing' });
        }

        if (req.file && req.file.filename != '') {

            sql_get_photo = `SELECT photo FROM users where id = '${req.userdata.id}'`
            result_get_photo = await exports.run_query(sql_get_photo)
            if (result_get_photo != '') {
                path_photo = '././public/uploads/' + result_get_photo[0].photo
            }
            if (fs.existsSync(path_photo)) {
                fs.unlink(path_photo, (error) => {
                    if (error) {
                        return res.status(500).json({ status: 'error', message: 'Something went wrong while changing the profile image' });
                    }
                })
            }

            var sql = `UPDATE users set photo = '${req.file.filename}' where id = ${user_id}`
            db.query(sql, function(err, result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                }
                user_profile_pic_link = img_path + req.file.filename
                return res.status(200).send({ status: 'success', message: 'respone successfull', data: [user_profile_pic_link] })
            })
        } else {
            res.status(400).json({ status: 'failed', message: 'Profile picture is missing' })
        }
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}


// return all the photos uploaded by the user
exports.userAllPhoto = async function(req, res, next) {
    try {
        var sql = "SELECT concat('" + img_path + "',image) as photo  FROM user_photos WHERE user_id = '" + req.body.user_id + "' AND deleted_at IS NULL"
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

// return the business of the users favorite
exports.userFavouriteBusiness = async function(req, res, next) {
    // relation_type code for the favorite is 4

    if (!req.userdata.id) {
        return res.status(400).json({ status: 'error', message: 'user_id is missing.' });
    }

    var sql = `SELECT u_b_r.id as relation_id, b_m.business_id, b_m.business_name, b_m.business_phone, b_m.landline,b_m.business_email,b_m.photo,b_m.website ,b_m.short_description \n\
    FROM business_master as b_m \n\
    JOIN user_business_relation as u_b_r ON u_b_r.target_id = b_m.business_id \n\ 
    WHERE u_b_r.source_id = '${req.userdata.id}' AND relation_type = 4`

    try {
        result = await exports.run_query(sql)
        if (result != '') {
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        } else {
            return res.status(200).json({ status: 'success', message: 'There is no favourite business', data: result });
        }
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: error });
    }
}


exports.userGetBadges = function(req, res, next) {
    try {
        // return res.send(req.body.user_id)
        if (req.body.user_id == null || req.body.user_id == undefined || req.body.user_id == '') {
            return res.status(500).json({ status: 'error', message: 'User id is not found', error: err });
        }
        var sql = "SELECT badge_id FROM user_badges WHERE user_id = '" + req.body.user_id + "'"
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'Successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}





// Favorite function

//  set favorite , friend req , friend, block ,follow all in same api 
// send relation ship type and id 
// also handled could not send friend request to the blocked person and vice versa
exports.userBusinessRelation = async(req, res, next) => {
    switch (req.body.api_type) {
        case 'set':
            if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
                var business_id = req.userdata.business_id;
                source_id = business_id;
                if (req.body.target_id != null && req.body.target_id != undefined && req.body.target_id != '') {
                    var target_id = req.body.target_id;
                } else {
                    return res.status(500).json({ status: 'error', message: 'user_id is missing' });
                }
            } else if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
                var target_id = req.body.business_id;
                if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
                    var source_id = req.userdata.id;
                } else {
                    return res.status(500).json({ status: 'error', message: 'user_id is missing' });
                }
            } else {
                return res.status(500).json({ status: 'error', message: 'business_id is missing' });
            }
            if (req.body.relation_type != null && req.body.relation_type != undefined && req.body.relation_type != '') {
                relation_type = req.body.relation_type
            } else {
                return res.status(500).json({ status: 'error', message: 'relation_type is missing' });
            }
            try {
                var data_to_insert = { source_id, target_id, relation_type }
                var sql_count_universal = `SELECT COUNT(*) as count, id, relation_type FROM user_business_relation WHERE source_id = '${source_id}' AND target_id = '${target_id}'`
                var sql_insert = `INSERT INTO user_business_relation SET ? `
                result_count_universal = await exports.run_query(sql_count_universal)
                if (result_count_universal[0].count == 0 && relation_type == 3 && relation_type == 4) {
                    result_insert = await exports.run_query(sql_insert, data_to_insert)
                    return res.status(200).send({ status: 'success', message: 'Successfull' })
                } else {
                    var sql_count = `SELECT COUNT(*) as count, id, relation_type FROM user_business_relation WHERE source_id = '${source_id}' AND target_id = '${target_id}' AND relation_type ='${relation_type}'`
                    result_count = await exports.run_query(sql_count)
                    if (relation_type == 5) {
                        var sql_count_check_relation = `SELECT COUNT(*) as count, id, relation_type FROM user_business_relation WHERE source_id = '${source_id}' AND target_id = '${target_id}' AND (relation_type = 1 OR relation_type = 2 OR relation_type = 5)`
                        result_count_check_relation = await exports.run_query(sql_count_check_relation)
                            // res.send(result_count_check_relation)
                        if (result_count_check_relation[0].count == 0) {
                            var sql_insert_relation = `INSERT INTO user_business_relation SET ? `
                            sql_insert_relation_result = await exports.run_query(sql_insert_relation, data_to_insert)
                            if (sql_insert_relation_result.affectedRows > 0) {
                                return res.status(200).send({ status: 'success', message: 'Relation is inserted' })
                            }
                        } else {
                            var sql_insert = `UPDATE user_business_relation SET ? WHERE id='${result_count_check_relation[0].id}'`
                            var data_to_insert = { relation_type }
                            result_insert = await exports.run_query(sql_insert, data_to_insert)
                            return res.status(200).send({ status: 'success', message: 'Relation is updated.' })
                        }
                    } else if (relation_type == 2 || relation_type == 1) {
                        // accepting the friend req and making friend and inserting the new entry for friend vice versa
                        // check is user blocked ?
                        var sql_check_block = `SELECT COUNT(*) as count, id, relation_type FROM user_business_relation WHERE source_id = '${target_id}' AND target_id = '${source_id}' AND relation_type = 5`
                        sql_check_block_result = await exports.run_query(sql_check_block)
                        if (sql_check_block_result[0].count > 0) {
                            return res.status(200).send({ status: 'success', message: 'Target is blocked' })
                        }
                        var sql_count_check_relation = `SELECT COUNT(*) as count, id, relation_type FROM user_business_relation WHERE source_id = '${source_id}' AND target_id = '${target_id}' AND (relation_type = 1 OR relation_type = 2 OR relation_type = 5)`
                        result_count_check_relation = await exports.run_query(sql_count_check_relation)
                        if (result_count_check_relation[0].count == 0) {
                            var sql_insert_relation = `INSERT INTO user_business_relation SET ? `
                            sql_insert_relation_result = await exports.run_query(sql_insert_relation, data_to_insert)
                            if (sql_insert_relation_result.affectedRows > 0) {
                                return res.status(200).send({ status: 'success', message: 'Relation is inserted' })
                            }
                        } else {
                            var sql_insert = `UPDATE user_business_relation SET ? WHERE id='${result_count_check_relation[0].id}'`
                            var data_to_insert = { relation_type }
                            result_insert = await exports.run_query(sql_insert, data_to_insert)
                            return res.status(200).send({ status: 'success', message: 'Relation is updated.' })
                        }
                    } else if ((result_count[0].relation_type == 5) && (relation_type == 1 || relation_type == 2)) {
                        var sql_check_block = `SELECT COUNT(*) as count, id, relation_type FROM user_business_relation WHERE source_id = '${target_id}' AND target_id = '${source_id}' AND relation_type = 5`
                        sql_check_block_result = await exports.run_query(sql_check_block)
                        if (sql_check_block_result[0].count > 0) {
                            return res.status(200).send({ status: 'success', message: 'Target is blocked' })
                        }
                        data_to_insert_temp_accept = { relation_type }
                        data_to_insert_temp_friend = { target_id: source_id, source_id: target_id, relation_type }
                        var sql_insert = `UPDATE user_business_relation SET ? WHERE id='${result_count[0].id}'`
                        result_insert1 = await exports.run_query(sql_insert, data_to_insert_temp_accept)
                        result_insert2 = await exports.run_query(sql_insert, data_to_insert_temp_friend)
                        return res.status(200).send({ status: 'success', message: 'Successfull' })
                    } else if (result_count[0].count == 0) {
                        let data_to_insert = { source_id, target_id, relation_type }
                        let sql_insert = `INSERT INTO user_business_relation SET ? `
                        result_insert = await exports.run_query(sql_insert, data_to_insert)
                        return res.status(200).send({ status: 'success', message: 'Data inserted' })
                    } else {
                        return res.status(200).send({ status: 'success', message: 'Successfull' })
                    }
                }
            } catch (error) {
                return res.status(500).send({ status: 'failed', message: 'Could not insert data', error })
            }
            break;
        case 'get':
            if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
                var business_id = req.userdata.business_id;
                source_id = business_id;
                if (req.body.target_id != null && req.body.target_id != undefined && req.body.target_id != '') {
                    var target_id = req.body.target_id;
                } else {
                    return res.status(500).json({ status: 'error', message: 'user_id is missing' });
                }
            } else if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
                var target_id = req.body.business_id;
                if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
                    var source_id = req.userdata.id;
                } else {
                    return res.status(500).json({ status: 'error', message: 'user_id is missing' });
                }
            } else {
                return res.status(500).json({ status: 'error', message: 'business_id is missing' });
            }

            if (req.body.relation_type != null && req.body.relation_type != undefined && req.body.relation_type != '') {
                relation_type = req.body.relation_type
            } else {
                return res.status(500).json({ status: 'error', message: 'relation_type is missing' });
            }

            sql_get_relation = `SELECT * FROM user_business_relation WHERE source_id ='${source_id}' AND target_id = '${target_id}' AND relation_type = '${relation_type}'`
            try {
                result_get_relation = await exports.run_query(sql_get_relation)
                data = []
                    // return res.send(result_get_relation)

                final_data = {}
                if (result_get_relation != '') {
                    final_data.is_relation = 1
                    final_data.relation_id = result_get_relation[0].id
                } else {
                    final_data.is_relation = 0
                }
                data.push(final_data)
                return res.status(200).send({ status: 'success', message: 'success', data: data })
            } catch (error) {
                return res.status(400).send({ status: 'failed', message: 'error', error })
            }
            break;
        case 'end':
            // ending the relation like unblock , unfriend, unfollow, unfavorite
            if (req.body.relation_id != null || req.body.relation_id != undefined || req.body.relation_id != '') {
                try {
                    var sql_delete = `DELETE FROM user_business_relation WHERE id = '${req.body.relation_id}'`
                    result_insert = await exports.run_query(sql_delete)
                    if (result_insert.affectedRows > 0) {
                        return res.status(200).send({ status: 'success', message: 'relation is updated' })
                    } else {
                        return res.status(200).send({ status: 'success', message: 'relation is updated' })
                    }
                } catch (error) {
                    return res.status(400).send({ status: 'failed', message: 'Something went wrong' })
                }
            } else {
                return res.status(400).send({ status: 'failed', message: 'relation_type is missing' })
            }

            break
        default:
            return res.status(500).send({ status: 'failed', message: 'api_type is missing it should be either get or set' })
            break;
    }
}

exports.endRelation = async(req, res, next) => {
    if (req.body.relation_id != null || req.body.relation_id != undefined || req.body.relation_id != '') {
        try {
            var sql_delete = `DELETE FROM user_business_relation WHERE id = ${req.body.relation_id}`
            result_insert = await exports.run_query(sql_delete)
            if (result_insert.affectedRows > 0) {
                return res.status(200).send({ status: 'success', message: 'relation is updated' })
            } else {
                return res.status(200).send({ status: 'success', message: 'relation is updated' })
            }
        } catch (error) {
            return res.status(400).send({ status: 'failed', message: 'Something went wrong' })
        }
    } else {
        return res.status(400).send({ status: 'failed', message: 'relation_type is missing' })
    }
}

exports.getAllRelation = async(req, res, next) => {
    if (req.body.relation_type == null || req.body.relation_type == undefined || req.body.relation_type == '') {
        return res.status(400).send({ status: 'failed', message: 'relation_type is missing' })
    } else if (req.userdata.business_id == null && req.userdata.business_id == undefined && req.userdata.business_id == '') {
        user_id = req.userdata.id
    }
    try {
        sql_get_all_business_relation = `SELECT u_b_r.id as relation_id, u_b_r.source_id as source_id, u_b_r.target_id as target_id ,b_m.business_name as business_name, b_m.website as websites, b_m.short_description as short_description,b_m.business_status as status, CONCAT('${img_path}' , b_m.photo) as photo FROM user_business_relation AS u_b_r JOIN business_master as b_m WHERE u_b_r.target_id = b_m.business_id AND u_b_r.relation_type = '${req.body.relation_type}'`

        result_get_all_business_relation = await exports.run_query(sql_get_all_business_relation)
        return res.send(result_get_all_business_relation)
    } catch (error) {
        return res.status(500).send({ status: 'failed', message: 'Something went wrong', error })
    }
}

// Set or get the user detail
exports.userDetail = async(req, res, next) => {
    if (req.body.api_type) {
        if (req.userdata.id) {
            user_id = req.userdata.id
        } else if (req.body.user_id) {
            user_id = req.body.id
        } else {
            return res.status(400).send({ status: 'failed', message: 'api_type is missing' })
        }
        switch (req.body.api_type) {
            case 'get':
                // get address
                sql_get_detail = `SELECT full_name, email,phone, postal, profile_id, reach_whatsapp, short_description FROM users WHERE id = '${user_id}'`
                result_sql_get_detail = await exports.run_query(sql_get_detail)
                sql_get_address = `SELECT id as address_id,city,state,pincode,country,landmark,address,default_address FROM user_address WHERE user_id = '${user_id}'`
                result_sql_get_address = await exports.run_query(sql_get_address)
                final_data = { detail: result_sql_get_detail[0], address: result_sql_get_address }
                return res.status(200).send({ status: 'success', message: 'success', data: final_data })
                break;
            case 'set':
                data_to_insert = {}
                if (req.body.full_name != '' || req.body.full_name != 'undefined' || req.body.full_name != null) {
                    data_to_insert.full_name = req.body.full_name
                }
                if (req.body.postal_code != '' || req.body.postal_code != 'undefined' || req.body.postal_code != null) {
                    data_to_insert.postal = req.body.postal_code
                }
                if (req.body.short_description != '' && req.body.short_description != null) {
                    data_to_insert.short_description = req.body.short_description
                }
                if (req.body.reach_whatsapp != '' && req.body.reach_whatsapp != null) {
                    data_to_insert.reach_whatsapp = req.body.reach_whatsapp
                }
                try {
                    sql_update = `UPDATE users SET updated_at = NOW(), ? WHERE id = '${user_id}'`
                    result_update = await exports.run_query(sql_update, data_to_insert)
                    if (result_update.affectedRows) {
                        return res.status(200).send({ status: 'success', message: 'Profile is upated' })
                    }
                } catch (error) {
                    return res.status(400).send({ status: 'failed', message: 'Something went wrong', error })
                }
                break;

            default:
                return res.status(400).send({ status: 'failed', message: 'Something went wrong' })
                break;
        }
    } else {
        return res.status(400).send({ status: 'failed', message: 'api_type is missing' })
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
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    }
}