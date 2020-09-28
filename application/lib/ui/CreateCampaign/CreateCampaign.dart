import 'package:Favorito/component/MyRadioGroup.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class CreateCampaign extends StatefulWidget {
  @override
  _CreateCampaignState createState() => _CreateCampaignState();
}

class _CreateCampaignState extends State<CreateCampaign> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TextEditingController> ctrl = List();
  List<String> keywordList = [];
  List<String> keyList = ["a", "b", "c"];
  List<String> selectedKeyList = [];
  String _selectedRole;
  List<String> _roleList = ["a1", "b1", "c1"];
  Map<String, bool> statusData = {
    "Active": true,
    "Pause": false,
    "Stop": false
  };
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) ctrl.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: Color(0xfffff4f4),
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
          "Create Campaign",
          style: barTitleStyle,
        ),
      ),
      body: Container(
        color: Color(0xfffff4f4),
        height: sm.scaledHeight(82),
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              txtfieldboundry(
                                ctrl: ctrl[0],
                                hint: "Enter campaign name",
                                title: "Campaign Name",
                                maxLines: 1,
                                valid: true,
                                security: false,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 14),
                                child: MyTags(
                                  controller: ctrl[1],
                                  selectedList: selectedKeyList,
                                  sourceList: keyList,
                                  hint: "KeyWords",
                                  title: "KeyWords",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: DropdownSearch<String>(
                                  validator: (v) =>
                                      v == '' ? "required field" : null,
                                  autoValidate: true,
                                  mode: Mode.MENU,
                                  selectedItem: _selectedRole,
                                  items: _roleList,
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
                                  ctrl: ctrl[3],
                                  hint: "Enter Total Budget",
                                  title: "Total Budget",
                                  maxLines: 1,
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
}
