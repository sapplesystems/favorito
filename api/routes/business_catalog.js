var express = require('express');
var router = express.Router();
var CatalogController = require('../controller/business_catalog');
var CheckAuth = require('../middleware/auth');
const mkdirp = require('mkdirp');

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


router.post('/list', CheckAuth, CatalogController.listCatalog);

router.post('/add', CheckAuth, CatalogController.addCatalog);

router.post('/detail', CheckAuth, CatalogController.findCatalog);

router.post('/edit', CheckAuth, CatalogController.updateCatalog);

router.post('/add-photo', upload.array('photo[]', 1000), CheckAuth, CatalogController.addPhotos);

router.post('/delete-photo', CheckAuth, CatalogController.deletePhoto);

module.exports = router;