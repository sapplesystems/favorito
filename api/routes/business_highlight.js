var express = require('express');
var router = express.Router();
var HighlightController = require('../controller/business_highlight');
var CheckAuth = require('../middleware/auth');
const mkdirp = require('mkdirp');

/*to upload the media use multer: start here*/
var multer = require('multer');
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    mkdirp.sync('./public/uploads/business_highlight/');
    cb(null, './public/uploads/business_highlight/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  }
});
var upload = multer({ storage: storage });
/*to upload the media use multer: end here*/

router.post('/detail', CheckAuth, HighlightController.getHighlight);

router.post('/save', CheckAuth, HighlightController.addHighlight);

router.post('/add-photo', upload.array('photo[]', 1000), CheckAuth, HighlightController.addPhotos);

module.exports = router;
