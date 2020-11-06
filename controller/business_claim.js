var db = require('../config/db');

var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

/*CREATE BUSINESS CATEGORY*/
exports.addClaim = async function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        var claim_count = await checkClaimCount(business_id);

        if (claim_count >= 3) {
            return res.status(403).json({ status: 'error', message: 'You can not claim to this business as you have already claimed ' + claim_count + ' times.' });
        }

        var postval = { business_id: business_id };

        if (req.body.phone != '' && req.body.phone != 'undefined' && req.body.phone != null) {
            postval.phone = req.body.phone;
        }
        if (req.body.email != '' && req.body.email != 'undefined' && req.body.email != null) {
            postval.email = req.body.email;
        }

        var sql = "INSERT INTO business_claim SET ?";
        db.query(sql, postval, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            if (req.files && req.files.length) {
                var file_count = req.files.length;
                for (var i = 0; i < file_count; i++) {
                    var filename = req.files[i].filename;
                    var sql = "INSERT INTO `business_claim_upload`(business_id, document) VALUES ('" + business_id + "','" + filename + "')";
                    db.query(sql);
                }
            }
            return res.status(200).json({ status: 'success', message: 'Claimed successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' + e });
    }
};

/**
 * BUSINESS CATALOG ADD PHOTO
 */
exports.addClaimPhotos = async function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        var claim_count = await checkClaimCount(business_id);

        if (claim_count >= 3) {
            return res.status(403).json({ status: 'error', message: 'You can not claim to this business as you have already claimed ' + claim_count + ' times.' });
        }

        if (req.files && req.files.length) {
            var file_count = req.files.length;
            for (var i = 0; i < file_count; i++) {
                var filename = req.files[i].filename;
                var sql = "INSERT INTO `business_claim_upload`(business_id, document) VALUES ('" + business_id + "','" + filename + "')";
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

exports.getClaim = async function(req, res, next) {
    business_id = await req.userdata.business_id;
    try {
        var sql = 'SELECT business_phone, business_email, is_phone_verified,is_email_verified FROM business_master WHERE business_id="' + business_id + '"'
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            if (result.is_phone_verified == null || result.is_email_verified == null) {
                return res.status(500).json({ status: 'error', message: 'Either email or phone is not found' });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result[0] })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

/**
 * CHECK TOTAL CLAIM COUNT
 */
function checkClaimCount(business_id) {
    return new Promise(function(resolve, reject) {
        var sql = "select count(*) as c from business_claim where business_id='" + business_id + "'";
        db.query(sql, function(err, result) {
            resolve(result[0].c);
        });
    });
}