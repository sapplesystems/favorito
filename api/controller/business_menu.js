var db = require('../config/db');
var menu_type_id = 1;// BY Default for business is 1 and for freelancer is 2
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

/**
 * GET STATIC VARIABLE
 */
exports.dd_verbose = async function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var data = {
            category: await exports.getMenuCategories(business_id, req),
            type: ['Veg', 'Nonveg'],
            available_on: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
        };
        return res.status(200).json({ status: 'success', message: 'success', data: data });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * GET MENU CATEGORY LIST
 */
exports.getMenuCategoryList = async function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var category = await exports.getMenuCategories(business_id, req)
        return res.status(200).json({ status: 'success', message: 'success', data: category });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET MENU CATEGORY
 */
exports.getMenuCategories = function (business_id, req) {
    try {
        return new Promise(function (resolve, reject) {
            var COND = "business_id='" + business_id + "' AND menu_type_id='" + menu_type_id + "' AND is_activated='1' AND deleted_at IS NULL";
            if (req.body.category_id != '' && req.body.category_id != 'undefined' && req.body.category_id != null) {
                COND += " AND id='" + req.body.category_id + "'";
            }

            var sql = "SELECT id, category_name, details, slot_start_time, slot_end_time, available_on, out_of_stock \n\
            FROM business_menu_category \n\
            WHERE " + COND;
            db.query(sql, function (e, cat) {
                var data = (cat.length > 1) ? cat : cat[0];
                return resolve(data);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};



/**
 * LIST ALL MENU
 */
exports.listAllMenu = async function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id, category_name FROM business_menu_category \n\
                    WHERE business_id='"+ business_id + "' AND menu_type_id='" + menu_type_id + "' \n\
                    AND parent_id='0' AND is_activated='1' AND deleted_at IS NULL";            
        db.query(sql, async function (err, result) {
            var data = [];
            var result_length = result.length;
            for (var i = 0; i < result_length; i++) {
                var category_id = result[i].id;
                var category_name = result[i].category_name;
                var items = await exports.getCategoryMenusItems(business_id, category_id);
                data.push({
                    category_id: category_id,
                    category_name: category_name,
                    items: items
                });
            }

            return res.status(200).json({ status: 'success', message: 'sucsess', data: data });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * GET CATEGORY MENUS
 */
exports.getCategoryMenusItems = async function (business_id, category_id) {
    try {
        return new Promise(function (resolve, reject) {
            var sql = "SELECT id, title, price, description, quantity, `type`, max_qty_per_order, \n\
                        (SELECT GROUP_CONCAT(id) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photo_id, \n\
                        (SELECT GROUP_CONCAT(CONCAT('"+ img_path + "',photo)) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photos \n\
                        FROM business_menu_item \n\
                        WHERE business_id='" + business_id + "' AND menu_category_id='" + category_id + "'";           
            db.query(sql, async function (e, items) {
                var items_length = items.length;
                for (var i = 0; i < items_length; i++) {
                    if(items[i].photo_id!=null && items[i].photos!=null){
                        items[i].photo_id = (items[i].photo_id).split(',');
                        items[i].photos = (items[i].photos).split(',');
                    }
                }
                return resolve(items);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * CREATE NEW MENU ITEM
 */
exports.createMenuItem = async function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.title == '' || req.body.title == 'undefined' || req.body.title == null) {
            return res.status(403).json({ status: 'error', message: 'Title not found.' });
        } else if (req.body.category_id == '' || req.body.category_id == 'undefined' || req.body.category_id == null) {
            return res.status(403).json({ status: 'error', message: 'Category id not found.' });
        } else if (req.body.price == '' || req.body.price == 'undefined' || req.body.price == null) {
            return res.status(403).json({ status: 'error', message: 'Price not found.' });
        } else if (req.body.description == '' || req.body.description == 'undefined' || req.body.description == null) {
            return res.status(403).json({ status: 'error', message: 'Description not found.' });
        } else if (req.body.quantity == '' || req.body.quantity == 'undefined' || req.body.quantity == null) {
            return res.status(403).json({ status: 'error', message: 'Quantity not found.' });
        } else if (req.body.type == '' || req.body.type == 'undefined' || req.body.type == null) {
            return res.status(403).json({ status: 'error', message: 'Type not found.' });
        } else if (req.body.max_qty_per_order == '' || req.body.max_qty_per_order == 'undefined' || req.body.max_qty_per_order == null) {
            return res.status(403).json({ status: 'error', message: 'Max quantity per order not found.' });
        }

        var postval = {
            business_id: business_id,
            title: req.body.title,
            menu_category_id: req.body.category_id,
            price: req.body.price,
            description: req.body.description,
            quantity: req.body.quantity,
            type: req.body.type,
            max_qty_per_order: req.body.max_qty_per_order,
        };

        var sql = "INSERT INTO business_menu_item set ?";

        db.query(sql, postval, async function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            var menu_id = result.insertId;
            await exports.addPhotos(business_id, menu_id, req);
            return res.status(200).json({ status: 'success', message: 'Menu item created successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * EDIT MENU ITEM
 */
exports.editMenuItem = async function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.menu_item_id == '' || req.body.menu_item_id == 'undefined' || req.body.menu_item_id == null) {
            return res.status(403).json({ status: 'error', message: 'Menu item id not found.' });
        }

        var item_id = req.body.menu_item_id;
        var update_columns = " updated_at=now() ";

        if (req.body.title != '' && req.body.title != 'undefined' && req.body.title != null) {
            update_columns += ", title=" + db.escape(req.body.title) + "";
        }
        if (req.body.category_id != '' && req.body.category_id != 'undefined' && req.body.category_id != null) {
            update_columns += ", menu_category_id='" + req.body.category_id + "'";
        }
        if (req.body.price != '' && req.body.price != 'undefined' && req.body.price != null) {
            update_columns += ", price='" + req.body.price + "'";
        }
        if (req.body.description != '' && req.body.description != 'undefined' && req.body.description != null) {
            update_columns += ", description=" + db.escape(req.body.description) + "";
        }
        if (req.body.quantity != '' && req.body.quantity != 'undefined' && req.body.quantity != null) {
            update_columns += ", quantity='" + req.body.quantity + "'";
        }
        if (req.body.type != '' && req.body.type != 'undefined' && req.body.type != null) {
            update_columns += ", `type`='" + req.body.type + "'";
        }
        if (req.body.max_qty_per_order != '' && req.body.max_qty_per_order != 'undefined' && req.body.max_qty_per_order != null) {
            update_columns += ", max_qty_per_order='" + req.body.max_qty_per_order + "'";
        }

        var sql = "update business_menu_item set " + update_columns + " where id='" + item_id + "'";
        db.query(sql, async function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            if (req.files && req.files.length) {
                await exports.addPhotos(business_id, item_id, req);
            }
            return res.status(200).json({ status: 'success', message: 'Menu item updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * ADD MENU ITEM PHOTOS
 */
exports.addMenuPhotos = async function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.menu_id == '' || req.body.menu_id == 'undefined' || req.body.menu_id == null) {
            return res.status(403).json({ status: 'error', message: 'Menu id not found.' });
        }
        var menu_id = req.body.menu_id;

        await exports.addPhotos(business_id, menu_id, req);
        return res.status(200).json({ status: 'success', message: 'Photo uploaded successfully.' });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * ADD BUSINESS MENU PHOTOS
 */
exports.addPhotos = function (business_id, menu_id, req) {
    try {
        return new Promise(function (resolve, reject) {

            if (req.files && req.files.length) {
                var file_count = req.files.length;
                for (var i = 0; i < file_count; i++) {
                    var filename = req.files[i].filename;
                    var sql = "INSERT INTO `business_menu_photo`(business_id, business_menu_item_id, photo) \n\
                            VALUES ('"+ business_id + "','" + menu_id + "','" + filename + "')";
                    db.query(sql);
                }
                resolve(true);
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * ADD BUSINESS MENU CATEGORY
 */
exports.addCategory = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.category_name == '' || req.body.category_name == 'undefined' || req.body.category_name == null) {
            return res.status(403).json({ status: 'error', message: 'Category name not found.' });
        } else if (req.body.details == '' || req.body.details == 'undefined' || req.body.details == null) {
            return res.status(403).json({ status: 'error', message: 'Category detail not found.' });
        } else if (req.body.slot_start_time == '' || req.body.slot_start_time == 'undefined' || req.body.slot_start_time == null) {
            return res.status(403).json({ status: 'error', message: 'Slot start time not found.' });
        } else if (req.body.slot_end_time == '' || req.body.slot_end_time == 'undefined' || req.body.slot_end_time == null) {
            return res.status(403).json({ status: 'error', message: 'Slot end time not found.' });
        } else if (req.body.available_on == '' || req.body.available_on == 'undefined' || req.body.available_on == null) {
            return res.status(403).json({ status: 'error', message: 'Available days not found.' });
        }

        var available_on = req.body.available_on;

        var postval = {
            business_id: business_id,
            menu_type_id: menu_type_id,
            category_name: req.body.category_name,
            details: req.body.details,
            slot_start_time: req.body.slot_start_time,
            slot_end_time: req.body.slot_end_time,
            available_on: available_on.join()
        };

        var sql = "INSERT INTO business_menu_category set ?";

        db.query(sql, postval, async function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Category saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * EDIT BUSINESS MENU CATEGORY
 */
exports.editCategory = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.category_id == '' || req.body.category_id == 'undefined' || req.body.category_id == null) {
            return res.status(403).json({ status: 'error', message: 'Category id not found.' });
        }

        var id = req.body.category_id;
        var update_columns = " updated_at=now() ";

        if (req.body.category_name != '' && req.body.category_name != 'undefined' && req.body.category_name != null) {
            update_columns += ", category_name='" + req.body.category_name + "' ";
        }
        if (req.body.details != '' && req.body.details != 'undefined' && req.body.details != null) {
            update_columns += ", details='" + req.body.details + "' ";
        }
        if (req.body.slot_start_time != '' && req.body.slot_start_time != 'undefined' && req.body.slot_start_time != null) {
            update_columns += ", slot_start_time='" + req.body.slot_start_time + "' ";
        }
        if (req.body.slot_end_time != '' && req.body.slot_end_time != 'undefined' && req.body.slot_end_time != null) {
            update_columns += ", slot_end_time='" + req.body.slot_end_time + "' ";
        }
        if (req.body.available_on != '' && req.body.available_on != 'undefined' && req.body.available_on != null) {
            var available_on = req.body.available_on;
            update_columns += ", available_on='" + available_on + "' ";
        }
        if (req.body.out_of_stock != '' && req.body.out_of_stock != 'undefined' && req.body.out_of_stock != null) {
            update_columns += ", out_of_stock='" + req.body.out_of_stock + "' ";
        }

        var sql = "update business_menu_category set " + update_columns + " where id='" + id + "'";

        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Category updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET BUSINESS MENU SETTING
 */
exports.getSetting = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT accepting_order, take_away_start_time, take_away_end_time, take_away_minimum_bill, take_away_packaging_charge, \n\
                    dine_in_start_time, dine_in_end_time, delivery_start_time, delivery_end_time, delivery_minium_bill, delivery_packaging_charge \n\
                    FROM business_menu_setting WHERE business_id='"+ business_id + "'";

        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: result[0] });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * UPDATE BUSINESS MENU SETTING
 */
exports.updateMenuSetting = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        var update_columns = " updated_at=now() ";

        if (req.body.accepting_order != '' && req.body.accepting_order != 'undefined' && req.body.accepting_order != null) {
            update_columns += ", accepting_order='" + req.body.accepting_order + "' ";
        }
        if (req.body.take_away_start_time != '' && req.body.take_away_start_time != 'undefined' && req.body.take_away_start_time != null) {
            update_columns += ", take_away_start_time='" + req.body.take_away_start_time + "' ";
        }
        if (req.body.take_away_end_time != '' && req.body.take_away_end_time != 'undefined' && req.body.take_away_end_time != null) {
            update_columns += ", take_away_end_time='" + req.body.take_away_end_time + "' ";
        }
        if (req.body.take_away_minimum_bill != '' && req.body.take_away_minimum_bill != 'undefined' && req.body.take_away_minimum_bill != null) {
            update_columns += ", take_away_minimum_bill='" + req.body.take_away_minimum_bill + "' ";
        }
        if (req.body.take_away_packaging_charge != '' && req.body.take_away_packaging_charge != 'undefined' && req.body.take_away_packaging_charge != null) {
            update_columns += ", take_away_packaging_charge='" + req.body.take_away_packaging_charge + "' ";
        }
        if (req.body.dine_in_start_time != '' && req.body.dine_in_start_time != 'undefined' && req.body.dine_in_start_time != null) {
            update_columns += ", dine_in_start_time='" + req.body.dine_in_start_time + "' ";
        }
        if (req.body.dine_in_end_time != '' && req.body.dine_in_end_time != 'undefined' && req.body.dine_in_end_time != null) {
            update_columns += ", dine_in_end_time='" + req.body.dine_in_end_time + "' ";
        }
        if (req.body.delivery_start_time != '' && req.body.delivery_start_time != 'undefined' && req.body.delivery_start_time != null) {
            update_columns += ", delivery_start_time='" + req.body.delivery_start_time + "' ";
        }
        if (req.body.delivery_end_time != '' && req.body.delivery_end_time != 'undefined' && req.body.delivery_end_time != null) {
            update_columns += ", delivery_end_time='" + req.body.delivery_end_time + "' ";
        }
        if (req.body.delivery_minium_bill != '' && req.body.delivery_minium_bill != 'undefined' && req.body.delivery_minium_bill != null) {
            update_columns += ", delivery_minium_bill='" + req.body.delivery_minium_bill + "' ";
        }
        if (req.body.delivery_packaging_charge != '' && req.body.delivery_packaging_charge != 'undefined' && req.body.delivery_packaging_charge != null) {
            update_columns += ", delivery_packaging_charge='" + req.body.delivery_packaging_charge + "' ";
        }

        var sql = "update business_menu_setting set " + update_columns + " where business_id='" + business_id + "'";

        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Setting updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};