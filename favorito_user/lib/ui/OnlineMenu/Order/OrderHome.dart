import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/order/OrderListData.dart';
import 'package:favorito_user/ui/OnlineMenu/Order/OrderProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/dateformate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../../utils/Extentions.dart';

class OrderHome extends StatelessWidget {
  SizeManager sm;
  bool isFirst = true;
  OrderProvicer vaTrue;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      sm = SizeManager(context);

      vaTrue = Provider.of<OrderProvicer>(context, listen: true);
      vaTrue.userOrderList();
      isFirst = false;
    }
    return Scaffold(
        appBar: AppBar(
            backgroundColor: myBackGround,
            leading: InkWell(
              // onTap: () => Navigator.pushNamed(context, '/'),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              ),
            ),
            title: RichText(
              text: TextSpan(
                  text: '',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'favorite ',
                        style: TextStyle(color: myRed, fontSize: 18),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // navigate to desired screen
                          }),
                    TextSpan(
                        text: 'history ',
                        style: TextStyle(fontSize: 18),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // navigate to desired screen
                          })
                  ]),

              // style: Theme.of(context)
              //     .textTheme
              //     .headline1
              //     .copyWith(fontWeight: FontWeight.w600, fontSize: 20)
            ),
            elevation: 0),
        body: Consumer<OrderProvicer>(builder: (context, _data, child) {
          return ListView(
              children: _data
                  .getUserOrderList()
                  .map((e) => Order(sm: sm, orderListData: e))
                  .toList());
        }));
  }
}

class Order extends StatelessWidget {
  const Order({Key key, @required this.sm, @required this.orderListData})
      : super(key: key);

  final SizeManager sm;
  final OrderListData orderListData;

  @override
  Widget build(BuildContext context) {
    String _va = orderListData.orderDetail
        .map((e) => '\t\u{2022}${e.qty}\tx\t${e.item.capitalize()}\t')
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll(',', '  ');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: sm.h(7),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                          height: sm.h(7),
                          child: ImageMaster(
                              url: orderListData?.businessPhoto ?? ''))),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: sm.w(3.0)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderListData.businessName.capitalize(),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                          Text(orderListData.city,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: myGreyDark,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13)),
                        ]),
                  ),
                ),
                // Icon(Icons.more_vert, color: Colors.black38, size: 30)
              ]),
              Divider(),
              Text(
                'ITEMS:',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black38,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  _va,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                  // maxLines: 2,
                  // softWrap: true,
                  // overflow: TextOverflow.ellipsis,
                  // textAlign: TextAlign.left,
                ),
              ),

              // Container(
              //   child:
              // Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: ),
              // ),
              SizedBox(height: sm.h(1.4)),
              Text(
                'PLACED ON:',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black38,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '${dateFormat9.format(DateTime.parse(orderListData.createdAt))}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: sm.h(1.4)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'TOTAL:',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.black38,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      '\u{20B9} ${orderListData.totalAmount}'.trim(),
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  )
                ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'TYPE:',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.black38,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          '${orderListData.orderType}'.trim(),
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      )
                    ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'PAYMENT:',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.black38,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '${orderListData.paymentType}'.trim(),
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  )
                ])
              ])
            ],
          ),
        ),
      ),
    );
  }
}
//                         height: sm.h(8),

//                 child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
// (
//                 width: sm.w(20),
//                 padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
//                     child: Container(
//                         width: sm.h(8),
//                         child: ImageMaster(url:))),
//               )
