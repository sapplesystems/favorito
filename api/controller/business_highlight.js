var db = require('../config/db');

/**
 * FETCH DETAIL OF BUSINESS HIGHLIGHT
 */
exports.getHighlight = async function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;
        var photos = await fetchBusinessHighlightPhoto(business_id);

        var sql = "SELECT highlight_title,highlight_desc FROM business_highlights WHERE business_id='" + business_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.1111111' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: result, photos: photos });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.2222222222' });
    }
};


/**
 * BUSINESS HIGHLIGHT ADD
 */
exports.addHighlight = async function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        if (req.body.highlight_title == '' || req.body.highlight_title == 'undefined' || req.body.highlight_title == null) {
            return res.status(404).json({ status: 'error', message: 'Highlight title not found.' });
        } else if (req.body.highlight_desc == '' || req.body.highlight_desc == 'undefined' || req.body.highlight_desc == null) {
            return res.status(404).json({ status: 'error', message: 'Highlight description not found.' });
        }

        var highlight_count = await checkHightlightCount(business_id);

        var title = req.body.highlight_title;
        var desc = req.body.highlight_desc;

        if (highlight_count > 0) {
            var sql = "UPDATE business_highlights SET highlight_title='" + title + "', highlight_desc='" + desc + "' WHERE business_id='" + business_id + "'";
        } else {
            var sql = "INSERT INTO business_highlights (business_id, highlight_title, highlight_desc) VALUES('" + business_id + "','" + title + "','" + desc + "');";
        }

        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Highlight saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * BUSINESS HIGHLIGHT ADD PHOTO
 */
exports.addPhotos = function (req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        if (req.files && req.files.length) {
            var file_count = req.files.length;
            for (var i = 0; i < file_count; i++) {
                var filename = req.files[i].filename;
                var sql = "INSERT INTO `business_highlight_photos`(business_id, photo) \n\
                        VALUES ('"+ business_id + "','" + filename + "')";
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



/**
 * CHECK BUSINESS HIGHLIGHT COUNT
 */
function checkHightlightCount(business_id) {
    return new Promise(function (resolve, reject) {
        var sql = "select count(*) as c from business_highlights where business_id='" + business_id + "'";
        db.query(sql, function (err, result) {
            resolve(result[0].c);
        });
    });
}


/**
 * FETCH ALL PHOTOS OF BUSINESS HIGHLIGHT
 */
function fetchBusinessHighlightPhoto(business_id) {
    return new Promise(function (resolve, reject) {
        var sql = "select id,photo from business_highlight_photos where business_id='" + business_id + "'";
        db.query(sql, function (err, result) {
            resolve(result);
        });
    });
}