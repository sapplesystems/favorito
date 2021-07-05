var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var cors = require('cors')


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
var BusinessBooking = require('./routes/business_booking');
var BusinessAppointment = require('./routes/business_appointment');
var BusinessAdSpentCampaign = require('./routes/business_ad_spent_campaign');
var BusinessMenu = require('./routes/business_menu');
var BusinessMenuOnlineStore = require('./routes/business_menu_online_store');
var BusinessOrder = require('./routes/business_order');
var PageViews = require('./routes/page_views');
var BusinessTag = require('./routes/business_tag');
var BusinessAttribute = require('./routes/business_attribute');
var BusinessChecklist = require('./routes/business_checklist');

var BusinessReviewController = require('./routes/business_review_route');

/*** USER ROUTES DETAIL START****/
var BusinessUser = require('./routes/user/business_users');
var userProfileRoute = require('./routes/user/user_profile_route');
var userWaitlistRoute = require('./routes/user/user_waitlist_route');
var userBookingRoute = require('./routes/user/user_booking_route');
var userAppointmentRoute = require('./routes/user/user_appointment_route');
var userOrderRoute = require('./routes/user/user_order_route');
var userBusinessRoute = require('./routes/user/user_business_route');
var userAddressRoute = require('./routes/user/user_address_route');
var userCheckinRoute = require('./routes/user/user_checkin_route');
var userBusinessMenuRoute = require('./routes/user/user_business_menu_route');
var userChangePasswordController = require('./routes/user/user_change_password_route');
var userAdsRoute = require('./routes/user/user_ads_route');
var userJobRoute = require('./routes/user/user_job_route');



/*** USER ROUTES DETAIL END *****/


var app = express();
app.use(cors())

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));


app.use('/api/business-user', BusinessUsersRouter);
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
app.use('/api/business-booking', BusinessBooking);
app.use('/api/business-appointment', BusinessAppointment);
app.use('/api/business-ad-spent-campaign', BusinessAdSpentCampaign);
app.use('/api/business-menu', BusinessMenu);
app.use('/api/business-menu-online-store', BusinessMenuOnlineStore);
app.use('/api/business-order', BusinessOrder);
app.use('/api/page-views', PageViews);
app.use('/api/tag', BusinessTag);
app.use('/api/attribute', BusinessAttribute);
app.use('/api/business-checklist', BusinessChecklist);
app.use('/api/business-review', BusinessReviewController);

/**
 * USING USER ROUTES
 */
app.use('/api/user', BusinessUser);
app.use('/api/user-waitlist', userWaitlistRoute);
app.use('/api/user-booking', userBookingRoute);
app.use('/api/user-appointment', userAppointmentRoute);
app.use('/api/user-checkin', userCheckinRoute);

app.use('/api/user-business-menu', userBusinessMenuRoute);


/**
 * USER ROUTES FOR PROFILE 
 */
app.use('/api/user-profile', userProfileRoute);

/**
 * USER ROUTES FOR ORDER 
 */
app.use('/api/user-order', userOrderRoute);

/**
 * USER ROUTES FOR USER BUSINESS
 */
app.use('/api/user-business', userBusinessRoute)

/**
 * USER ROUTES FOR ADDRESS
 */
app.use('/api/user-address', userAddressRoute)


/**
 * USER ROUTES FOR ADDRESS
 */
app.use('/api/user-ads', userAdsRoute)

/**
 * USER ROUTES FOR CHANGE PASSWORD
 */
app.use('/api/user-change-password', userChangePasswordController)

/* 
user job route
*/
app.use('/api/user-job', userJobRoute)


// catch 404 and forward to error handler
app.use(function(req, res, next) {
    next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

    // render the error page
    res.status(err.status || 500);
    res.render('error');
});

module.exports = app;