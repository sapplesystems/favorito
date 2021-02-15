import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/showPopup.dart';
import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/ui/ResetPass/ResetPass.dart';
import 'package:Favorito/ui/ResetPass/ResetPassProvider.dart';
import 'package:Favorito/ui/contactPerson/ContactPersonProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:Favorito/component/BranchDetailsListVIewAdd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:provider/provider.dart';

class ContactPerson extends StatelessWidget {
  SizeManager sm;
  bool _autoValidateForm = false;

  ContactPersonProvider cpTrue;
  ContactPersonProvider cpFalse;
  @override
  Widget build(BuildContext context) {
    cpTrue = Provider.of<ContactPersonProvider>(context, listen: true);
    cpFalse = Provider.of<ContactPersonProvider>(context, listen: false);

    sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Contact Person",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            cpFalse.initializeDefaultValues();
          },
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                child: Stack(
                  children: [
                    Card(
                      margin: EdgeInsets.only(top: sm.h(10)),
                      child: Builder(
                        builder: (context) => Form(
                          key: cpFalse.form1Key,
                          autovalidate: _autoValidateForm,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: sm.h(12), left: 32.0, right: 32.0),
                                child: Text(
                                  // cpTrue.displayName,
                                  cpFalse.controller[0].text,
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: sm.w(2), vertical: sm.h(1)),
                                child: Wrap(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Email : ",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      Text(
                                        // cpTrue.displayEmail,
                                        cpTrue.controller[2].text,
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ]),
                              ),
                              for (int i = 0; i < 4; i++)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: cpFalse.controller[i],
                                    title: cpFalse.titles[i],
                                    keyboardSet: i == 3
                                        ? TextInputType.number
                                        : TextInputType.text,
                                    maxlen: i == 3 ? 10 : 50,
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: sm.w(7),
                                    right: sm.w(7),
                                    top: sm.h(4)),
                                child: DropdownSearch<String>(
                                  key: cpFalse.roleKey,
                                  validator: (v) =>
                                      v == '' ? "required field" : null,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  mode: Mode.MENU,
                                  selectedItem: cpFalse.selectedRole,
                                  items: cpFalse.roleList,
                                  label: "Role",
                                  hint: "Please Select Role",
                                  showSearchBox: false,
                                  onChanged: (value) {
                                    cpFalse.selectedRole = value;
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showPopup(
                                    ctx: context,
                                    callback: () {
                                      Provider.of<ResetPassProvider>(context,
                                              listen: false)
                                          .clear();
                                    },
                                    sm: sm,
                                    widget: ResetPass(),
                                    sizesRight: 3,
                                    sizesTop: 10,
                                    sizesLeft: 3,
                                    sizesBottom: 36,
                                  ).show();
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: sm.w(12)),
                                  child: SvgPicture.asset(
                                      'assets/icon/changePassword.svg',
                                      alignment: Alignment.center,
                                      height: sm.h(20),
                                      fit: BoxFit.contain),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: sm.w(5),
                        left: sm.w(30),
                        right: sm.w(30),
                        child: SvgPicture.asset('assets/icon/contactPerson.svg',
                            alignment: Alignment.center, height: sm.h(20))),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                child: Card(
                    child: Builder(
                  builder: (context) => Form(
                    key: cpFalse.form2Key,
                    autovalidate: _autoValidateForm,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Bank Details",
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        for (int i = 4; i < cpFalse.titles.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: txtfieldboundry(
                              controller: cpFalse.controller[i],
                              title: cpFalse.titles[i],
                              security: false,
                              valid: true,
                              keyboardSet: i == 5
                                  ? TextInputType.number
                                  : TextInputType.text,
                            ),
                          )
                      ],
                    ),
                  ),
                )),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
              //   child: Card(
              //       child: Builder(
              //     builder: (context) => Form(
              //       key: cpTrue.form3Key,
              //       autovalidateMode: AutovalidateMode.onUserInteraction,
              //       child: Column(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.all(16.0),
              //             child: Text(
              //               "Branch Details",
              //               style: TextStyle(
              //                   fontSize: 24.0, fontWeight: FontWeight.bold),
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.all(16.0),
              //             child: TextFormField(
              //               controller: cpFalse.controller[9],
              //               decoration: InputDecoration(
              //                 labelText: "Search Branch",
              //                 suffixIcon: IconButton(
              //                   icon: Icon(Icons.search),
              //                   onPressed: () {
              //                     WebService.funSearchBranches(
              //                             cpFalse.controller[9].text, context)
              //                         .then((value) {
              //                       for (var branch in value.data) {
              //                         BranchDetailsModel model1 =
              //                             BranchDetailsModel();
              //                         model1.id = branch.id.toString();
              //                         model1.name = branch.businessName;
              //                         model1.address = branch.buisnessAddress;
              //                         model1.imageUrl = branch.photo == null
              //                             ? ''
              //                             : branch.photo;
              //                         model1.isSelected = false;
              //                         cpTrue.searchedBranches.add(model1);
              //                       }
              //                       showPopup(
              //                           context, _popupBody(), 'Select Branch');
              //                     });
              //                   },
              //                 ),
              //               ),
              //             ),
              //           ),
              //           Visibility(
              //             visible: cpTrue.selectedBranches.length > 0,
              //             child: BranchDetailsListViewDelete(
              //                 inputList: cpTrue.selectedBranches),
              //           )
              //         ],
              //       ),
              //     ),
              //   )),
              // ),

              Align(
                alignment: Alignment.center,
                child: Container(
                  width: sm.w(50),
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: RoundedButton(
                    clicker: () => cpFalse.submitData(),
                    clr: Colors.red,
                    title: "Submit",
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // showPopup(BuildContext context, Widget widget, String title,
  //     {BuildContext popupContext}) {
  //   Navigator.push(
  //     context,
  //     PopupLayout(
  //       top: sm.h(18),
  //       left: sm.w(5),
  //       right: sm.w(5),
  //       bottom: sm.h(18),
  //       child: PopupContent(
  //         content: Scaffold(
  //           appBar: AppBar(
  //             title: Text(title),
  //             leading: new Builder(builder: (context) {
  //               return IconButton(
  //                 icon: Icon(Icons.arrow_back),
  //                 onPressed: () {
  //                   cpFalse.searchedBranches.clear();
  //                   Navigator.of(context).pop(); //close the popup
  //                 },
  //               );
  //             }),
  //             brightness: Brightness.light,
  //           ),
  //           resizeToAvoidBottomPadding: false,
  //           body: widget,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _popupBody() {
    return Container(
      child: BranchDetailsListViewAdd(
          inputList: cpFalse.searchedBranches,
          selectedList: cpFalse.selectedBranches),
    );
  }
}
