import 'package:Favorito/component/BranchDetailsListVIewAdd.dart';
import 'package:Favorito/component/BranchDetailsListViewDelete.dart';
import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/contactPerson/BranchDetailsModel.dart';
import 'package:Favorito/model/contactPerson/ContactPersonRequiredDataModel.dart';
import 'package:Favorito/model/contactPerson/UpdateContactPerson.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';
class ContactPerson extends StatefulWidget {
  @override
  _ContactPersonState createState() => _ContactPersonState();
}

class _ContactPersonState extends State<ContactPerson> {
  SizeManager sm;
  String displayName = '';
  String displayEmail = '';
  var _myFirstNameEditController = TextEditingController();
  var _myLastNameEditController = TextEditingController();
  var _myPersonalEmailEditController = TextEditingController();
  var _myPersonalMobileEditController = TextEditingController();
  var _myNameEditController = TextEditingController();
  var _myAccountNoEditController = TextEditingController();
  var _myIFSCEditController = TextEditingController();
  var _myUPIEditController = TextEditingController();
  var _myBranchSearchEditController = TextEditingController();
  final GlobalKey<FormState> _form1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> _form2Key = GlobalKey<FormState>();
  final GlobalKey<FormState> _form3Key = GlobalKey<FormState>();

  String _selectedRole = '';
  List<String> _roleList = [];
  List<BranchDetailsModel> _searchedBranches = [];
  List<BranchDetailsModel> _selectedBranches = [];

  ContactPersonRequiredDataModel _contactPersonData;

  @override
  void initState() {
    initializeDefaultValues();
    super.initState();
  }

  void initializeDefaultValues() {
    WebService.funContactPersonRequiredData().then((value) {
      setState(() {
        _contactPersonData = value;
        displayName = _contactPersonData.data.firstName +
            ' ' +
            _contactPersonData.data.lastName;
        displayEmail = _contactPersonData.data.email;
        _myFirstNameEditController.text = _contactPersonData.data.firstName;
        _myLastNameEditController.text = _contactPersonData.data.lastName;
        _myPersonalEmailEditController.text = _contactPersonData.data.email;
        _myPersonalMobileEditController.text = _contactPersonData.data.phone;
        _selectedRole = _contactPersonData.data.role;

        _myNameEditController.text = _contactPersonData.data.bankAcHolderName;
        _myAccountNoEditController.text = _contactPersonData.data.accountNumber;
        _myIFSCEditController.text = _contactPersonData.data.ifscCode;
        _myUPIEditController.text = _contactPersonData.data.upi;

        _selectedBranches.clear();
        for (var branch in _contactPersonData.data.branches) {
          BranchDetailsModel model = new BranchDetailsModel();
          model.id = branch.id.toString();
          model.name = branch.branchName;
          model.address = branch.branchAddress;
          model.isSelected = true;
          model.imageUrl = branch.branchPhoto;
          _selectedBranches.add(model);
        }

        for (var role in _contactPersonData.userRole) {
          _roleList.add(role);
        }
      });
    });
  }

