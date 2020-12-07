var jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
    try {
        //var token = req.body.token.split(' ')[1];
        var token = req.headers.authorization.split(' ')[1];
        var decode = jwt.verify(token, 'secret');
        req.userdata = decode;
        next();
    } catch (error) {
        res.status(404).json({
            error: 'Invalid token'
        });
    }
}