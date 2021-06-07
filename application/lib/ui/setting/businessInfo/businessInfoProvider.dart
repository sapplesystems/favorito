import 'package:Favorito/model/AttributeList.dart';
import 'package:Favorito/model/PhotoData.dart';
import 'package:Favorito/model/SubCategories.dart';
import 'package:Favorito/model/SubCategoryModel.dart';
import 'package:Favorito/model/TagList.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';

class businessInfoProvider extends ChangeNotifier {
  List<bool> checked = [];
  List<bool> radioChecked = [];
  // var loadedImageList = [];
  final _keyCategory = GlobalKey<DropdownSearchState<String>>();
  List<TextEditingController> controller = [
    for (int i = 0; i < 6; i++) TextEditingController()
  ];
  List<String> totalpay = [];
  List<String> selectPay = [];
  List<String> priceRangelist = [];
  String priceRange;

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

  List<PhotoData> photos = [];
  File _image;
  var catid;

  void getPageData(context) async {
    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.getBusinessInfoData(context).then((value) async {
        if (value.message == "success") {
          await clearDataList();

          var _va = value.data;
          var _vaddV = value.ddVerbose;
          photos.addAll(_va.photos);
          _keyCategory?.currentState?.changeSelectedItem(_va?.categoryName);
          catid = _va.categoryId;
          controller[0].text = _va?.categoryName;
          selectedSubCategories = _va.subCategories;
          for (int i = 0; i < selectedSubCategories.length; i++)
            selectedSubCategoriesName
                .add(selectedSubCategories[i].categoryName);

          priceRange = _va.priceRange;
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

          notifyListeners();
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

  void funSublim(context) async {
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

  Future getImage(ImgSource source, context) async {
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
          photos.clear();
          photos.addAll(value.data);
        }
      });
    _image = image;
    notifyListeners();
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
    photos.clear();
  }

  getNeedSave() => needSave;

  setNeedSave(bool _val) {
    needSave = _val;
    notifyListeners();
  }

  deleteImage(int i, context) async {
    var _va = {'image_id': photos[i].id};
    await WebService.infoDeletePhoto(_va, context).then((value) {
      getPageData(context);
    });
  }
}
