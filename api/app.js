var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

//var indexRouter = require('./routes/index');
var BusinessUsersRouter = require('./routes/business_users');
//var ProductsRouter = require('./routes/products');
var BusinessTypeRouter = require('./routes/business_type');
var BusinessCategoryRouter = require('./routes/business_category');
var BusinessSubCategoryRouter = require('./routes/business_sub_category');
var BusinessDashboardRouter = require('./routes/business_dashboard');
var CountryStateCityRouter = require('./routes/country_state_city');
var ChangePasswordRouter = require('./routes/change_password');
var BusinessNotificationRouter = require('./routes/business_notification');
var BusinessOfferRouter = require('./routes/business_offer');
var JobRouter = require('./routes/job');
var BusinessCatalog = require('./routes/business_catalog');
var BusinessClaim = require('./routes/business_claim');
var BusinessHighLight = require('./routes/business_highlight');
var BusinessWaitlist = require('./routes/business_waitlist');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

//app.use('/', indexRouter);
app.use('/api/business-user', BusinessUsersRouter);
//app.use('/api/product', ProductsRouter);
app.use('/api/business-type', BusinessTypeRouter);
app.use('/api/business-category', BusinessCategoryRouter);
app.use('/api/business-sub-category', BusinessSubCategoryRouter);
app.use('/api/business-dashboard', BusinessDashboardRouter);
app.use('/api/state-city', CountryStateCityRouter);
app.use('/api/change-password', ChangePasswordRouter);
app.use('/api/notification', BusinessNotificationRouter);
app.use('/api/offer', BusinessOfferRouter);
app.use('/api/job', JobRouter);
app.use('/api/catalog', BusinessCatalog);
app.use('/api/business-claim', BusinessClaim);
app.use('/api/business-highlight', BusinessHighLight);
app.use('/api/business-waitlist', BusinessWaitlist);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

    // render the error page
    res.status(err.status || 500);
    res.render('error');
});

module.exports = app;
