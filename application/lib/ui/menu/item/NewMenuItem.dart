import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/menu/MenuVerbose.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../../utils/myString.dart';

class NewMenuItem extends StatefulWidget {
  @override
  _NewMenuItemState createState() => _NewMenuItemState();
}

class _NewMenuItemState extends State<NewMenuItem> {
  bool _autoValidateForm = false;
  List<String> _typeList;

  ProgressDialog pr;
  final _myTitleEditTextController = TextEditingController();
  final _myPriceEditTextController = TextEditingController();
  final _myDescriptionEditTextController = TextEditingController();
  final _myQuantityEditTextController = TextEditingController();
  final _myMaxQuantityEditTextController = TextEditingController();

  String _selectedCategory;
  String _selectedType;
  GlobalKey<FormState> key = GlobalKey();
  var fut;
  bool _isFoodItem = true;
  List imgFiles = [];
  FilePickerResult result;

  void initState() {
    super.initState();
    fut = WebService.funMenuVerbose();
    _typeList = ["Veg", "Non-veg"];
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);

    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Fetching Data, please wait');
    return Scaffold(
        backgroundColor: myBackGround,
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
              return ListView(
                children: [
                  Container(
                    height: sm.scaledHeight(14),
                    margin: EdgeInsets.symmetric(vertical: sm.scaledHeight(2)),
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
                              width: sm.scaledHeight(14),
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
                        for (int i = 0; i < imgFiles.length; i++)
                          Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.file(
                              imgFiles[i],
                              width: sm.scaledHeight(10),
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
                    child: Container(
                        decoration: bd1,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 40.0),
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: sm.scaledHeight(4)),
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
                                bottom: sm.scaledHeight(4),
                                left: sm.scaledWidth(2.6),
                                right: sm.scaledWidth(2.6)),
                            child: DropdownSearch<String>(
                              validator: (v) =>
                                  v == '' ? "required field" : null,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              mode: Mode.MENU,
                              selectedItem: _selectedCategory,
                              items: snapshot?.data?.data?.getCategoryName() ??
                                  <String>[],
                              label: "Category",
                              hint: "Please Select Category",
                              showSearchBox: false,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: sm.scaledHeight(4)),
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
                            padding:
                                EdgeInsets.only(bottom: sm.scaledHeight(4)),
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
                                EdgeInsets.only(bottom: sm.scaledHeight(4)),
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
                                bottom: sm.scaledHeight(4),
                                left: sm.scaledWidth(2.6),
                                right: sm.scaledWidth(2.6)),
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
                                EdgeInsets.only(bottom: sm.scaledHeight(4)),
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
                        ])),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sm.scaledWidth(16),
                          vertical: sm.scaledHeight(2)),
                      child: roundedButton(
                          clicker: () async {
                            List<MultipartFile> formData = [];
                            formData.clear();

                            for (int i = 0; i < result.files.length; i++) {
                              var v;
                              String fileName =
                                  result.files[i].path.split('/').last;
                              v = await MultipartFile.fromFile(
                                  result.files[i].path,
                                  filename: fileName);
                              formData.add(v);
                            }
                            if (key.currentState.validate()) {
                              pr?.show();
                              var _map = FormData.fromMap({
                                "title": _myTitleEditTextController.text,
                                "category_id": snapshot.data.data
                                    .getIdByName(_selectedCategory),
                                "price": _myPriceEditTextController.text,
                                "description":
                                    _myDescriptionEditTextController.text,
                                "quantity": _myQuantityEditTextController.text,
                                "type": _selectedType,
                                "max_qty_per_order":
                                    _myMaxQuantityEditTextController.text,
                                "photo": formData
                              });
                              print("_map:${_map.toString()}");
                              WebService.funMenuCreate(_map, context)
                                  .then((value) {
                                pr?.hide();
                                if (value.status == 'success') {
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