  bool _autoValidateForm = false;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: myBackGround,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Contact Person",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: myBackGround,
            ),
            child: ListView(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                  child: Stack(
                    children: [
                      Card(
                        margin: EdgeInsets.only(top: sm.scaledHeight(10)),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Builder(
                          builder: (context) => Form(
                            key: _form1Key,
                            autovalidate: _autoValidateForm,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: sm.scaledHeight(12),
                                      left: 32.0,
                                      right: 32.0),
                                  child: Text(
                                    displayName,
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: sm.scaledHeight(2),
                                      left: 8.0,
                                      right: 8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Email : ",
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                        Text(
                                          displayEmail,
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: _myFirstNameEditController,
                                    title: "First Name",
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: _myLastNameEditController,
                                    title: "Last Name",
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: _myPersonalEmailEditController,
                                    title: "Personal Email",
                                    security: false,
                                    valid: true,
                                    isEnabled: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: _myPersonalMobileEditController,
                                    title: "Personal Mobile",
                                    security: false,
                                    valid: true,
                                    isEnabled: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0, top: 16.0),
                                  child: DropdownSearch<String>(
                                    validator: (v) =>
                                        v == '' ? "required field" : null,
                                    autoValidate: _autoValidateForm,
                                    mode: Mode.MENU,
                                    selectedItem: _selectedRole,
                                    items: _roleList,
                                    label: "Role",
                                    hint: "Please Select Role",
                                    showSearchBox: false,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedRole = value;
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: sm.scaledWidth(10),
                                        right: sm.scaledWidth(10)),
                                    child: SvgPicture.asset(
                                        'assets/icon/changePassword.svg',
                                        alignment: Alignment.center,
                                        height: sm.scaledHeight(20),
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: sm.scaledWidth(5),
                          left: sm.scaledWidth(30),
                          right: sm.scaledWidth(30),
                          child: SvgPicture.asset(
                              'assets/icon/contactPerson.svg',
                              alignment: Alignment.center,
                              height: sm.scaledHeight(20))),
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                  child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Builder(
                        builder: (context) => Form(
                          key: _form2Key,
                          autovalidate: _autoValidateForm,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Bank Details",
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: txtfieldboundry(
                                    controller: _myNameEditController,
                                    title: "Name",
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: txtfieldboundry(
                                  controller: _myAccountNoEditController,
                                  title: "A/C Number",
                                  security: false,
                                  valid: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: txtfieldboundry(
                                  controller: _myIFSCEditController,
                                  title: "IFSC code",
                                  security: false,
                                  valid: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: txtfieldboundry(
                                  controller: _myUPIEditController,
                                  title: "UPI",
                                  security: false,
                                  valid: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                  child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Builder(
                        builder: (context) => Form(
                          key: _form3Key,
                          autovalidate: _autoValidateForm,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Branch Details",
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextFormField(
                                  controller: _myBranchSearchEditController,
                                  decoration: InputDecoration(
                                    labelText: "Search Branch",
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        WebService.funSearchBranches(
                                                _myBranchSearchEditController
                                                    .text)
                                            .then((value) {
                                          for (var branch in value.data) {
                                            BranchDetailsModel model1 =
                                                BranchDetailsModel();
                                            model1.id = branch.id.toString();
                                            model1.name = branch.businessName;
                                            model1.address =
                                                branch.buisnessAddress;
                                            model1.imageUrl =
                                                branch.photo == null
                                                    ? ''
                                                    : branch.photo;
                                            model1.isSelected = false;
                                            _searchedBranches.add(model1);
                                          }
                                          showPopup(context, _popupBody(),
                                              'Select Branch');
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _selectedBranches.length > 0,
                                child: BranchDetailsListViewDelete(
                                    inputList: _selectedBranches),
                              )
                            ],
                          ),
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: sm.scaledWidth(50),
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: roundedButton(
                      clicker: () {
                        if (_form1Key.currentState.validate() &&
                            _form2Key.currentState.validate()) {
                          UpdateContactPerson request = UpdateContactPerson();
                          request.firtName = _myFirstNameEditController.text;
                          request.lastName = _myLastNameEditController.text;
                          request.role = _selectedRole;
                          request.name = _myNameEditController.text;
                          request.accNo = _myAccountNoEditController.text;
                          request.ifsc = _myIFSCEditController.text;
                          request.upi = _myUPIEditController.text;
                          WebService.funUpdateContactPerson(
                                  request, _selectedBranches)
                              .then((value) {
                            if (value.status == 'success') {
                              BotToast.showText(text: value.message);
                              setState(() {
                                initializeDefaultValues();
                              });
                            } else {
                              BotToast.showText(text: value.message);
                            }
                          });
                        }
                      },
                      clr: Colors.red,
                      title: "Submit",
                    ),
                  ),
                ),
              ],
            )));
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: sm.scaledHeight(18),
        left: sm.scaledWidth(5),
        right: sm.scaledWidth(5),
        bottom: sm.scaledHeight(18),
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _searchedBranches.clear();
                    Navigator.of(context).pop(); //close the popup
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupBody() {
    return Container(
      child: BranchDetailsListViewAdd(
          inputList: _searchedBranches, selectedList: _selectedBranches),
    );
  }
}
