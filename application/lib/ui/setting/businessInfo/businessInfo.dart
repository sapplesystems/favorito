import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldprefix.dart';
import 'package:Favorito/myCss.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';

class businessInfo extends StatefulWidget {
  @override
  _businessInfoState createState() => _businessInfoState();
}

class _businessInfoState extends State<businessInfo> {
  List<bool> checked = [false, false, false];
  List<bool> radioChecked = [true, false, false];
  bool _autoValidateForm = false;
  List<String> lst = ["a", "b", "c"];
  List<TextEditingController> controller = [];
  List<String> list = ["pizza", "burger", "cold drink", "French fries"];
  List<String> selectedlist = [];
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) controller.add(TextEditingController());
  }

  @override
  void dispose() {
    super.dispose();
    controller.clear();
    list.clear();
    selectedlist.clear();
    lst.clear();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: Color(0xfffff4f4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/icon/save.svg'),
            onPressed: () {},
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            Text("Business Information",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            Container(
              height: sm.scaledHeight(24),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 10; i++)
                    Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        'https://eatforum.org/content/uploads/2018/05/table_with_food_top_view_900x700.jpg',
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    )
                ],
              ),
            ),
            MyOutlineButton(
              title: "Add more photo",
              function: () {},
            ),
            Container(
                decoration: bd1,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DropdownSearch<String>(
                      validator: (v) => v == '' ? "required field" : null,
                      autoValidate: _autoValidateForm,
                      mode: Mode.MENU,
                      showSelectedItem: true,
                      selectedItem: controller[0].text,
                      items: lst != null ? lst : null,
                      label: "Category",
                      hint: "Please Select Category",
                      showSearchBox: true,
                      onChanged: (value) {
                        setState(() {
                          controller[0].text = value;
                        });
                      },
                    ),
                  ),
                  MyTags(
                    sourceList: list,
                    selectedList: [],
                    controller: controller[0],
                    hint: "Please select category",
                    title: " Sub Category",
                  ),
                  Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          "Select price range",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ))
                  ]),
                  SizedBox(
                    height: 52,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (int i = 0; i < 3; i++)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                for (int j = 0; j < 3; j++) {
                                  if (i == j)
                                    radioChecked[i] = true;
                                  else
                                    radioChecked[i] = false;
                                }
                                setState(() {});
                              },
                              child: Row(children: [
                                Icon(
                                  radioChecked[i]
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: radioChecked[i]
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                Text("${i + 1}00 \u{20B9}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: radioChecked[i]
                                            ? Colors.red
                                            : Colors.grey))
                              ]),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          "Select payment method",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ))
                  ]),
                  Column(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                checked[i] = !checked[i];
                              });
                            },
                            child: Row(children: [
                              Icon(
                                checked[i] == false
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: checked[i] == false
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              Text("Cash only",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: checked[i] == false
                                          ? Colors.red
                                          : Colors.grey))
                            ]),
                          ),
                        ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: txtfieldprefix(
                              title: "Attributes",
                              valid: true,
                              ctrl: controller[2],
                              prefixIco: Icons.search,
                              security: false)),
                      SizedBox(
                        height: 152,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            for (int i = 1; i < 5; i++)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${i}.Live Music",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ])),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sm.scaledWidth(16),
                    vertical: sm.scaledHeight(2)),
                child: roundedButton(
                    clicker: () {
                      // funSublim();
                    },
                    clr: Colors.red,
                    title: "Done"))
          ],
        ),
      ),
    );
  }
}
