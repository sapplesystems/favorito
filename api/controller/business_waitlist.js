var db = require('../config/db');

/**
 * FETCH ALL BUSINESS WAITLIST
 */
exports.all_business_waitlist = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id,`name`,contact,no_of_person,special_notes,waitlist_status, DATE_FORMAT(created_at, '%d %b') as waitlist_date, \n\
        DATE_FORMAT(created_at, '%H:%i') AS walkin_at FROM business_waitlist WHERE business_id='" + business_id + "' AND deleted_at IS NULL";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
			if(result.length>0){
				return res.status(200).json({ status: 'success', message: 'success', data: result });
			}else{
				return res.status(200).json({ status: 'success', message: 'NO Data Found', data:[] });
			}
            
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * CREATE A NEW MANUAL WAITLIST
 */
exports.create_manual_waitlist = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.name == '' || req.body.name == 'undefined' || req.body.name == null) {
            return res.status(403).json({ status: 'error', message: 'Name not found.' });
        } else if (req.body.contact == '' || req.body.contact == 'undefined' || req.body.contact == null) {
            return res.status(403).json({ status: 'error', message: 'Contact not found.' });
        } else if (req.body.no_of_person == '' || req.body.no_of_person == 'undefined' || req.body.no_of_person == null) {
            return res.status(403).json({ status: 'error', message: 'Number of person not found.' });
        } else if (req.body.special_notes == '' || req.body.special_notes == 'undefined' || req.body.special_notes == null) {
            return res.status(403).json({ status: 'error', message: 'Special notes not found.' });
        }

        var name = req.body.name;
        var contact = req.body.contact;
        var no_of_person = req.body.no_of_person;
        var special_notes = req.body.special_notes;

        var sql = "INSERT INTO business_waitlist (business_id,`name`,contact,no_of_person,special_notes) VALUES('" + business_id + "','" + name + "','" + contact + "','" + no_of_person + "','" + special_notes + "')";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Manual waitlist created successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * DELETE MANUAL WAITLIST
 */
exports.delete_manual_waitlist = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.waitlist_id == '' || req.body.waitlist_id == 'undefined' || req.body.waitlist_id == null) {
            return res.status(403).json({ status: 'error', message: 'Waitlist id not found.' });
        }

        var waitlist_id = req.body.waitlist_id;

        var sql = "UPDATE business_waitlist SET deleted_at = NOW() WHERE id='" + waitlist_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Manual waitlist deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * SAVE MANUAL WAITLIST SETTING
 */
exports.save_setting = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var update_column = " updated_at=NOW() ";

        if (req.body.start_time != '' && req.body.start_time != 'undefined' && req.body.start_time != null) {
            update_column += ",start_time='" + req.body.start_time + "'";
        }
        if (req.body.end_time != '' && req.body.end_time != 'undefined' && req.body.end_time != null) {
            update_column += ",end_time='" + req.body.end_time + "'";
        }
        if (req.body.available_resource != '' && req.body.available_resource != 'undefined' && req.body.available_resource != null) {
            update_column += ",available_resource='" + req.body.available_resource + "'";
        }
        if (req.body.minium_wait_time != '' && req.body.minium_wait_time != 'undefined' && req.body.minium_wait_time != null) {
            update_column += ",minium_wait_time='" + req.body.minium_wait_time + "'";
        }
        if (req.body.slot_length != '' && req.body.slot_length != 'undefined' && req.body.slot_length != null) {
            update_column += ",slot_length='" + req.body.slot_length + "'";
        }
        if (req.body.booking_per_slot != '' && req.body.booking_per_slot != 'undefined' && req.body.booking_per_slot != null) {
            update_column += ",booking_per_slot='" + req.body.booking_per_slot + "'";
        }
        if (req.body.booking_per_day != '' && req.body.booking_per_day != 'undefined' && req.body.booking_per_day != null) {
            update_column += ",booking_per_day='" + req.body.booking_per_day + "'";
        }
        if (req.body.waitlist_manager_name != '' && req.body.waitlist_manager_name != 'undefined' && req.body.waitlist_manager_name != null) {
            update_column += ",waitlist_manager_name='" + req.body.waitlist_manager_name + "'";
        }
        if (req.body.announcement != '' && req.body.announcement != 'undefined' && req.body.announcement != null) {
            update_column += ",announcement='" + req.body.announcement + "'";
        }
        if (req.body.except_days != '' && req.body.except_days != 'undefined' && req.body.except_days != null) {
            update_column += ",except_days='" + req.body.except_days + "'";
        }

        var sql = "UPDATE business_waitlist_setting SET " + update_column + " WHERE business_id='" + business_id + "'";

        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Manual waitlist setting saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET MANUAL WAITLIST SETTING
 */
exports.get_setting = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT start_time,end_time,available_resource,minium_wait_time,slot_length,booking_per_slot,\n\
                    booking_per_day,waitlist_manager_name,announcement,except_days \n\
                    FROM business_waitlist_setting WHERE business_id='"+ business_id + "'";
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
 * UPDATE WAITLIST STATUS 
 **/
exports.updateWaitlistStatus = function (req, res, next) {
    try{
        var business_id = req.userdata.business_id;
        if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
            return res.status(403).json({ status: 'error', message: 'Waitlist Id Not Found.' });
        }else if (req.body.status == '' || req.body.status == 'undefined' || req.body.status == null) {
            return res.status(403).json({ status: 'error', message: 'Waitlist Status Not Found' });
        }
        var waitlist_id = req.body.id;

        var update_columns = " updated_at=now() ";

        if (req.body.status != '' && req.body.status != 'undefined' && req.body.status != null ) {
            if(req.body.status == 'accepted' || req.body.status == 'rejected' || req.body.status=='pending'){
                update_columns += ", waitlist_status='" + req.body.status + "' ";
                var sql = "UPDATE business_waitlist SET " + update_columns + " WHERE id='" + waitlist_id + "' AND business_id='" + business_id + "'";
                    db.query(sql, function (err, result) {
                        if (err) {
                        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                        }
                        return res.status(200).json({status: 'success',message: 'Waitlist updated successfully.'});
                    });
            }else{
                return res.status(200).json({status: 'error',message: 'Please Send Correct Status' });
            }
           
        }else{
            return res.status(200).json({status: 'error', message: 'Please Dont send null status' });  
        }
        
    }catch(e){
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });  
    }
};