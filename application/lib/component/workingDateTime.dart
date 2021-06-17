import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkingDateTime extends StatelessWidget {
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Consumer<BusinessProfileProvider>(builder: (context, data, child) {
      data.SetContexts(context);
      data.localizations = MaterialLocalizations.of(context);
      return Column(children: [
        Text(data.getMod() ? data.hoursTitle1 : data.hoursTitle2),
        Container(
          height: sm.h(8.5),
          child: ListView(scrollDirection: Axis.horizontal, children: [
            for (int i = 0; i < 7; i++)
              InkWell(
                onTap: () {
                  data.selectDay(i);
                },
                child: Container(
                    width: sm.w(12),
                    margin: EdgeInsets.all(2),
                    decoration: data.daysHours[i]?.selected
                        ? data?.bdct
                        : (!data.getMod() && data.daysHours[i].open)
                            ? data.bdctt
                            : data.bdcf,
                    child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(children: [
                          Text(data.daylist[i], //got
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: data.daysHours[i].selected
                                      ? Colors.white
                                      : (!data.getMod() &&
                                              data.daysHours[i].open)
                                          ? Colors.white
                                          : myGrey)),
                          Icon(Icons.done, color: Colors.white)
                        ]))),
              )
          ]),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
                onTap: () => data.pickDate(true),
                child: fromTo(txt: data.startTime, clr: myGrey)),
            Text("-", style: TextStyle(fontSize: 40, color: myGrey)),
            InkWell(
                onTap: () => data.pickDate(false),
                child: fromTo(txt: data.endTime, clr: myGrey))
          ]),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: sm.w(20),
            child: InkWell(
                onTap: () => data.prepareData(),
                child: fromTo(txt: "Add", clr: myRed)),
          ),
          Container(
            width: sm.w(20),
            child: InkWell(
                onTap: () => Navigator.pop(context),
                child: fromTo(txt: "Close", clr: myRed)),
          ),
        ])
      ]);
    });
  }
}
