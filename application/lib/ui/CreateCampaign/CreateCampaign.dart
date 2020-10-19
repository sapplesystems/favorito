import 'package:Favorito/component/MyRadioGroup.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/businessInfoModel.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/services.dart';

class CreateCampaign extends StatefulWidget {
  @override
  _CreateCampaignState createState() => _CreateCampaignState();
}

class _CreateCampaignState extends State<CreateCampaign> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TextEditingController> ctrl = List();
  List<String> keywordList = [];

  String _selectedRole;
  List<String> _totalCpc = [];
  String _selecteCpc = "";
  bool _autovalidate = false;

  List<TagList> totalTag = [];
  List<String> totalTagName = [];
  List<String> selectedTagName = [];
  List<int> selectedTagId = [];

  Map<String, bool> statusData = {
    "Active": true,
    "Pause": false,
    "Stop": false
  };
  @override
  void initState() {
    getTags();
    funCpc();
    super.initState();
    for (int i = 0; i < 4; i++) ctrl.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myBackGround,
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
          "Create Campaign",
          style: barTitleStyle,
        ),
      ),
      body: Container(
        color: myBackGround,
        padding: EdgeInsets.symmetric(horizontal: sm.scaledWidth(4)),
        margin: EdgeInsets.only(
          top: sm.scaledHeight(2),
        ),
        child: ListView(
          children: [
            Card(
              elevation: 10,
              shape: rrb,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Builder(
                    builder: (context) => Form(
                        key: _formKey,
                        autovalidate: _autovalidate,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              txtfieldboundry(
                                controller: ctrl[0],
                                hint: "Enter campaign name",
                                title: "Campaign Name",
                                maxLines: 1,
                                valid: true,
                                security: false,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: MyTags(
                                  selectedList: selectedTagName,
                                  border: true,
                                  directionVeticle: false,
                                  sourceList: totalTagName,
                                  hint: "KeyWords",
                                  title: "KeyWords",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: DropdownSearch<String>(
                                  validator: (v) =>
                                      v == '' ? "required field" : null,
                                  autoValidate: true,
                                  mode: Mode.MENU,
                                  selectedItem: _selectedRole,
                                  items: _totalCpc,
                                  label: "Cost per click",
                                  hint: "",
                                  showSearchBox: true,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRole = value;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 14, bottom: 14),
                                child: txtfieldboundry(
                                  controller: ctrl[3],
                                  hint: "Enter Total Budget",
                                  title: "Total Budget",
                                  maxLines: 1,
                                  keyboardSet: TextInputType.number,
                                  valid: true,
                                  security: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Status",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: MyRadioGroup(dataList: statusData),
                              )
                            ]))),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sm.scaledWidth(16),
                    vertical: sm.scaledHeight(4)),
                child: roundedButton(
                    clicker: () {
                      // funSublim();
                    },
                    clr: Colors.red,
                    title: "Run Ad"))
          ],
        ),
      ),
    );
  }

  void getTags() {
    WebService.getTagList().then((value) {
      if (value.status == "success") {
        totalTag.addAll(value.data);
        List<String> temp = [];
        for (int i = 0; i < totalTag.length; i++) {
          temp.add(value.data[i].tagName);
        }
        setState(() {
          totalTagName.addAll(temp);
        });
      }
    });
  }

  void funCpc() {
    WebService.getCampainVerbose().then((value) {
      if (value.status == "success") {
        List<String> _temp = [];
        for (int i = 0; i < value.data.cpc.length; i++) {
          _temp.add(value.data.cpc[i].toString());
        }
        print("_temp:${_temp.toString()}");
        setState(() => _totalCpc = _temp);
      }
    });
  }
}
