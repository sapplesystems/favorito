import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/model/AttributeList.dart';
import 'package:Favorito/model/PhotoData.dart';
import 'package:Favorito/model/SubCategories.dart';
import 'package:Favorito/model/SubCategoryModel.dart';
import 'package:Favorito/model/TagList.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:provider/provider.dart';

class businessInfo extends StatefulWidget {
  @override
  _businessInfoState createState() => _businessInfoState();
}

class _businessInfoState extends State<businessInfo> {
  List<bool> checked = [];
  List<bool> radioChecked = [];
  var loadedImageList = [];
  final _keyCategory = GlobalKey<DropdownSearchState<String>>();
  List<TextEditingController> controller = [];
  List<String> totalpay = [];
  List<String> selectPay = [];
  List<int> priceRangelist = [];
  int priceRange;

//sub categories
  List<SubCategories> totalSubCategories = [];
  List<int> totalSubCategoriesId = [];
  List<String> totalSubCategoriesName = [];

  List<SubCategories> selectedSubCategories = [];
  List<int> selectedSubCategoriesId = [];
  List<String> selectedSubCategoriesName = [];

//tag
  List<TagList> totalTag = [];
  List<String> totalTagName = [];
  List<int> totalTagId = [];

  List<TagList> selectedTag = [];
  List<String> selectedTagName = [];
  List<int> selectedTagId = [];

  //attribute
  List<AttributeList> totalAttribute = [];
  List<String> totalAttributeName = [];
  List<int> totalAttributeListId = [];

  List<AttributeList> selectAttribute = [];
  List<int> selectAttributeId = [];
  List<String> selectAttributeName = [];
  bool needSave = false;
  String donetxt = 'Done';
  //selected attribute id
  SubCategoryModel subCategoryModel = SubCategoryModel();

  List<PhotoData> photoData = [];
  File _image;
  var catid;
  void initState() {
    getPageData();
    super.initState();
    for (int i = 0; i < 6; i++) controller.add(TextEditingController());
  }

