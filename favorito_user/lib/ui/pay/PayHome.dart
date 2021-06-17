import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
class PayHome extends StatefulWidget {
  var options;
  GlobalKey<ScaffoldState> key;
  PayHome({this.options,this.key});
  // const PayHome({ Key? key }) : super(key: keyStatelessWidget);

  @override
  _PayHomeState createState() => _PayHomeState();
}

class _PayHomeState extends State<PayHome> {
  Razorpay _razorpay = Razorpay();
  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: InkWell(
        onTap: (){
          try {
      _razorpay.open(widget.options);
    } catch (e) {
      processPayment(widget.options);
    }
        },
        child: Text("Checkout",style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(),),
      ),),
    );
  }

  processPayment(opt){
    _razorpay.open(opt);
  }

   void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);

        Navigator.pop(widget.key.currentContext);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
   print("response.code:${response.code}\nresponse.message:${response.message}");
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, toastLength: Toast.LENGTH_SHORT);
  }
}
