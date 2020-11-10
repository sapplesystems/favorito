var express = require('express');
var router = express.Router();
//var bodyParser = require('body-parser');
var MenuController = require('../controller/business_menu');
var CheckAuth = require('../middleware/auth');
const mkdirp = require('mkdirp');
//router.use(bodyParser.json());
//router.use(bodyParser.urlencoded({extended: true}));

/*to upload the media use multer: start here*/
var multer = require('multer');
var storage = multer.diskStorage({
    destination: function(req, file, cb) {
        mkdirp.sync('./public/uploads/');
        cb(null, './public/uploads/');
    },
    filename: function(req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname);
    }
});
var upload = multer({ storage: storage });
/*to upload the media use multer: end here*/

/**
 * GET STATIC VARIABLE
 */
router.post('/dd-verbose', CheckAuth, MenuController.dd_verbose);

/**
 * CREATE NEW MENU ITEM
 */
router.post('/list', CheckAuth, MenuController.listAllMenu);

/**
 * CREATE NEW MENU ITEM
 */
router.post('/create', upload.array('photo[]', 1000), CheckAuth, MenuController.createMenuItem);

/**
 * EDIT MENU ITEM
 */
router.post('/edit', upload.array('photo[]', 1000), CheckAuth, MenuController.editMenuItem);

/**
 * ADD MENU ITEM PHOTOS
 */
router.post('/add-photos', upload.array('photo[]', 1000), CheckAuth, MenuController.addMenuPhotos);

/**
 * GET MENU CATEGORY LIST
 */
router.post('/category-list', CheckAuth, MenuController.getMenuCategoryList);


/**
 * ADD BUSINESS MENU CATEGORY
 */
router.post('/add-category', multer().array(), CheckAuth, MenuController.addCategory);


/**
 * EDIT BUSINESS MENU CATEGORY
 */
router.post('/edit-category', multer().array(), CheckAuth, MenuController.editCategory);


/**
 * GET BUSINESS MENU SETTING
 */
router.post('/setting', CheckAuth, MenuController.getSetting);


/**
 * GET BUSINESS MENU ITEM DETAIL BY menu_item_id
 */
router.post('/menu-item-detail', CheckAuth, MenuController.getMenuItems);


/**
 * UPDATE BUSINESS MENU SETTING
 */
router.post('/setting-update', CheckAuth, MenuController.updateMenuSetting);

module.exports = router;