  @override
  void dispose() {
    super.dispose();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: Color(0xfffff4f4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        padding: EdgeInsets.only(top: sm.h(2), bottom: sm.h(0)),
        child: ListView(
          children: [
            Text("Business Information", //businessInformation replace this
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            Container(
              height: sm.h(24),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < photoData.length; i++)
                    Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(photoData[i].photo.toString(),
                          fit: BoxFit.fill),
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
              function: () => getImage(ImgSource.Gallery),
            ),
            Container(
              decoration: bd1,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Column(children: [
                TextFormField(
                  controller: controller[0],
                  decoration: InputDecoration(
                      labelText: "Category",
                      labelStyle: Theme.of(context).textTheme.body2,
                      counterText: "",
                      enabled: false,
                      hintText: "Enter Category",
                      hintStyle: Theme.of(context).textTheme.subhead,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide())),
                ),

                //this is commented due to tester
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 8),
                //   child: DropdownSearch<String>(
                //     validator: (v) => v == '' ? "required field" : null,
                //     autoValidateMode: AutovalidateMode.onUserInteraction,
                //     mode: Mode.MENU,
                //     key: _keyCategory,
                //     showSelectedItem: true,
                //     selectedItem: controller[0].text,
                //     enabled: false,
                //     // items: catLst != null ? catLst.values.toList() : null,
                //     label: "Category",
                //     hint: "Please Select Category",
                //     onChanged: (value) {
                //       setState(() => controller[0].text = value);
                //     },
                //   ),
                // ),
                MyTags(
                    sourceList: totalSubCategoriesName,
                    selectedList: selectedSubCategoriesName,
                    hint: "Please select Sub category",
                    border: true,
                    directionVeticle: false,
                    refresh: () => setNeedSave(true),
                    title: " Sub Category"),
                MyTags(
                    sourceList: totalTagName,
                    selectedList: selectedTagName,
                    hint: "Please select Tags",
                    border: true,
                    directionVeticle: false,
                    refresh: () => setNeedSave(true),
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
                              setNeedSave(true);
                              print("priceRange ${i}");
                              priceRange = priceRangelist[i];
                              for (int j = 0; j < priceRangelist.length; j++) {
                                if (i == priceRange)
                                  radioChecked[i] = true;
                                else
                                  radioChecked[i] = false;
                              }
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
                Column(children: [
                  for (int i = 0; i < totalpay.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          selectPay.contains(totalpay[i])
                              ? selectPay.remove(totalpay[i])
                              : selectPay.add(totalpay[i]);
                          setNeedSave(true);
                        },
                        child: Row(children: [
                          Icon(
                            selectPay.contains(totalpay[i])
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: selectPay.contains(totalpay[i])
                                ? Colors.red
                                : Colors.grey,
                          ),
                          Text(totalpay[i],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: selectPay.contains(totalpay[i])
                                      ? Colors.red
                                      : Colors.grey))
                        ]),
                      ),
                    ),
                  MyTags(
                    sourceList: totalAttributeName,
                    selectedList: selectAttributeName,
                    hint: "Please select Attributes",
                    title: " Attributes",
                    border: false,
                    refresh: () {
                      setNeedSave(true);
                    },
                    directionVeticle: true,
                  ),
                ]),
              ]),
            ),
            Visibility(
              visible: getNeedSave(),
              child: Container(
                  margin: EdgeInsets.only(bottom: sm.w(30)),
                  padding: EdgeInsets.symmetric(
                      horizontal: sm.w(16), vertical: sm.h(2)),
                  child: RoundedButton(
                      clicker: () {
                        funSublim();
                      },
                      clr: Colors.red,
                      title: donetxt)),
            )
          ],
        ),
      ),
    );
  }

  void getPageData() async {
    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.getBusinessInfoData(context).then((value) async {
        if (value.message == "success") {
          await clearDataList();

          var _va = value.data;
          var _vaddV = value.ddVerbose;
          loadedImageList = _va.photos;
          _keyCategory?.currentState?.changeSelectedItem(_va?.categoryName);
          catid = _va.categoryId;
          controller[0].text = _va?.categoryName;
          selectedSubCategories = _va.subCategories;
          for (int i = 0; i < selectedSubCategories.length; i++)
            selectedSubCategoriesName
                .add(selectedSubCategories[i].categoryName);

          loadedImageList = _va.photos;
          priceRange = int.parse(_va.priceRange);
          priceRangelist.addAll(_vaddV.staticPriceRange);
          for (int i = 0; i < _vaddV.staticPriceRange.length; i++)
            radioChecked.add(false);

          totalpay.addAll(_vaddV.staticPaymentMethod);
          checked.clear();
          for (var v in totalpay) checked.add(false);

          selectPay.addAll(_va.paymentMethod);
          totalTag.addAll(_vaddV.tagList);
          for (int i = 0; i < totalTag.length; i++)
            totalTagName.add(totalTag[i].tagName);

          selectedTag.addAll(_va.tags);
          for (int i = 0; i < selectedTag.length; i++)
            selectedTagName.add(selectedTag[i].tagName);

          totalAttribute.addAll(_vaddV.attributeList);
          for (int i = 0; i < totalAttribute.length; i++)
            totalAttributeName.add(totalAttribute[i].attributeName);

          selectAttribute.addAll(_va.attributes);
          // for (var _v in selectAttribute) totalAttribute.remove(_v);
          for (int i = 0; i < selectAttribute.length; i++)
            selectAttributeName.add(selectAttribute[i].attributeName);
          photoData.addAll(_va.photos);
          setState(() {});
        }
      });

    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.getSubCat({"category_id": catid}, context).then((value) {
        if (value.message == "success") {
          subCategoryModel = value;
          totalSubCategoriesName.addAll(subCategoryModel.getAllSubCategory());
          for (var v in selectedSubCategories)
            totalSubCategoriesName.remove(v.categoryName);
        }
      });
  }

  void funSublim() async {
    selectedSubCategoriesId.addAll(
        subCategoryModel.getAllSubCategoryId(selectedSubCategoriesName));

    for (int i = 0; i < totalTag.length; i++)
      if (selectedTagName.contains(totalTag[i].tagName))
        selectedTagId.add(totalTag[i].id);

    for (int i = 0; i < totalAttribute.length; i++)
      if (selectAttributeName.contains(totalAttribute[i].attributeName))
        selectAttributeId.add(totalAttribute[i].id);

    if (priceRange != null && selectPay.isNotEmpty) {
      Map<String, dynamic> _map = {
        "sub_categories": selectedSubCategoriesId,
        "tags": selectedTagId,
        "price_range": priceRange,
        "payment_method": selectPay,
        "attributes": selectAttributeId
      };
      if (await Provider.of<UtilProvider>(context, listen: false)
          .checkInternet())
        await WebService.setBusinessInfoData(_map, context).then((value) {
          if (value.status == "success") {
            FocusScope.of(context).unfocus();
            BotToast.showText(text: value.message);
            Navigator.pop(context);
          }
        });
    }
  }

  Future getImage(ImgSource source) async {
    List img = [];
    var image = await ImagePickerGC.pickImage(
        context: context,
        imageQuality: 70,
        source: source,
        cameraIcon: Icon(Icons.add, color: Colors.red));
    img.add(image);

    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.profileInfoImageUpdate(img, context).then((value) async {
        if (value.status == "success") {
          BotToast.showText(text: value.message);
          photoData.clear();
          photoData.addAll(value.data);
        }
      });

    setState(() => _image = image);
  }

  clearDataList() {
    checked.clear();
    radioChecked.clear();
    totalpay.clear();
    selectPay.clear();

    totalSubCategories.clear();
    totalSubCategoriesName.clear();
    totalSubCategoriesName.clear();

    selectedSubCategories.clear();
    selectedSubCategoriesId.clear();
    selectedSubCategoriesName.clear();

    totalTag.clear();
    totalTagName.clear();
    totalTagId.clear();
    selectedTag.clear();
    selectedTagName.clear();
    selectedTagId.clear();

    totalAttribute.clear();
    totalAttributeName.clear();
    totalAttributeListId.clear();
    selectAttribute.clear();
    selectAttributeId.clear();
    selectAttributeName.clear();

    priceRangelist.clear();
    photoData.clear();
  }

  getNeedSave() => needSave;

  setNeedSave(bool _val) {
    setState(() {
      needSave = _val;
    });
  }
}
