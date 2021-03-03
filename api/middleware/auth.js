var jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
    //var headerToken = req.headers;
    //console.log(headerToken);
    try {
        //var token = req.body.token.split(' ')[1];
        var token = req.headers.authorization.split(' ')[1];
        var decode = jwt.verify(token, 'secret');
        req.userdata = decode;
        next();
    } catch (error) {
        res.status(401).json({
            error: 'Invalid token'
        });
    }
}
