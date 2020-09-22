var express = require('express');
var router = express.Router();
var CatalogController = require('../controller/business_catalog');
var CheckAuth = require('../middleware/auth');
const mkdirp = require('mkdirp');

/*to upload the media use multer: start here*/
var multer = require('multer');
var storage_catalog_photos = multer.diskStorage({
  destination: function (req, file, cb) {
    mkdirp.sync('./public/uploads/business_catalogs/');
    cb(null, './public/uploads/business_catalogs/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  }
});
var upload_catalog_photos = multer({ storage: storage_catalog_photos });
/*to upload the media use multer: end here*/


router.post('/list', CheckAuth, CatalogController.listCatalog);

router.post('/add', CheckAuth, CatalogController.addCatalog);

router.post('/detail', CheckAuth, CatalogController.findCatalog);

router.post('/edit', CheckAuth, CatalogController.updateCatalog);

router.post('/add-photo', upload_catalog_photos.array('photo[]', 1000), CheckAuth, CatalogController.addPhotos);

module.exports = router;
