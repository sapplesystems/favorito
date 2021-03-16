import 'package:Favorito/model/contactPerson/BranchDetailsModel.dart';
import 'package:Favorito/model/contactPerson/ContactPersonRequiredDataModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactPersonProvider extends ChangeNotifier {
  BuildContext context;
  // String displayName = '';
  // String displayEmail = '';

  List<TextEditingController> controller = [];
  final GlobalKey<FormState> form1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> form2Key = GlobalKey<FormState>();
  final GlobalKey<FormState> form3Key = GlobalKey<FormState>();
  final roleKey = GlobalKey<DropdownSearchState<String>>();

  String selectedRole = '';
  List<String> roleList = [];
  List<BranchDetailsModel> searchedBranches = [];
  List<BranchDetailsModel> selectedBranches = [];
  List<String> titles = [
    'First Name',
    'Last Name',
    'Personal Email',
    'Personal Mobile',
    'Name',
    'A/C Number',
    'IFSC code',
    'UPI'
  ];

  ContactPersonRequiredDataModel _contactPersonData;

  ContactPersonProvider() {
    initializeDefaultValues();
    for (int i = 0; i < 10; i++) controller.add(TextEditingController());
  }
  void initializeDefaultValues() async {
    // if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
    await WebService.funContactPersonRequiredData(context).then((value) {
      _contactPersonData = value;
      print("value:${value.data.toString()}");
      // displayName = _contactPersonData.data.firstName ??
      //     '' + ' ' + _contactPersonData.data.lastName ??
      //     '';
      // displayEmail = _contactPersonData.data.email ?? '';
      controller[0].text = _contactPersonData.data.firstName ?? '';
      controller[1].text = _contactPersonData.data.lastName ?? '';
      controller[2].text = _contactPersonData.data.email ?? '';
      controller[3].text = _contactPersonData.data.phone ?? '';

      controller[4].text = _contactPersonData.data.bankAcHolderName ?? '';
      controller[5].text = _contactPersonData.data.accountNumber ?? '';
      controller[6].text = _contactPersonData.data.ifscCode ?? '';
      controller[7].text = _contactPersonData.data.upi ?? '';
      selectedBranches.clear();
      for (var branch in _contactPersonData.data.branches) {
        BranchDetailsModel model = new BranchDetailsModel();
        model.id = branch.id.toString();
        model.name = branch.branchName;
        model.address = branch.branchAddress;
        model.isSelected = true;
        model.imageUrl = branch.branchPhoto;
        selectedBranches.add(model);
      }
      for (var role in _contactPersonData.userRole) roleList.add(role);

      roleKey.currentState.changeSelectedItem(_contactPersonData.data.role);
    });
    notifyListeners();
  }

  Future<void> submitData() async {
    if (form1Key.currentState.validate() && form2Key.currentState.validate()) {
      // UpdateContactPerson requestData,
      // List<BranchDetailsModel> branchList

      Map<String, dynamic> _map = {
        "first_name": controller[0].text,
        "last_name": controller[1].text,
        // "email": requestData.role,
        // "mobile": requestData.role,
        "role": selectedRole,
        "bank_ac_holder_name": controller[4].text,
        "account_number": controller[5].text,
        "ifsc_code": controller[6].text,
        "upi": controller[7].text
      };
//  cpTrue.selectedBranches
      if (await Provider.of<UtilProvider>(context, listen: false)
          .checkInternet())
        await WebService.funUpdateContactPerson(_map).then((value) {
          if (value.status == 'success') {
            BotToast.showText(text: value.message);
            initializeDefaultValues();
            notifyListeners();
          } else {
            BotToast.showText(text: value.message);
          }
        });
    }
  }
}
