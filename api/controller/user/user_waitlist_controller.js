var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

// get all waitlist by business_id

exports.business_waitlist = function(req, res, next) {
    try {
        var business_id = req.body.business_id;
        var sql = "SELECT id,`name`,contact,no_of_person,special_notes,waitlist_status, DATE_FORMAT(created_at, '%d %b') as waitlist_date, \n\
        DATE_FORMAT(created_at, '%H:%i') AS walkin_at FROM business_waitlist WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY created_at desc";
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

exports.set_waitlist = async function(req, res, next) {
    data_to_insert = {}
    if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
        var business_id = req.userdata.business_id;
        if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
            var user_id = req.body.user_id;
        } else {
            return res.status(500).json({ status: 'error', message: 'user_id is missing' });
        }
    } else if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
        var business_id = req.body.business_id;
        if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
            var user_id = req.userdata.id;
        } else {
            return res.status(500).json({ status: 'error', message: 'user_id is missing' });
        }
    } else {
        return res.status(500).json({ status: 'error', message: 'business_id is missing' });
    }

    data_to_insert.business_id = business_id
    data_to_insert.user_id = user_id
    if (req.body.no_of_person == '' || req.body.no_of_person == null || req.body.no_of_person == undefined) {
        return res.status(403).json({ status: 'error', message: 'Number of person is required.' });
    } else {
        data_to_insert.no_of_person = req.body.no_of_person
    }

    if (req.body.special_notes != '' && req.body.special_notes != null && req.body.special_notes != undefined) {
        data_to_insert.special_notes = req.body.special_notes
    }

    if (req.body.contact != '' && req.body.contact != null && req.body.contact != undefined) {
        data_to_insert.contact = req.body.contact
    }

    if (req.body.name != '' && req.body.name != null && req.body.name != undefined) {
        data_to_insert.name = req.body.name
    } else {
        data_to_insert.name = ''
    }

    if (req.body.waitlist_id != '' && req.body.waitlist_id != null && req.body.waitlist_id != undefined) {
        var sql = `UPDATE business_waitlist SET updated_at = NOW(), ? WHERE id = ${req.body.waitlist_id}`;
    } else {
        var sql = "INSERT INTO business_waitlist SET ?";
    }
    try {
        result = await exports.run_query(sql, data_to_insert)
        if (result.affectedRows > 0) {
            return res.status(200).json({ status: 'success', message: 'Data is Updated' });
        } else {
            return res.status(400).json({ status: 'failed', message: 'Something went wrong' });
        }
    } catch (error) {
        return res.status(400).json({ status: 'failed', message: 'Something went wrong', error });
    }
}

exports.cancel_waitlist = async function(req, res, next) {
    if (req.body.waitlist_id == null || req.body.waitlist_id == undefined || req.body.waitlist_id == '') {
        return res.status(500).json({ status: 'error', message: 'waitlist_id is missing' });
    } else {
        try {
            sql = `UPDATE business_waitlist SET deleted_at = NOW() WHERE id = ${req.body.waitlist_id}`
            result = exports.run_query(sql)
            if (result.affectedRows > 0) {
                return res.status(200).json({ status: 'success', message: 'Waitlist is deleted.', result });
            }
            return res.status(200).json({ status: 'success', message: 'Waitlist is deleted' });
        } catch (error) {
            return res.status(400).json({ status: 'error', message: 'Something went wrong', error });
        }
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