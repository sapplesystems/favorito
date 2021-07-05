import 'package:Favorito/component/MyRadioGroup.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/TagList.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/services.dart';
import '../../model/adSpentModel.dart';

class CreateCampaign extends StatefulWidget {
  bool campStat;

  Data data;
  CreateCampaign(campStat, data) {
    this.campStat = campStat;
    this.data = data;
  }
  @override
  _CreateCampaignState createState() => _CreateCampaignState();
}

class _CreateCampaignState extends State<CreateCampaign> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TextEditingController> ctrl = List();

  final _cpcKey = GlobalKey<DropdownSearchState<String>>();
  List<String> _totalCpc = [];
  var _selecteCpc;
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
    for (int i = 0; i < 2; i++) ctrl.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
        iconTheme: IconThemeData(color: Colors.black //change your color here
            ),
        title: Text(
          !widget.campStat?"Create Campaign":"Edit Campaign",
          style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontFamily: 'Gilroy-Bold',
              letterSpacing: .2),
        ),
      ),
      body: Container(
        color: myBackGround,
        padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
        margin: EdgeInsets.only(
          top: sm.h(2),
        ),
        child: ListView(
          children: [
            Card(
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
                                  refresh: () {
                                    setState(() {});
                                  },
                                  directionVeticle: false,
                                  sourceList: totalTagName,
                                  hint: "Keywords",
                                  title: "Keywords",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: DropdownSearch<String>(
                                  key: _cpcKey,
                                  validator: (_v) => (_v != "" && _v != null)
                                      ? null
                                      : 'required field',
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  mode: Mode.MENU,
                                  selectedItem: _selecteCpc,
                                  items: _totalCpc,
                                  label: "Cost per click",
                                  showSearchBox: false,
                                  onChanged: (value) {
                                    setState(() {
                                      _selecteCpc = value != null ? value : "";
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 14, bottom: 14),
                                child: txtfieldboundry(
                                  controller: ctrl[1],
                                  hint: "Enter Total Budget",
                                  title: "Total Budget",
                                  maxLines: 1,
                                  keyboardSet: TextInputType.number,
                                  valid: true,
                                  security: false,
                                ),
                              ),
                              Visibility(
                                visible: widget.campStat,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Status",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: widget.campStat,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: MyRadioGroup(dataList: statusData),
                                ),
                              )
                            ]))),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sm.w(16), vertical: sm.h(4)),
                child: RoundedButton(
                    clicker: () => funSublim(),
                    clr: Colors.red,
                    title: "Run Ad"))
          ],
        ),
      ),
    );
  }

  void getTags() async {
    await WebService.getTagList(context).then((value) {
      if (value.status == "success") {
        totalTag.addAll(value.data);

        List<String> temp = [];
        for (int i = 0; i < totalTag.length; i++) {
          temp.add(totalTag[i].tagName);
        }
        setState(() {
          totalTagName.addAll(temp);
        });
        if (widget.campStat) {
          ctrl[0].text = widget.data.name;
          ctrl[1].text = widget.data.totalBudget.toString();
          
          for (int i = 0; i < statusData.keys.toList().length; i++)
            statusData[(statusData.keys.toList())[i]] = false;
            statusData[widget.data.status] = true;
            print("aa${widget.data.status}");
          
          _cpcKey.currentState.changeSelectedItem(widget.data.cpc.toString());

          for (int j = 0; j < widget.data.keyword.length; j++) {
            for (int i = 0; i < totalTag.length; i++) {
              if (widget.data.keyword[j].id == totalTag[i].id) {
                selectedTagId.add(widget.data.keyword[j].id);
                selectedTagName.add(widget.data.keyword[j].tagName);
                setState(() => totalTagName.remove(totalTag[i].tagName));
                break;
              }
            }
          }
        }
      }
    });
  }

  void funCpc() async {
    await WebService.getCampainVerbose(context).then((value) {
      if (value.status == "success") {
        List<String> _temp = [];
        for (int i = 0; i < value.data.cpc.length; i++) {
          _temp.add("${value.data.cpc[i]}");
        }
        setState(() => _totalCpc = _temp);
      }
    });
  }

  void funSublim() {
    selectedTagId.clear();
    for (int i = 0; i < totalTag.length; i++) {
      if (selectedTagName.contains(totalTag[i].tagName))
        selectedTagId.add(totalTag[i].id);
      else
        selectedTagId.remove(totalTag[i].id);
    }
    List<String> va = statusData.keys.toList();
    Map _map = {
      "campaign_id": widget.campStat ? widget.data.id : "",
      "name": ctrl[0].text,
      "keyword": selectedTagId,
      "cpc": _selecteCpc,
      "total_budget": ctrl[1].text,
      "status": statusData[va[0]] == true
          ? va[0]
          : statusData[va[1]] == true
              ? va[1]
              : va[2]
    };
    if(widget.campStat){
      if(double.parse(widget.data.totalBudget.toString())>double.parse( widget.data.totalSpent.toString())){}else{
        BotToast.showText(text: "Please increase campaign budget");
        return;
      }
    }
    if (_formKey.currentState.validate()) {
      _autovalidate = false;
      print("_map:${_map.toString()}");
      WebService.createCampain(_map, widget.campStat, context).then((value) {
        if (value.status == "success") {
          BotToast.showText(text: value.message);
          Navigator.pop(context);
        }
      });
    } else
      _autovalidate = true;
  }
}
