var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

exports.getDetailJob = async(req, res) => {
    if (!req.body.job_id) {
        return res.status(400).json({ status: 'failed', message: 'job_id is missing' });
    }

    sqlJobDetail = `select j.id, j.business_id, j.title, j.description, j.no_of_position, j.skills, j.contact_via, j.contact_value, c.city,j.pincode \n\
    from jobs as j\n\
    left join cities as c on c.id = j.city\n\
    where j.id = '${req.body.job_id}'`

    resultJobDetail = await exports.run_query(sqlJobDetail)

    if (resultJobDetail == '') {
        return res.status(200).json({ status: 'success', message: 'No jobs is found with this id', data: [] });
    } else {
        return res.status(200).json({ status: 'success', message: 'success', data: resultJobDetail });
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