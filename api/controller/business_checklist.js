var db = require('../config/db');
var dateArr=['2020-11-04','2020-11-03'];

/**
 * FETCH ALL REVIEWS
*/
exports.all_business_reviewlist = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%Y-%m-%d') as review_date, \n\
        DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY id DESC";
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
 * FETCH CHECK IN LIST
 * type->0 means all, type->1 means pending reviews
*/
exports.business_check_in_list = async function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.type == '' || req.body.type == 'undefined' || req.body.type == null) {
            return res.status(403).json({ status: 'error', message: 'Type not found.' });
        }else{
            var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%Y-%m-%d') as review_date, \n\
            DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY id DESC";
            db.query(sql,async function (err, result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                }
                if(result.length>0){
                    if(req.body.type==0){
                        return res.status(200).json({ status: 'success', message: 'success', data: result });
                    }else if(req.body.type==1){
                        var newReview=[];
                        var allReview=[];
                        for (var i = 0; i < result.length; i++) {
                            var reviewdate=result[i].review_date;
                            if(dateArr.indexOf(reviewdate) !== -1){
                                newReview.push(result[i]);
                            } else{
                                allReview.push(result[i]);
                            }
                        }
                        var DataArr={
                            "newReview":newReview,
                            "allReview":allReview
                        };
                        return res.status(200).json({ status: 'success', message: 'success',data:DataArr});
                    }
                }else{
                    return res.status(200).json({ status: 'success', message: 'NO Data Found', data:[] });
                }
                
            });
        }
       
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

async function checklistdata(business_id){
    return new Promise(function(resolve, reject){
        var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%d %b') as review_date, \n\
        DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY id DESC";				
        db.query(sql, function(err, result) {	
            resolve(result);
        });
    }); 
}