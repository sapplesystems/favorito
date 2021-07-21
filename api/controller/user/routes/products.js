var express = require('express');
var router = express.Router();
var db = require('../config/db');
var bodyParser = require('body-parser');
var CheckAuth = require('../middleware/auth');
var ProductController = require('../controller/product');

var multer = require('multer');
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './public/uploads/')
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname)
  }
});
var upload = multer({ storage: storage });

//router.use(bodyParser.json()); // for parsing application/json
//router.use(bodyParser.urlencoded({extended: true})); // for parsing application/x-www-form-urlencoded


/* get method for fetch all products. */
router.get('/', CheckAuth, ProductController.getAllProducts);

/*get method for fetch single product*/
router.post('/detail', function (req, res, next) {
  var id = req.body.id;
  var sql = "SELECT * FROM products WHERE id='" + id + "'";
  db.query(sql, function (err, row, fields) {
    if (err) {
      res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
    }
    res.status(200).send({ status: 'success', message: 'success', data: row[0] });
  })
});

/*post method for create product*/
router.post('/create', upload.single('image'), CheckAuth, function (req, res, next) {
  console.log(req.userdata);

  var name = req.body.name;
  var sku = req.body.sku;
  var price = req.body.price;
  var image = req.file.filename;

  var sql = "INSERT INTO products (image, category_id,sub_category_id,`name`,dealer_price,market_price,bar_code,sku,contents,created_date,expiry_date,quantity,short_description,description,cgst,sgst,igst,bv_type,created_by,created_at) VALUES('" + image + "','1','2','" + name + "','" + price + "','" + price + "','3L5K636L346JH3L56JH356','" + sku + "','',CURDATE(),DATE_ADD(CURDATE(), INTERVAL 30 DAY),'100','test short description','test long description','10','10','20','70','1',NOW())";
  db.query(sql, function (err, result) {
    if (err) {
      res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
    }
    res.status(200).send({ status: 'success', message: 'success', id: result.insertId, data: result });
    //res.json({ 'status': 'success', id: result.insertId });
  })
});

/*put method for update product*/
router.post('/update', function (req, res, next) {
  var id = req.body.id;
  var name = req.body.name;
  var sku = req.body.sku;
  var price = req.body.price;

  var sql = `UPDATE products SET name="${name}", sku="${sku}", market_price="${price}" WHERE id=${id}`;
  db.query(sql, function (err, result) {
    if (err) {
      res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
    }
    res.json({ 'status': 'success' })
  })
});

/*delete method for delete product*/
router.post('/delete', function (req, res, next) {
  var id = req.body.id;
  if (id == '' || id == null) {
    res.status(500).send({ status: 'error', message: 'Something went wrong.', data: 'param required' });
  }
  var sql = `UPDATE products SET deleted_at=now() WHERE id=${id}`;
  db.query(sql, function (err, result) {
    if (err) {
      res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
    }
    res.json({ 'status': 'success' })
  })
})

module.exports = router;
