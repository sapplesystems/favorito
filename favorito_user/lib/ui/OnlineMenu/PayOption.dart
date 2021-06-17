import 'package:favorito_user/model/appModel/Menu/order/ModelOption.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuHomeProvider.dart';
import 'package:favorito_user/ui/OnlineMenu/Paydata.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/Extentions.dart';
class PayOption extends StatelessWidget {
  

  Widget build(BuildContext context) {
    // vaTrue = Provider.of<MenuHomeProvider>(context, listen: true);
    return
    Consumer<MenuHomeProvider>(builder: (context,data,chils){return Align(
      alignment: Alignment.centerLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: Text('Pay Mode',
              textScaleFactor: 1.4,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 12)),
        ),
        for (PayData _data in data.payDataList)
          Container(
            height: 30,
            padding: EdgeInsets.only(left: 18),
            child: RadioListTile(
              value: _data,
              groupValue: data.selectedPayData,
              onChanged: (_v) {
                print(_v);
                data.setSelectedPay(_v);
              },
              title: Text(_data.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
              activeColor: myRed,
              selected: data.selectedPayData == _data,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Text('Order Type',
              textScaleFactor: 1.4,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 12)),
        ),
        for (OrderType _data in data.orderType)
          Container(
            height: 30,
            padding: EdgeInsets.only(left: 18),
            child: RadioListTile(
              value: _data,
              groupValue: data.selectedOrderType??0,
              onChanged: (_v) {
                print(_v);
                data.setSelectedOrderType(_v);
              },
              title: Text(_data.attribute.capitalize().replaceAll('_', " ")+"(Minimun \u{20B9}${_data.minimumBill??0})",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
              activeColor: myRed,
              selected: data.selectedOrderType == _data,
            ),
          ),
      ]),
    );
  },);
  
  }
}
