import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/model/SubCategories.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
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
  List<bool> radioChecked = [];
  bool _autoValidateForm = false;
  var loadedImageList = [];
  Map<int, String> catLst = {};
  List<SubCategories> subCatLst = [];
  List<String> subCatLstName = [];
  List<TextEditingController> controller = [];
  List<String> selectedTags = [];
  List<SubCategories> selectedSubCats = [];
  List<String> selectedSubCatsNames = [];
  List<int> priceRangelist = [];
  List<String> payList = [];
  List<String> selectPayList = [];
  int priceRange;

//tag
  List<String> tagList = [];
  List<String> selectTagList = [];

  //attribute
  List<String> attributeList = [];
  List<String> selectAttributeList = [];

  var catid;
  void initState() {
    super.initState();
    gePageData();
    for (int i = 0; i < 6; i++) controller.add(TextEditingController());
  }

  @override
  void dispose() {
    super.dispose();
    controller.clear();
    selectedTags.clear();
    catLst.clear();
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
                      enabled: false,
                      items: catLst != null ? catLst.values.toList() : null,
                      label: "Category",
                      hint: "Please Select Category",
                      onChanged: (value) {
                        setState(() => controller[0].text = value);
                      },
                    ),
                  ),
                  MyTags(
                      sourceList: subCatLstName,
                      selectedList: selectedSubCatsNames,
                      hint: "Please select category",
                      border: true,
                      directionVeticle: false,
                      title: " Sub Category"),
                  MyTags(
                      sourceList: subCatLstName,
                      selectedList: selectedSubCatsNames,
                      hint: "Please select Tags",
                      border: true,
                      directionVeticle: false,
                      title: "Tags"),
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
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            priceRangelist != null ? priceRangelist.length : 0,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                print("priceRange ${i}");
                                priceRange = priceRangelist[i];
                                for (int j = 0;
                                    j < priceRangelist.length;
                                    j++) {
                                  if (i == priceRange)
                                    radioChecked[i] = true;
                                  else
                                    radioChecked[i] = false;
                                }
                                setState(() {});
                              },
                              child: Row(children: [
                                Icon(
                                  priceRangelist[i] == priceRange
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: priceRangelist[i] == priceRange
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                Text("${priceRangelist[i]} \u{20B9}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: priceRangelist[i] == priceRange
                                            ? Colors.red
                                            : Colors.grey))
                              ]),
                            ),
                          );
                        }),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          "Select payment method",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        )),
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < payList.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectPayList.contains(payList[i])
                                    ? selectPayList.remove(payList[i])
                                    : selectPayList.add(payList[i]);
                              });
                              print("selectPayList$selectPayList");
                            },
                            child: Row(children: [
                              Icon(
                                selectPayList.contains(payList[i])
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: selectPayList.contains(payList[i])
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              Text(payList[i],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: selectPayList.contains(payList[i])
                                          ? Colors.red
                                          : Colors.grey))
                            ]),
                          ),
                        ),
                      // Padding(
                      //     padding: EdgeInsets.symmetric(vertical: 6),
                      //     child: txtfieldprefix(
                      //         title: "Attributes",
                      //         valid: true,
                      //         ctrl: controller[2],
                      //         prefixIco: Icons.search,
                      //         security: false)),
                      MyTags(
                        sourceList: subCatLstName,
                        selectedList: selectedSubCatsNames,
                        hint: "Please select Attributes",
                        title: " Attributes",
                        border: false,
                        directionVeticle: true,
                      ),
                      // SizedBox(
                      //   height: 152,
                      //   child: ListView(
                      //     scrollDirection: Axis.vertical,
                      //     children: [
                      //       for (int i = 1; i < 5; i++)
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text("${i}.Live Music",
                      //               style: TextStyle(
                      //                   fontSize: 16, color: Colors.black)),
                      //         ),
                      //     ],
                      //   ),
                      // ),
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

  void gePageData() async {
    await WebService.getBusinessInfoData().then((value) {
      if (value.message == "success") {
        var _va = value.data;
        var _vaddV = value.ddVerbose;
        loadedImageList = _va.photos;
        controller[0].text = _va.categoryName;
        catid = _va.categoryId;
        selectedSubCats = _va.subCategories;
        loadedImageList = _va.photos;
        priceRange = int.parse(_va.priceRange);
        priceRangelist.addAll(_vaddV.staticPriceRange);
        for (int i = 0; i < _vaddV.staticPriceRange.length; i++)
          radioChecked.add(false);
        for (int i = 0; i < selectedSubCats.length; i++)
          selectedSubCatsNames.add(selectedSubCats[i].categoryName);
        payList.addAll(_va.paymentMethod);
        setState(() {});
      }

      print("aaaaaaa${value.toString()}");
    });

    await WebService.getSubCat({"category_id": catid}).then((value) {
      if (value.message == "success") {
        var _va = value.data;
        subCatLst = _va;
        for (int i = 0; i < subCatLst.length; i++)
          if (!selectedSubCatsNames.contains(subCatLst[i].categoryName))
            subCatLstName.add(subCatLst[i].categoryName);

        setState(() {});
      }
    });
  }
}
