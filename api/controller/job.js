var db = require('../config/db');
var contact_via = ['Phone', 'Email'];

/**
 * FETCH ALL JOB
 */
exports.all_jobs = function (req, res, next) {
    var business_id = req.userdata.business_id;
    var where_condition = " WHERE business_id='" + business_id + "' AND deleted_at IS NULL ";

    if (req.body.job_id != '' && req.body.job_id != 'undefined' && req.body.job_id != null) {
        where_condition += " AND id='" + req.body.job_id + "' ";
    }

    var sql = "SELECT id,title,description FROM jobs " + where_condition;
    db.query(sql, function (err, result) {
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
};

/**
 * STATIC DROP DONW DETAI TO CREATE THE JOB
 */
exports.dd_verbose = function (req, res, next) {
    var verbose = {};
    verbose.contact_via = contact_via;
    var sql = "SELECT id,skill FROM skills";
    db.query(sql, function (err, skill_list) {
        verbose.skill_list = skill_list;
        var sql = "SELECT id,city FROM cities";
        db.query(sql, function (err, city_list) {
            verbose.city_list = city_list;
            return res.status(200).json({ status: 'success', message: 'success', data: verbose });
        });
    });
};


/**
 * STATIC DROP DONW AND JOB DETAI TO EDIT THE JOB
 */
exports.detail_job = function (req, res, next) {
    if (req.body.job_id == '' || req.body.job_id == 'undefined' || req.body.job_id == null) {
        return res.status(404).json({ status: 'error', message: 'Job id not found.' });
    }

    var verbose = {};
    verbose.contact_via = contact_via;
    var sql = "SELECT id,skill FROM skills";
    db.query(sql, function (err, skill_list) {
        verbose.skill_list = skill_list;
        var sql = "SELECT id,city FROM cities";
        db.query(sql, function (err, city_list) {
            verbose.city_list = city_list;
        
            var sql = "SELECT id,title,description,skills,contact_via,city,pincode FROM jobs WHERE id='" + req.body.job_id + "'";
            db.query(sql, function (err, result) {
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
};


/**
 * CREATE NEW JOB
 */
exports.add_job = function (req, res, next) {
    if (req.body.title == '' || req.body.title == 'undefined' || req.body.title == null) {
        return res.status(404).json({ status: 'error', message: 'Job title not found.' });
    } else if (req.body.description == '' || req.body.description == 'undefined' || req.body.description == null) {
        return res.status(404).json({ status: 'error', message: 'Job description not found.' });
    } else if (req.body.skills == '' || req.body.skills == 'undefined' || req.body.skills == null) {
        return res.status(404).json({ status: 'error', message: 'Job skills not found.' });
    } else if (req.body.contact_via == '' || req.body.contact_via == 'undefined' || req.body.contact_via == null) {
        return res.status(404).json({ status: 'error', message: 'Contact via not found.' });
    } else if (req.body.contact_value == '' || req.body.contact_value == 'undefined' || req.body.contact_value == null) {
        return res.status(404).json({ status: 'error', message: 'Contact value not found.' });
    } else if (req.body.city == '' || req.body.city == 'undefined' || req.body.city == null) {
        return res.status(404).json({ status: 'error', message: 'City not found.' });
    } else if (req.body.pincode == '' || req.body.pincode == 'undefined' || req.body.pincode == null) {
        return res.status(404).json({ status: 'error', message: 'Pincode not found.' });
    }

    var business_id = req.userdata.business_id;
    var title = req.body.title;
    var description = req.body.description;
    var skills = req.body.skills;
    var contact_via = req.body.contact_via;
    var contact_value = req.body.contact_value;
    var city = req.body.city;
    var pincode = req.body.pincode;

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
    db.query(sql, postval, function (err, result) {
        if (err) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
        }
        return res.status(200).json({ status: 'success', message: 'Job created successfully.' });
    });
};


/**
 * EDIT JOB
 */
exports.edit_job = function (req, res, next) {
    if (req.body.job_id == '' || req.body.job_id == 'undefined' || req.body.job_id == null) {
        return res.status(404).json({ status: 'error', message: 'Job id not found.' });
    }

    var business_id = req.userdata.business_id;
    var job_id = req.body.job_id;

    var postval = {};

    if (req.body.title != '' && req.body.title != 'undefined' && req.body.title != null) {
        postval.title = req.body.title;
    }
    if (req.body.description != '' && req.body.description != 'undefined' && req.body.description != null) {
        postval.description = req.body.description;
    }
    if (req.body.skills != '' && req.body.skills == 'undefined' && req.body.skills != null) {
        postval.skills = req.body.skills;
    }
    if (req.body.contact_via != '' && req.body.contact_via != 'undefined' && req.body.contact_via != null) {
        postval.contact_via = req.body.contact_via;
    }
    if (req.body.contact_value != '' && req.body.contact_value != 'undefined' && req.body.contact_value != null) {
        postval.contact_value = req.body.contact_value;
    }
    if (req.body.city != '' && req.body.city != 'undefined' && req.body.city != null) {
        postval.city = req.body.city;
    }
    if (req.body.pincode != '' && req.body.pincode != 'undefined' && req.body.pincode != null) {
        postval.pincode = req.body.pincode;
    }

    var sql = "UPDATE jobs SET ?, updated_at=now() WHERE id='" + job_id + "' AND business_id='" + business_id + "'";
    db.query(sql, postval, function (err, result) {
        if (err) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
        }
        return res.status(200).json({
            status: 'success',
            message: 'Job updated successfully.',
        });
    });
};