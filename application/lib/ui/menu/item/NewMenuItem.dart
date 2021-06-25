import 'dart:io';
import 'package:Favorito/model/menu/MenuItem/ItemData.dart';
import 'package:Favorito/ui/menu/MenuProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/menu/MenuVerbose.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../../../utils/myString.dart';
import '../../../utils/Extentions.dart';

class NewMenuItem extends StatefulWidget {
  ItemData model;
  bool showVeg;
  NewMenuItem({this.model, @required this.showVeg});
  @override
  _NewMenuItemState createState() => _NewMenuItemState();
}

class _NewMenuItemState extends State<NewMenuItem> {
  List<String> _typeList;

  ProgressDialog pr;
  final _myTitleEditTextController = TextEditingController();
  final _myPriceEditTextController = TextEditingController();
  final _myDescriptionEditTextController = TextEditingController();
  final _myQuantityEditTextController = TextEditingController();
  final _myMaxQuantityEditTextController = TextEditingController();

  TextEditingController _selectedCategory = TextEditingController();
  String _selectedType;
  GlobalKey<FormState> key = GlobalKey();
  var fut;
  bool _isFoodItem = false;
  List imgFiles = [];
  List imgs = [];
  FilePickerResult result;
  bool haveData = false;

  void initState() {
    haveData = widget.model != null;
    assigner();
    super.initState();
    _isFoodItem = widget.showVeg;
    fut = WebService.funMenuVerbose();
    _typeList = ["Veg", "Non-veg"];
  }

