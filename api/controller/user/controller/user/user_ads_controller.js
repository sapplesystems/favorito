var db = require('../../config/db');

exports.clickOnAd = async(req, res) => {
    if (!req.body.campaign_id) {
        return res.status(400).send({ status: 'failed', message: 'campaign_id is not found' })
    }

    sql_click_on_add = `UPDATE business_ad_spent_campaign set \n\
    clicks = clicks + 1, \n\
    total_spent = total_spent + cpc \n\
    where id = '${req.body.campaign_id}'`

    sql_get_cpc = `select cpc, business_id from business_ad_spent_campaign where id = '${req.body.campaign_id}'`
    try {
        result_sql_get_cpc_business_id = await exports.run_query(sql_get_cpc)
        if (result_sql_get_cpc_business_id && result_sql_get_cpc_business_id[0] && result_sql_get_cpc_business_id[0].business_id) {
            business_id = result_sql_get_cpc_business_id[0].business_id
        } else {
            business_id = null
        }
        sql_get_free_paid_credits = `select free_credits,paid_credits from business_ad_credits where business_id = '${business_id}'`

        result_get_free_paid_credits = await exports.run_query(sql_get_free_paid_credits)

        if (result_get_free_paid_credits && result_get_free_paid_credits[0]) {
            if (result_get_free_paid_credits[0].free_credits > 0 && result_get_free_paid_credits[0].free_credits >= result_sql_get_cpc_business_id[0].cpc) {
                try {
                    updated_free_credits = result_get_free_paid_credits[0].free_credits - result_sql_get_cpc_business_id[0].cpc
                    sql_free_credits_the_status = `update business_ad_credits set free_credits = '${updated_free_credits}' where business_id = '${business_id}'`
                    result_free_credits_the_status = await exports.run_query(sql_free_credits_the_status)
                    result_click_on_add = await exports.run_query(sql_click_on_add)

                    return res.status(200).send({ status: 'success', message: 'success' })
                } catch (error) {
                    return res.status(500).send({ status: 'failed', message: 'Something went wrong', error })
                }
            } else if (result_get_free_paid_credits[0].paid_credits > 0 && result_get_free_paid_credits[0].paid_credits >= result_sql_get_cpc_business_id[0].cpc) {
                try {
                    updated_paid_credits = result_get_free_paid_credits[0].paid_credits - result_sql_get_cpc_business_id[0].cpc
                    sql_paid_credits_the_status = `update business_ad_credits set paid_credits = '${updated_paid_credits}' where business_id = '${business_id}'`
                    result_free_credits_the_status = await exports.run_query(sql_paid_credits_the_status)
                    updated_paid_credits
                    if (updated_paid_credits == 0.0) {
                        sql_update_the_status = `update business_ad_spent_campaign set status = 'Stop' where id = '${req.body.campaign_id}'`
                        result_update_the_status = await exports.run_query(sql_update_the_status)
                    }
                    result_click_on_add = await exports.run_query(sql_click_on_add)
                    return res.status(200).send({ status: 'success', message: 'success' })

                } catch (error) {
                    return res.status(500).send({ status: 'failed', message: 'Something went wrong', error })
                }
            } else {
                // if there is no credits left then we stop the status of the campaign
                try {
                    sql_update_the_status = `update business_ad_spent_campaign set status = 'Stop' where id = '${req.body.campaign_id}'`
                    result_update_the_status = await exports.run_query(sql_update_the_status)
                    return res.status(400).send({ status: 'Error', message: 'This Ad is no more exists' })
                } catch (error) {
                    return res.status(500).send({ status: 'failed', message: 'Something went wrong', error })
                }
            }
        } else {
            return res.status(500).send({ status: 'failed', message: 'Business has na ad credits' })
        }

    } catch (error) {
        return res.status(500).send({ status: 'failed', message: 'Something went wrong', error })
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