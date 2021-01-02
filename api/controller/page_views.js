var db = require('../config/db');

exports.info = function (req, res, next) {
  try {
    var business_id = req.userdata.business_id;
    var data = {
      impression: {
        value: "15k",
        up: "0",
        down: "12%",
      },
      page_view: {
        value: "33k",
        up: "15%",
        down: "0",
      },
      call_business: {
        value: "125",
        up: "0",
        down: "12%",
      },
      chat_count: {
        value: "500",
        up: "15%",
        down: "0",
      },
      website_click: {
        value: "5k",
        up: "0",
        down: "12%",
      },
      direction_click: {
        value: "2k",
        up: "15%",
        down: "0",
      },
      checkins: {
        value: "1.5k",
        up: "0",
        down: "12%",
      },
      followers: {
        value: "900",
        up: "15%",
        down: "0",
      },
      favorites: {
        value: "3k",
        up: "0",
        down: "12%",
      },
      ratings: {
        value: "450",
        up: "15%",
        down: "0",
      },
      top_keywords: ["Punjabi Dhaba", "Restarurant", "Cafe", "Best Cafe", "Varachaa", "South Indian Food"]
    };
    return res.status(200).json({ status: 'success', message: 'success', data: data });
  } catch (e) {
    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
  }
};