  assigner() {
    if (haveData) {
      _myTitleEditTextController.text = widget.model.title.capitalize();
      _myPriceEditTextController.text = widget.model.price.capitalize();
      _myDescriptionEditTextController.text =
          widget.model.description.capitalize();
      _myQuantityEditTextController.text = widget.model.quantity.capitalize();
      _selectedType = widget.model.type;
      _myMaxQuantityEditTextController.text = widget.model.maxQtyPerOrder;
      if (widget.model.photo != null) imgs.addAll(widget.model.photo);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
        message: 'Please wait...',
        borderRadius: 8.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 8.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
      
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("New Item",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2)),
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
        body: FutureBuilder<MenuVerbose>(
          future: fut, //remove this type id and manage it in token
          builder: (BuildContext contect, AsyncSnapshot<MenuVerbose> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text(loading));
            else if (snapshot.hasError)
              return Center(child: Text("Somthing went wrong"));
            else {
              double spaceBetween = 3.4;
              if (haveData)
                _selectedCategory.text =
                    snapshot.data.data.getNameById(widget.model.menuCategoryId);
              return ListView(
                children: [
                  Container(
                    height: sm.h(14),
                    margin: EdgeInsets.symmetric(
                        vertical: sm.h(2), horizontal: sm.w(3.4)),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        InkWell(
                            onTap: () async {
                              result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg'],
                                  allowMultiple: true);
                              if (result != null)
                                setState(() => imgFiles.addAll(result.paths
                                    .map((path) => File(path))
                                    .toList()));

                              if (result != null) {
                                PlatformFile file = result.files.first;
                                print(file.name);
                                print(file.bytes);
                                print(file.size);
                                print(file.extension);
                                print(file.path);
                              }
                            },
                            child: Container(
                              width: sm.h(14),
                              child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: Icon(
                                        Icons.cloud_upload_outlined,
                                        size: 30,
                                      )),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  elevation: 5,
                                  margin: EdgeInsets.all(10)),
                            )),
                        for (var _v in imgFiles)
                          Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.file(
                              _v,
                              width: sm.h(10),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                          ),
                        for (int i = 0; i < imgs.length; i++)
                          Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.network(
                              imgs[i].url,
                              width: sm.h(10),
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
                  Form(
                    key: key,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: sm.w(5),
                          right: sm.w(5),
                          top: sm.w(2),
                          bottom: sm.w(5)),
                      child: Card(
                          child: Container(
                        padding: EdgeInsets.only(
                            top: sm.h(4), left: sm.w(4), right: sm.w(4)),
                        // margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: sm.h(spaceBetween)),
                            child: txtfieldboundry(
                              valid: true,
                              title: "Title",
                              hint: "Enter title",
                              controller: _myTitleEditTextController,
                              maxLines: 1,
                              security: false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: sm.h(spaceBetween),
                                left: sm.w(2.6),
                                right: sm.w(2.6)),
                            child: DropdownSearch<String>(
                              maxHeight: double.parse(((snapshot?.data?.data?.getCategoryName() ??
                                        <String>[]).length*56).toString())>167.0?168.0:100.0,
                                showSelectedItem: false,
                                validator: (v) =>
                                    v == '' ? "required field" : null,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                mode: Mode.MENU,
                                selectedItem: _selectedCategory.text,
                                items:
                                    snapshot?.data?.data?.getCategoryName() ??
                                        <String>[],
                                label: "Category",
                                hint: "Please Select Category",
                                showSearchBox: false,
                                onChanged: (value) {
                                  if (haveData)
                                    widget.model.menuCategoryId =
                                        "${snapshot.data.data.getIdByName(value)}";
                                  if (!haveData) _selectedCategory.text = value;
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: sm.h(2)),
                            child: txtfieldboundry(
                              valid: true,
                              title: "Price",
                              hint: "Enter preice",
                              controller: _myPriceEditTextController,
                              maxLines: 1,
                              keyboardSet: TextInputType.number,
                              security: false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: sm.h(2)),
                            child: txtfieldboundry(
                              valid: true,
                              title: "Description",
                              hint: "Enter description",
                              controller: _myDescriptionEditTextController,
                              maxLines: 4,
                              security: false,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: sm.h(spaceBetween)),
                            child: txtfieldboundry(
                              valid: true,
                              title: "Quantity",
                              hint: "Enter quantity",
                              controller: _myQuantityEditTextController,
                              keyboardSet: TextInputType.number,
                              maxLines: 1,
                              security: false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: sm.h(spaceBetween),
                                left: sm.w(2.6),
                                right: sm.w(2.6)),
                            child: Visibility(
                              visible: _isFoodItem,
                              child: DropdownSearch<String>(
                                maxHeight: 110,
                                validator: (v) =>
                                    v == '' ? "required field" : null,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                mode: Mode.MENU,
                                selectedItem: _selectedType,
                                items: _typeList,
                                label: "Type",
                                hint: "Please Select Type",
                                showSearchBox: false,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: sm.h(spaceBetween)),
                            child: txtfieldboundry(
                              valid: true,
                              title: "Max. quantity per order",
                              hint: "Enter maximum quantity",
                              controller: _myMaxQuantityEditTextController,
                              keyboardSet: TextInputType.number,
                              maxLines: 1,
                              security: false,
                            ),
                          ),
                        ]),
                      )),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sm.w(16), vertical: sm.h(2)),
                      child: RoundedButton(
                          clicker: () async {
                            List<MultipartFile> formData = [];

                            try {
                              if (result?.files?.isNotEmpty ?? false)
                                for (var _v in result?.files) {
                                  var v;
                                  String fileName = _v.path.split('/').last;
                                  v = await MultipartFile.fromFile(_v.path,
                                      filename: fileName);
                                  formData.add(v);
                                }
                            } catch (e) {
                              print("Error1:${e.toString()}");
                            }

                            if (key.currentState.validate()) {
                              pr?.show();
                              var _map = {
                                "menu_item_id": widget?.model?.id ?? "",
                                "title": _myTitleEditTextController.text,
                                "category_id": snapshot.data.data
                                    .getIdByName(_selectedCategory.text)
                                    .toString(),
                                "price": _myPriceEditTextController.text,
                                "description":
                                    _myDescriptionEditTextController.text,
                                "quantity": _myQuantityEditTextController.text,
                                "type": _selectedType ?? 0,
                                "max_qty_per_order":
                                    _myMaxQuantityEditTextController.text,
                                if (result?.files?.isNotEmpty ?? false)
                                  "photo": formData
                              };
                              var _data = FormData.fromMap(_map);
                              // print(
                              //     "abc${snapshot.data.data.getIdByName(_selectedCategory.text)}");

                              // print(
                              //     "_map:${snapshot.data.data.getIdByName(_selectedCategory.text)}");
                              // print("_map:${_map.toString()}");
                              await WebService.funMenuCreate(
                                      _data, context, haveData)
                                  .then((value) {
                                pr?.hide();
                                print("value.status:${value.status}");
                                if (value.status == 'success') {
                                  Provider.of<MenuProvider>(context,listen: false).getMenuList();
                                  Navigator.pop(context);
                                } else {
                                  BotToast.showText(text: value.message);
                                }
                              });
                            }
                          },
                          clr: Colors.red,
                          title: "Save"))
                ],
              );
            }
          },
        ));
  }
}
