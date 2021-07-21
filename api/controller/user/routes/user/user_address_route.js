express = require('express');
router = express.Router();
var CheckAuth = require('../../middleware/auth');

var UserAddressController = require('../../controller/user/user_address_controller');

// get address from user_id or business id from token
router.post('/get-address', CheckAuth, UserAddressController.getAddress);

router.post('/change-default-address', CheckAuth, UserAddressController.changeDefaultAddress);

router.post('/change-address', CheckAuth, UserAddressController.changeAddress);

router.post('/delete-address', CheckAuth, UserAddressController.deleteAddress);




module.exports = router;