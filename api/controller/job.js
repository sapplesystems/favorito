var db = require('../config/db');
var contact_via = ['Phone', 'Email'];

/**
 * FETCH ALL JOB
 */
exports.all_jobs = function(req, res, next) {
    try {
        if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
            business_id = req.body.business_id
        } else {
            var business_id = req.userdata.business_id;
        }
        var where_condition = " WHERE business_id='" + business_id + "' AND deleted_at IS NULL ";

        if (req.body.job_id != '' && req.body.job_id != 'undefined' && req.body.job_id != null) {
            where_condition += " AND id='" + req.body.job_id + "' ";
        }

        var sql = "SELECT id,title,description,no_of_position FROM jobs " + where_condition;
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({
                status: 'success',
                message: 'success',
                contact_via: contact_via,
                data: result
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * STATIC DROP DONW DETAI TO CREATE THE JOB
 */
exports.dd_verbose = async function(req, res, next) {
    try {
        var verbose = {};
        verbose.contact_via = contact_via;
        verbose.skill_list = await exports.getSkillList();
        verbose.city_list = await exports.getCityList();
        return res.status(200).json({ status: 'success', message: 'success', data: verbose });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET SKILL LIST
 */
exports.getSkillList = function() {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT id,skill FROM skills";
        db.query(sql, function(err, skill_list) {
            resolve(skill_list);
        });
    });
}


/**
 * GET CITY LIST
 */
exports.getCityList = function() {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT id,city FROM cities";
        db.query(sql, function(err, city_list) {
            resolve(city_list);
        });
    });
}


/**
 * GET PINCODE LIST OF THE CITY
 */
// exports.city_pincode = function(req, res, next) {
//     try {
//         if (req.body.city_id == '' || req.body.city_id == 'undefined' || req.body.city_id == null) {
//             return res.status(403).json({ status: 'error', message: 'City id not found.' });
//         }
//         var city_id = req.body.city_id;
//         var sql = "SELECT id,pincode FROM pincodes where city_id='" + city_id + "'";
//         db.query(sql, function(err, pincode) {
//             return res.status(200).json({ status: 'success', message: 'success', data: pincode });
//         });
//     } catch (e) {
//         return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
//     }
// }


/**
 * GET CITY NAME FROM PINCODE
 */
exports.city_from_pincode = function(req, res, next) {
    try {
        if (req.body.pincode == '' || req.body.pincode == 'undefined' || req.body.pincode == null) {
            return res.status(403).json({ status: 'error', message: 'Pincode not found.' });
        }
        var pincode = req.body.pincode;
        var sql = "SELECT id,city,state_id,(SELECT state FROM states WHERE id=cities.state_id) AS state_name \n\
        FROM cities WHERE id IN(SELECT city_id FROM pincodes WHERE pincode='" + pincode + "' GROUP BY city_id)";
        db.query(sql, function(err, result) {
            var data = {};
            var message = 'Pincode not found';
            if (result.length > 0) {
                message = 'success';
                data = result[0];
            }
            return res.status(200).json({ status: 'success', message: message, data: data });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}


/**
 * STATIC DROP DONW AND JOB DETAI TO EDIT THE JOB
 */
exports.detail_job = function(req, res, next) {
    try {
        if (req.body.job_id == '' || req.body.job_id == 'undefined' || req.body.job_id == null) {
            return res.status(403).json({ status: 'error', message: 'Job id not found.' });
        }

        var verbose = {};
        verbose.contact_via = contact_via;
        var sql = "SELECT id,skill FROM skills";
        db.query(sql, function(err, skill_list) {
            verbose.skill_list = skill_list;
            var sql = "SELECT id,city FROM cities";
            db.query(sql, function(err, city_list) {
                verbose.city_list = city_list;

                var sql = "SELECT id,title,description,skills,contact_via,contact_value,city,pincode FROM jobs WHERE id='" + req.body.job_id + "'";
                db.query(sql, function(err, result) {
                    if (err) {
                        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                    }
                    return res.status(200).json({
                        status: 'success',
                        message: 'success',
                        verbose: verbose,
                        data: result
                    });
                });
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * CREATE NEW JOB
 */
exports.add_job =async  function(req, res, next) {
    try {
        if (req.body.title == '' || req.body.title == 'undefined' || req.body.title == null) {
            return res.status(403).json({ status: 'error', message: 'Job title not found.' });
        } else if (req.body.description == '' || req.body.description == 'undefined' || req.body.description == null) {
            return res.status(403).json({ status: 'error', message: 'Job description not found.' });
        } else if (req.body.skills == '' || req.body.skills == 'undefined' || req.body.skills == null) {
            return res.status(403).json({ status: 'error', message: 'Job skills not found.' });
        } else if (req.body.contact_via == '' || req.body.contact_via == 'undefined' || req.body.contact_via == null) {
            return res.status(403).json({ status: 'error', message: 'Contact via not found.' });
        } else if (req.body.contact_value == '' || req.body.contact_value == 'undefined' || req.body.contact_value == null) {
            return res.status(403).json({ status: 'error', message: 'Contact value not found.' });
        } else if (req.body.postal_code == '' || req.body.postal_code == 'undefined' || req.body.postal_code == null) {
            return res.status(403).json({ status: 'error', message: 'Pincode not found.' });
        }

        var business_id = req.userdata.business_id;
        var title = req.body.title;
        var description = req.body.description;
        var skills = req.body.skills;
        var contact_via = req.body.contact_via;
        var contact_value = req.body.contact_value;
        var pincode = req.body.postal_code;
        let city =await Citycode(pincode);
        if(city!=''){
            var postval = {
                business_id: business_id,
                title: title,
                description: description,
                skills: skills,
                contact_via: contact_via,
                contact_value: contact_value,
                city: city,
                pincode: pincode
            };
    
            var sql = "INSERT INTO jobs set ?";
            db.query(sql, postval, function(err, result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                }
                return res.status(200).json({ status: 'success', message: 'Job created successfully.' });
            });
        }else{
            return res.status(403).json({ status: 'error', message: 'City not found for this pincode' }); 
        }
        
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * EDIT JOB
 */
exports.edit_job =async function(req, res, next) {
    try {
        if (req.body.job_id == '' || req.body.job_id == 'undefined' || req.body.job_id == null) {
            return res.status(403).json({ status: 'error', message: 'Job id not found.' });
        }

        var business_id = req.userdata.business_id;
        var job_id = req.body.job_id;
        var update_columns = " updated_at=now() ";
        if (req.body.title != '' && req.body.title != 'undefined' && req.body.title != null) {
            update_columns += ", title='" + req.body.title + "' ";
        }
        if (req.body.description != '' && req.body.description != 'undefined' && req.body.description != null) {
            update_columns += ", description='" + req.body.description + "' ";
        }
        if (req.body.skills != '' && req.body.skills != 'undefined' && req.body.skills != null) {
            update_columns += ", `skills`='" + req.body.skills + "' ";
        }
        if (req.body.contact_via != '' && req.body.contact_via != 'undefined' && req.body.contact_via != null) {
            update_columns += ", contact_via='" + req.body.contact_via + "' ";
        }
        if (req.body.contact_value != '' && req.body.contact_value != 'undefined' && req.body.contact_value != null) {
            update_columns += ", contact_value='" + req.body.contact_value + "' ";
        }
        if (req.body.postal_code != '' && req.body.postal_code != 'undefined' && req.body.postal_code != null) {
            update_columns += ", pincode='" + req.body.postal_code + "' ";
        }
        let city =await Citycode(req.body.postal_code);
        if(city!=''){
            update_columns += ", city='" + city + "' ";
        }

        var sql = "update jobs set " + update_columns + "  WHERE id='" + job_id + "' AND business_id='" + business_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({
                status: 'success',
                message: 'Job updated successfully.',
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', e });
    }
};

/*
*Get city code from pincode
**/
async function Citycode(pincode) {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT `city_id` FROM `pincodes` WHERE `pincode`='"+pincode+"' LIMIT 1";
        db.query(sql, function(err, result) {
            resolve(result[0].city_id);
        });
    });
}