const db = require('../../config/db');
var moment = require('moment');
var today = new Date();
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

exports.all_offers = async function (req, res, next) {
    try {
        let created_at=moment(req.userdata.created_at).format('YYYY-MM-DD').split("-");
        let today_at=moment(today).format('YYYY-MM-DD').split("-");
        let date1=moment(created_at);
        let date2=moment(today_at);
        let daysdiff=date2.diff(date1, 'days');
        let offertype=(daysdiff>15)?'Current Offer':'New User Offer';
        let sql="SELECT bo.id,bo.`offer_title`,bo.`offer_description`,bm.`business_name`,uo.`offer_status`,CONCAT('" + img_path + "',bm.photo) AS photo FROM `business_offers` AS bo JOIN `business_master` AS bm ON bm.`business_id`=bo.`business_id` LEFT JOIN `user_offer` AS uo ON uo.`offer_id`=bo.`id` AND uo.`user_id`='"+req.userdata.id+"' WHERE bo.`offer_type`='"+offertype+"' AND bo.`offer_status`='Activated'";

        result_offer = await exports.run_query(sql);
        if(result_offer!=""){
            return res.status(200).send({ status: 'success', message: 'Successfull', data: result_offer });
        }else{
            return res.status(200).send({ status: 'error', message: 'No data Found', data:[] });
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


exports.offer_status = async function (req, res, next) {
    try {
        if (req.body.offerid=='' || req.body.offerid==null || req.body.offerid==undefined) {
            return res.status(403).json({ status: 'error', message: 'Offer id is missing' });
        }else if (req.body.offer_Status=='' || req.body.offer_Status==null || req.body.offer_Status==undefined) {
            return res.status(403).json({ status: 'error', message: 'Offer status is missing' });
        }
        var offer ={
            user_id:req.userdata.id,
            offer_id:req.body.offerid,
            offer_status:req.body.offer_Status
        }
        let mssg=(req.body.offer_Status==2)?'Your offer redeemed':'Your offer activated';
        let business_status=(req.body.offer_Status==2)?'total_redeemed=total_redeemed+1':'total_activated=total_activated+1';
        let sql=(req.body.offer_Status==2)?`UPDATE user_offer SET offer_status ='${req.body.offer_Status}' ,updated_at =NOW() WHERE user_id ='${req.userdata.id}' AND offer_id='${req.body.offerid}'`:`INSERT INTO user_offer SET ?`;
        let result_sql = await exports.run_query(sql,offer);
        if(result_sql.affectedRows>0){
            let sql1="UPDATE business_offers SET "+business_status+" ,updated_at=NOW() WHERE id='"+req.body.offerid+"'";
            result_sql1 = await exports.run_query(sql1);
            if(result_sql1.affectedRows>0){
                return res.status(200).send({ status: 'success', message: mssg});
            }
        }else{
            return res.status(200).send({ status: 'error', message: 'No data ', });
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.'+e });
    }
};

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