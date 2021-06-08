import 'package:favorito_user/ui/OnlineMenu/MenuHomeProvider.dart';
import 'package:favorito_user/ui/OnlineMenu/Paydata.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PayOption extends StatelessWidget {
  MenuHomeProvider vaTrue;

  Widget build(BuildContext context) {
    vaTrue = Provider.of<MenuHomeProvider>(context, listen: true);
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: Text('pay mode',
              textScaleFactor: 1.4,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 12)),
        ),
        for (PayData _data in vaTrue.payDataList)
          Container(
            height: 30,
            padding: EdgeInsets.only(left: 18),
            child: RadioListTile(
              value: _data,
              groupValue: vaTrue.selectedPayData,
              onChanged: (_v) {
                vaTrue.setSelectedPay(_v);
              },
              title: Text(_data.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
              activeColor: myRed,
              selected: vaTrue.selectedPayData == _data,
            ),
          )
      ]),
    );
  }
}
