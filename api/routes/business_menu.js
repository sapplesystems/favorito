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
 * GET LIST ALL MENU
 */
router.post('/list', CheckAuth, MenuController.listAllMenu);


/**
 * GET LIST ALL MENU
 */
router.post('/change-menu-status', CheckAuth, MenuController.changeMenuStatus);

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
 * GET MENU CATEGORY BY PAGINATION
 */
router.post('/category-list-pagination', CheckAuth, MenuController.getMenuCategoryListByPagination);


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

/**
 * DELETE MENU ITEM  PHOTO
 */
router.post('/menu-item-photo-delete', CheckAuth, MenuController.deleteMenuPhoto);

// delete the menu
router.post('/delete-menu-item', CheckAuth, MenuController.deleteMenu);

module.exports = router;