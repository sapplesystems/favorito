import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequiredDataModel.dart';

import 'package:Favorito/ui/notification/NotificationProvider.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:provider/provider.dart';

class CreateNotification extends StatelessWidget {
  NotificationsProvider vaTrue;
  NotificationsProvider vaFalse;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    vaTrue = Provider.of<NotificationsProvider>(context, listen: true);
    vaFalse = Provider.of<NotificationsProvider>(context, listen: false);
    vaTrue.setContext(context);

    return WillPopScope(
      onWillPop: () {
        vaTrue
          ..setCountryVisible(false)
          ..setStateVisible(false)
          ..setCityVisible(false)
          ..setPincodeVisible(false);
      },
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    vaTrue
                      ..setCountryVisible(false)
                      ..setStateVisible(false)
                      ..setCityVisible(false)
                      ..setPincodeVisible(false);
                    Navigator.of(context).pop();
                  }),
              iconTheme: IconThemeData(color: Colors.black),
              title: Text("Create Notification",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Gilroy-Bold',
                      letterSpacing: .2))),
          body: ListView(children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sm.w(4), vertical: sm.h(4)),
                child: Card(
                    child: Builder(
                        builder: (context) => Form(
                            key: vaTrue.formKey,
                            autovalidate: vaTrue.autoValidateForm,
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(children: [
                                  txtfieldboundry(
                                      controller:
                                          Provider.of<NotificationsProvider>(
                                                  context,
                                                  listen: true)
                                              .myTitleEditController,
                                      title: "Title",
                                      security: false,
                                      valid: true),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: txtfieldboundry(
                                        controller:
                                            vaTrue.myDescriptionEditController,
                                        title: "Description",
                                        security: false,
                                        maxLines: 5,
                                        valid: true),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownSearch<String>(
                                      key: vaTrue.actioncKey,
                                      validator: (v) =>
                                          v == '' ? "required field" : null,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      mode: Mode.MENU,
                                      selectedItem: vaTrue.selectedAction ?? '',
                                      maxHeight:
                                          (vaTrue.getActionData()?.length ??
                                                  0) *
                                              54.0,
                                      items: vaTrue.getActionData(),
                                      label: "Action",
                                      hint: "Please Select Action",
                                      showSearchBox: false,
                                      onChanged: (value) {
                                        if (value ==
                                            vaTrue.notificationRequiredData.data
                                                .action[0]) {
                                          vaTrue.contactHintText =
                                              'Enter number for call';
                                        } else {
                                          vaTrue.contactHintText =
                                              'Enter email for chat';
                                        }
                                        vaTrue.selectedAction = value;
                                        vaTrue.notifyListeners();
                                      },
                                    ),
                                  ),
                                  txtfieldboundry(
                                    controller: vaTrue.myContactEditController,
                                    title: "Contact",
                                    security: false,
                                    keyboardSet:
                                        (vaTrue.selectedAction.toLowerCase() ==
                                                'call')
                                            ? TextInputType.number
                                            : TextInputType.emailAddress,
                                    maxlen: (vaTrue.selectedAction == 'Call')
                                        ? 10
                                        : 200,
                                    myregex: emailAndMobileRegex,
                                    hint: vaTrue.contactHintText,
                                    maxLines: 1,
                                    valid: true,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownSearch<String>(
                                      key: vaTrue.audienceKey,
                                      validator: (v) =>
                                          v == '' ? "required field" : null,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      mode: Mode.MENU,
                                      showSelectedItem: true,
                                      selectedItem: vaTrue.selectedAudience,
                                      maxHeight: (vaTrue
                                                  .notificationRequiredData
                                                  ?.data
                                                  ?.audience
                                                  ?.length ??
                                              0) *
                                          54.0,
                                      items: vaTrue.notificationRequiredData
                                          ?.data?.audience,
                                      label: "Audience",
                                      hint: "Please Select Audience",
                                      showSearchBox: false,
                                      onChanged: (value) {
                                        vaTrue.selectedAudience = value;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: DropdownSearch<String>(
                                      key: vaTrue.areaKey,
                                      validator: (v) =>
                                          v == '' ? "required field" : null,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      mode: Mode.MENU,
                                      showSelectedItem: true,
                                      maxHeight: 160,
                                      selectedItem: vaTrue.selectedArea,
                                      items: vaTrue
                                          .notificationRequiredData?.data?.area,
                                      label: "Area",
                                      hint: "Please Select Area",
                                      showSearchBox: false,
                                      onChanged: (value) =>
                                          vaTrue.selectArea(value),
                                    ),
                                  ),
                                  Visibility(
                                    visible: vaTrue.getCountryVisible(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownSearch<String>(
                                          key: vaTrue.countryKey,
                                          validator: (v) =>
                                              v == '' ? "required field" : null,
                                          autoValidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          mode: Mode.MENU,
                                          maxHeight: 100,
                                          showSelectedItem: true,
                                          selectedItem: vaTrue.selectedCountry,
                                          items: vaTrue.countryList,
                                          label: "Country",
                                          showSearchBox: false,
                                          onChanged: (value) =>
                                              vaTrue.selectedCountry = value),
                                    ),
                                  ),
                                  Visibility(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: DropdownSearch<StateModel>(
                                        key: vaTrue.stateKey,
                                        validator: (v) =>
                                            v == null ? "required field" : null,
                                        autoValidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        compareFn:
                                            (StateModel i, StateModel s) =>
                                                i.isEqual(s),
                                        mode: Mode.MENU,
                                        showSelectedItem: true,
                                        itemAsString: (StateModel u) =>
                                            u.userAsString(),
                                        selectedItem:
                                            (vaTrue.selectedState ?? "") ==
                                                    'null'
                                                ? ''
                                                : vaTrue.selectedState,
                                        items: vaTrue.notificationRequiredData
                                            ?.data?.stateList,
                                        label: "State",
                                        hint: "Please Select State",
                                        maxHeight: 170,
                                        showSearchBox: false,
                                        onChanged: (value) {
                                          vaTrue.selectedState = value;
                                        },
                                      ),
                                    ),
                                    visible: vaTrue.getStateVisible(),
                                  ),
                                  Visibility(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownSearch<CityModel>(
                                        key: vaTrue.cityKey,
                                        validator: (v) =>
                                            v == null ? "required field" : null,
                                        autoValidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        mode: Mode.MENU,
                                        showSelectedItem: true,
                                        compareFn: (CityModel i, CityModel s) =>
                                            i.isEqual(s),
                                        itemAsString: (CityModel u) =>
                                            u.userAsString(),
                                        selectedItem: vaTrue.selectedCity,
                                        items: vaTrue.cityListData,
                                        label: "City",
                                        maxHeight: 160,
                                        hint: "Please Select City",
                                        showSearchBox: false,
                                        onChanged: (value) {
                                          vaTrue.selectedCity = value;
                                        },
                                      ),
                                    ),
                                    visible: vaTrue.getCityVisible(),
                                  ),
                                  Visibility(
                                    visible: vaTrue.getPincodeVisible(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: txtfieldboundry(
                                        controller:
                                            vaTrue.myPincodeEditController,
                                        title: "Pincode",
                                        security: false,
                                        hint: 'Please enter pincode',
                                        maxLines: 1,
                                        error: vaTrue.errors[3],
                                        keyboardSet: TextInputType.number,
                                        valid: vaTrue.validatePincode,
                                        maxlen: 6,
                                        myOnChanged: (val) =>
                                            vaTrue.verifyPinCode(val),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownSearch<String>(
                                          key: vaTrue.quantityKey,
                                          validator: (v) =>
                                              v == '' ? "required field" : null,
                                          autoValidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          mode: Mode.MENU,
                                          maxHeight: 100,
                                          selectedItem: vaTrue.selectedQuantity,
                                          items: vaTrue.quantityList,
                                          label: "Quantity",
                                          hint: "Please Select Quantity",
                                          showSearchBox: false,
                                          onChanged: (value) {
                                            vaTrue.selectedQuantity = value;
                                          }))
                                ])))))),
            Visibility(
              visible: vaTrue.getShowDone(),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: sm.w(50),
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: RoundedButton(
                    clicker: () => vaTrue.submit(),
                    clr: Colors.red,
                    title: "Send",
                  ),
                ),
              ),
            ),
            SizedBox(height: 50)
          ])),
    );
  }
}
