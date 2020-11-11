var db = require('../../config/db');

exports.businessCarouselList = async function(req, res, next) {
    await exports.getCaruoselData(1, res)
}

exports.getCaruoselData = async function(business_id, res) {
    try {
        var sql = 'SELECT business_phone, business_email, is_phone_verified,is_email_verified FROM business_master WHERE business_id="' + business_id + '"'
        await db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}