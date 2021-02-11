import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessHoursProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkingDateTime extends StatelessWidget {
  SizeManager sm;
  BusinessHoursProvider bhpTrue;
  BusinessHoursProvider bhpFalse;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    bhpTrue = Provider.of<BusinessHoursProvider>(context, listen: true);
    bhpFalse = Provider.of<BusinessHoursProvider>(context, listen: true);
    bhpFalse.SetContexts(context);
    bhpFalse.localizations = MaterialLocalizations.of(context);
    return Column(children: [
      Container(
        height: sm.h(8.5),
        child: Expanded(
          flex: 1,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            for (int i = 0; i < 7; i++)
              InkWell(
                onTap: () => bhpFalse.selectDay(i),
                child: Container(
                    width: sm.w(12),
                    margin: EdgeInsets.all(2),
                    decoration: bhpFalse.daysHours[i].selected
                        ? bhpFalse.bdct
                        : (!bhpTrue.getMod() && bhpTrue.daysHours[i].open)
                            ? bhpTrue.bdctt
                            : bhpTrue.bdcf,
                    child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          children: [
                            Text(bhpFalse.daylist[i], //got
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: bhpTrue.daysHours[i].selected
                                        ? Colors.white
                                        : (!bhpTrue.getMod() &&
                                                bhpTrue.daysHours[i].open)
                                            ? Colors.white
                                            : myGrey)),
                            Icon(Icons.done, color: Colors.white)
                          ],
                        ))),
              )
          ]),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
              onTap: () => bhpFalse.pickDate(true),
              child: fromTo(txt: bhpFalse.startTime, clr: myGrey)),
          Text("-", style: TextStyle(fontSize: 40, color: myGrey)),
          InkWell(
              onTap: () => bhpFalse.pickDate(false),
              child: fromTo(txt: bhpFalse.endTime, clr: myGrey))
        ]),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: sm.w(20),
            child: InkWell(
                onTap: () => bhpTrue.prepareData(),
                child: fromTo(txt: "Add", clr: myRed)),
          ),
          Container(
            width: sm.w(20),
            child: InkWell(
                onTap: () => Navigator.pop(context),
                child: fromTo(txt: "Close", clr: myRed)),
          ),
        ],
      )
    ]);
  }
}
