import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/ui/booking/BookingProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookigDateRistriction extends StatelessWidget {
  MaterialLocalizations localizations;
  bool _needValidate = false;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    localizations = MaterialLocalizations.of(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          centerTitle: true,
          title: Text(
            'Restrictions',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.w800, fontSize: 22),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
          child: Consumer<BookingProvider>(builder: (context, data, child) {
            return Column(
              children: [
                Card(
                  child: Builder(builder: (context) {
                    return Form(
                        key: RIKeys.josKeys26,
                        autovalidate: _needValidate,
                        child: Padding(
                          padding: EdgeInsets.all(sm.w(4)),
                          child: Column(children: [
                            InkWell(
                              onTap: () {
                                data.isSingleDate = !data.isSingleDate;

                                data.notifyListeners();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "For single day",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                      ),
                                      Icon(
                                        data.isSingleDate == true
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: data.isSingleDate == true
                                            ? Colors.red
                                            : Colors.grey,
                                      )
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: InkWell(
                                onTap: () {
                                  data.selectDate(context, localizations);
                                },
                                child: txtfieldboundry(
                                    isEnabled: false,
                                    controller: data.controller[6],
                                    title: "Start DateTime",
                                    security: false,
                                    error: 'fdgf',
                                    valid: true),
                              ),
                            ),
                            Visibility(
                              visible: !data.isSingleDate,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: InkWell(
                                    onTap: () {
                                      data.selectDate1(context, localizations);
                                    },
                                    child: txtfieldboundry(
                                        isEnabled: false,
                                        controller: data.controller[7],
                                        title: "End DateTime",
                                        security: false,
                                        valid: true)),
                              ),
                            )
                          ]),
                        ));
                  }),
                ),
                data.getIsProgress()
                    ? CircularProgressIndicator()
                    : MyOutlineButton(
                        title: "Submit",
                        function: () {
                          if (data.isSingleDate) {
                            if (data.controller[6].text.trim() != "") {
                              data.funSublimRestriction(context, [], false);
                            } else
                              BotToast.showText(
                                  text: 'Please Select Start Date');
                          } else {
                            if (data.controller[6].text.trim() != "" &&
                                data.controller[7].text.trim() != "") {
                              data.funSublimRestriction(context, [], false);
                            } else if (data.controller[6].text.trim() == "") {
                              BotToast.showText(
                                  text: 'Please Select Start Date');
                            } else if (data.controller[7].text.trim() == "") {
                              BotToast.showText(text: 'Please Select End Date');
                            }
                          }
                        })
              ],
            );
          }),
        ));
  }
}
