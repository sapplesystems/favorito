import 'package:Favorito/Provider/SignUpProvider.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/signup/signup_b.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';

class Signup_a extends StatelessWidget {
  var signUpProviderTrue;
  var signUpProviderFalse;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    signUpProviderTrue = Provider.of<SignUpProvider>(context, listen: true);
    signUpProviderFalse = Provider.of<SignUpProvider>(context, listen: false);
    signUpProviderFalse.setContext(context);

    return WillPopScope(
      onWillPop: () => signUpProviderTrue.allClear(),
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: RefreshIndicator(
            onRefresh: () async {
              signUpProviderTrue.getBusiness();
            },
            child: ListView(
              children: [
                Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: "Gilroy-Bold",
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1),
                ),
                Container(
                  height: sm.w(160),
                  child: Stack(
                    children: [
                      Positioned(
                        top: sm.w(30),
                        left: sm.w(6),
                        right: sm.w(6),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 8,
                            shadowColor: Colors.grey.withOpacity(0.2),
                            child: Builder(
                              builder: (context) => Form(
                                key: _formKey,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: sm.h(12),
                                      bottom: sm.h(2),
                                      left: 16,
                                      right: 16),
                                  child: ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics:
                                          new NeverScrollableScrollPhysics(),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: DropdownSearch<String>(
                                            key: SignUpProvider.categoryKey1,
                                            mode: Mode.DIALOG,
                                            validator: (v) => (v == null)
                                                ? "Please Select Business Type"
                                                : null,
                                            showSearchBox: false,
                                            autoValidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxHeight: signUpProviderTrue
                                                    .getBusinessNameAll()
                                                    .length *
                                                58.0,
                                            // showSelectedItem: true,
                                            items: signUpProviderTrue
                                                .getBusinessNameAll(),
                                            label: "Business Type",
                                            hint: "Please Select Business Type",
                                            onChanged: (val) =>
                                                signUpProviderTrue
                                                    .businessIdByName(val),
                                            selectedItem: signUpProviderTrue
                                                .getBusinessName(),
                                          ),
                                        ),
                                        Consumer<SignUpProvider>(
                                            builder: (context, _data, child) {
                                          return Padding(
                                            padding: EdgeInsets.only(top: 2),
                                            child: txtfieldboundry(
                                                valid: true,
                                                inputTextSize: 16,
                                                controller: signUpProviderTrue
                                                    .controller[0],
                                                title: signUpProviderTrue
                                                            .getTypeId() ==
                                                        1
                                                    ? "Business Name"
                                                    : "Full Name",
                                                security: false),
                                          );
                                        }),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8, top: 2),
                                          child: Visibility(
                                              visible:
                                                  signUpProviderTrue.catvisib,
                                              child: DropdownSearch<String>(
                                                key: SignUpProvider.categoryKey,
                                                mode: Mode.MENU,
                                                maxHeight: sm.h(28),
                                                validator: (v) => (v == '')
                                                    ? "Required field"
                                                    : null,
                                                autoValidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                showSelectedItem: false,
                                                showSearchBox: false,
                                                items: signUpProviderTrue
                                                    .getCategoryAll(),
                                                label: "Business Category",
                                                hint:
                                                    "Please Select Business Category",
                                                onChanged: (val) =>
                                                    signUpProviderTrue
                                                        .setCategoryIdByName(
                                                            val),
                                                selectedItem: signUpProviderTrue
                                                    .getCategoryName(),
                                              )),
                                        ),
                                        txtfieldboundry(
                                          controller:
                                              signUpProviderTrue.controller[1],
                                          valid: true,
                                          inputTextSize: 16,
                                          maxlen: 6,
                                          error: signUpProviderTrue.error[1],
                                          keyboardSet: TextInputType.number,
                                          title: "Postal Code",
                                          security: false,
                                          myOnChanged: (_v) {
                                            _v.length == 6
                                                ? signUpProviderTrue
                                                    .pinCaller(_v)
                                                // ignore: unnecessary_statements
                                                : null;
                                          },
                                        ),
                                        txtfieldboundry(
                                            controller: signUpProviderTrue
                                                .controller[2],
                                            valid: true,
                                            inputTextSize: 16,
                                            title: signUpProviderTrue.catvisib
                                                ? "Business Phone"
                                                : "Phone",
                                            maxlen: 10,
                                            keyboardSet: TextInputType.number,
                                            myregex: mobileRegex,
                                            security: false),
                                        CheckboxListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text(
                                            "Reach me on whatsapp",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.32,
                                            ),
                                          ),
                                          value:
                                              signUpProviderTrue.getChecked(),
                                          onChanged: (newValue) {
                                            signUpProviderTrue
                                                .setChecked(newValue);
                                          },
                                          controlAffinity: ListTileControlAffinity
                                              .leading, //  <-- leading Checkbox
                                        ),
                                      ]),
                                ),
                              ),
                            )),
                      ),
                      Positioned(
                          top: sm.h(2),
                          left: sm.w(30),
                          right: sm.w(30),
                          child: SvgPicture.asset('assets/icon/maskgroup.svg',
                              alignment: Alignment.center, height: sm.h(20))),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: sm.w(20),
                      right: sm.w(20),
                      top: sm.w(2),
                      bottom: sm.w(12)),
                  child: RoundedButton(
                      clicker: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => signup_b()));
                        }
                      },
                      clr: Colors.red,
                      title: "Next"),
                ),
              ],
            )),
      ),
    );
  }
}
