import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/component/SingleSelectionChips.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/user/PersonalInfo/UserAddressProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatelessWidget {
  UserAddressProvider vaTrue;
  UserAddressProvider vaFalse;
  bool isFirst = true;
  SizeManager sm;
  GlobalKey<FormState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    vaTrue = Provider.of<UserAddressProvider>(context, listen: true);
    vaFalse = Provider.of<UserAddressProvider>(context, listen: false);
    sm = SizeManager(context);
    if (isFirst) {
      vaTrue
        // ..showPlacePicker(context)
        ..allClear();
      isFirst = false;
    }
    print("address page create");
    return Scaffold(
        key: RIKeys.josKeys6,
        backgroundColor: myBackGround,
        appBar: AppBar(
            title: Text('${vaTrue.mode} Address',
                style: TextStyle(
                    fontFamily: 'Gilroy-Reguler',
                    fontWeight: FontWeight.w600,
                    letterSpacing: .4,
                    fontSize: 20)),
            elevation: 0,
            backgroundColor: myBackGround),
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: InkWell(
                onTap: () {
                  vaTrue.showPlacePicker(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.my_location, color: myRed),
                    Text('\t\t\tClick here to pick location',
                        style: TextStyle(
                            color: myRed, fontFamily: 'Gilroy-Regular')),
                  ],
                ),
              ),
            ),
            for (int i = 0; i < vaTrue.title.length; i++)
              EditTextComponent(
                  controller: vaTrue.acces[i].controller,
                  title: vaTrue.title[i],
                  hint: vaTrue.title[i],
                  myOnChanged: (_val) {
                    if (i == 2 && _val.length == 6) {
                      vaTrue.checkPin();
                    } else if (_val.length == 5) {
                      vaTrue.acces[3].controller.text = '';
                      vaTrue.acces[4].controller.text = '';
                      vaTrue.notifyListeners();
                    }
                  },
                  suffixTap: () => vaTrue.checkIdClicked(i),
                  suffixTxt: '',
                  error: vaTrue.acces[i].error,
                  security: false,
                  valid: true,
                  maxLines: i == 0 ? 4 : 1,
                  isEnabled: (i != 3 && i != 4),
                  formate: FilteringTextInputFormatter.singleLineFormatter,
                  maxlen: i == 2 ? 6 : 70,
                  keyboardSet:
                      i == 2 ? TextInputType.phone : TextInputType.text,
                  prefixIcon: vaTrue.prefix[i]),
            SingleSelectionChips(
              reportList: vaTrue.fList,
              selectedChoice: vaTrue.getAddresstype(),
              selection: (va) {
                vaTrue.setAddresstype(va);
              },
            ),
            Padding(
                padding: EdgeInsets.only(top: sm.h(5)),
                child: NeumorphicButton(
                    style: NeumorphicStyle(
                        // depth: 11,
                        intensity: 40,
                        surfaceIntensity: -.4,
                        color: myButtonBackground,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.all(Radius.circular(24.0)))),
                    margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
                    onPressed: () => vaTrue.SubmitAddress(),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Center(
                        child: Text(vaTrue.mode == 'Add' ? 'Submit' : 'Update',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Gilroy-Light',
                                color: myRed))))),
          ]),
        ));
  }
}

// Container(
// height: 500,
// child: Column(children: [
// for (int i = 0; i < vaFalse.title.length; i++)
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 4.0),
// child: EditTextComponent(
// controller: vaFalse.acces[i].controller,
// title: vaFalse.title[i],
// hint: vaFalse.title[i],
// myOnChanged: (_) {
// // spFalse.onChange(i)
// },
// suffixTap: () => vaFalse.checkIdClicked(i),
// suffixTxt: '',
// error: vaFalse.acces[i].error,
// security: false,
// valid: true,
// maxLines: 1,
// formate:
// FilteringTextInputFormatter.singleLineFormatter,
// maxlen: 50,
// keyboardSet:
// i == 1 ? TextInputType.phone : TextInputType.text,
// prefixIcon: vaFalse.prefix[i],
// ),
// ),
// Padding(
// padding: EdgeInsets.only(top: sm.h(5)),
// child: NeumorphicButton(
// style: NeumorphicStyle(
// // shape: NeumorphicShape.concave,
// depth: 11,
// intensity: 40,
// surfaceIntensity: -.4,
// // lightSource: LightSource.topLeft,
// color: Color(0xffedf0f5),
// boxShape: NeumorphicBoxShape.roundRect(
// BorderRadius.all(Radius.circular(24.0)))),
// margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
// onPressed: () {
// // if (_formKey.currentState.validate()) {
// //
// //
// // }
// },
// padding: EdgeInsets.symmetric(
// horizontal: 16, vertical: 16),
// child: Center(
// child: Text("Submit",
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.w500,
// fontFamily: 'Gilroy-Light',
// color: myRed))))),
// ])),
//
