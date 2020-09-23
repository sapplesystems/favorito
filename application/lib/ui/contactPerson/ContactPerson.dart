import 'package:Favorito/component/BranchDetailsListVIewAdd.dart';
import 'package:Favorito/component/BranchDetailsListViewDelete.dart';
import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/contactPerson/BranchDetailsModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class ContactPerson extends StatefulWidget {
  @override
  _ContactPersonState createState() => _ContactPersonState();
}

class _ContactPersonState extends State<ContactPerson> {
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
  List<String> _roleList = ['Manager', 'Employee'];
  List<BranchDetailsModel> _searchedBranches = [];
  List<BranchDetailsModel> _selectedBranches = [];

  bool _autoValidateForm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffff4f4),
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
        body: 
        
        
        Container(
            decoration: BoxDecoration(
              color: Color(0xfffff4f4),
            ),
            child: ListView(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                  child: Stack(
                    children: [
                      Card(
                        margin:
                            EdgeInsets.only(top: context.percentHeight * 10),
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
                                      top: context.percentHeight * 12,
                                      left: 32.0,
                                      right: 32.0),
                                  child: Text(
                                    "Mr. Johny Vinno",
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: context.percentHeight * 2,
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
                                          "hello.johny@gmail.com",
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    ctrl: _myFirstNameEditController,
                                    title: "First Name",
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    ctrl: _myLastNameEditController,
                                    title: "Last Name",
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    ctrl: _myPersonalEmailEditController,
                                    title: "Personal Email",
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    ctrl: _myPersonalMobileEditController,
                                    title: "Personal Mobile",
                                    security: false,
                                    valid: true,
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
                                        left: context.percentWidth * 10,
                                        right: context.percentWidth * 10),
                                    child: SvgPicture.asset(
                                        'assets/icon/changePassword.svg',
                                        alignment: Alignment.center,
                                        height: context.percentHeight * 20,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: context.percentWidth * 5,
                          left: context.percentWidth * 30,
                          right: context.percentWidth * 30,
                          child: SvgPicture.asset(
                              'assets/icon/contactPerson.svg',
                              alignment: Alignment.center,
                              height: context.percentHeight * 20)),
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
                                    ctrl: _myNameEditController,
                                    title: "Name",
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: txtfieldboundry(
                                  ctrl: _myAccountNoEditController,
                                  title: "A/C Number",
                                  security: false,
                                  valid: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: txtfieldboundry(
                                  ctrl: _myIFSCEditController,
                                  title: "IFSC code",
                                  security: false,
                                  valid: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: txtfieldboundry(
                                  ctrl: _myUPIEditController,
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
                                        showPopup(context, _popupBody(),
                                            'Select Branch');
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
                    width: context.percentWidth * 50,
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: roundedButton(
                      clicker: () {},
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
        top: context.percentHeight * 20,
        left: context.percentWidth * 10,
        right: context.percentWidth * 10,
        bottom: context.percentHeight * 20,
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
    BranchDetailsModel model1 = BranchDetailsModel();
    model1.id = "1";
    model1.name = "name";
    model1.address = "address address address";
    model1.imageUrl = "https://source.unsplash.com/random/400*400";
    model1.isSelected = false;
    _searchedBranches.add(model1);

    BranchDetailsModel model2 = BranchDetailsModel();
    model2.id = "1";
    model2.name = "name";
    model2.address = "address address address";
    model2.imageUrl = "https://source.unsplash.com/random/400*400";
    model2.isSelected = false;
    _searchedBranches.add(model2);

    _selectedBranches.add(model1);
    _selectedBranches.add(model1);
    _selectedBranches.add(model1);
    _selectedBranches.add(model1);
    _selectedBranches.add(model1);
    _selectedBranches.add(model1);
    return Container(
      child: BranchDetailsListViewAdd(
          inputList: _searchedBranches, selectedList: _selectedBranches),
    );
  }
}
