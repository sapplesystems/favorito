import 'package:Favorito/model/catalog/CatlogListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class CatalogsProvider extends ChangeNotifier {
  BuildContext context;
  ProgressDialog pr;
  CatlogListModel catalogListdata;
  bool selected = false;
  String newCatalogTxt = 'New Catalog';
  String selectedId;
  bool autovalidate = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var submitBtnTxt = "Save";
  List<String> lst = [];
  List<TextEditingController> controller = [];
  List<String> selectedlist = [];
  List title = ["Title", "Price", "Description", "Url", "ID"];
  List<File> imgFiles = List();
  List<String> imgUrls = List();
  bool _needSubmit = false;
  List<String> imgUrlsId = List();
  CatalogsProvider() {
    for (int i = 0; i < 5; i++) controller.add(TextEditingController());
    // checkinternet();
  }

  String getHint(int i) => ((i == 3) || (i == 4))
      ? ' Enter Product ' + title[i].toString().toUpperCase()
      : ' Enter Catalog ' + title[i].toString().toLowerCase();

  setContext(BuildContext _context) {
    this.context = _context;
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true)
      ..style(
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
  }

  getCatelogList(bool _val, _context) async {
    await WebService.funGetCatalogs(_context).then((value) {
      catalogListdata = value;
      notifyListeners();
    });
  }

  funSublim() async {
    if (formKey.currentState.validate()) {
      if (selectedId == null || selectedId == '') {
        BotToast.showText(text: "Please attach catalog image first..");
        return;
      }
      print("selectedId$selectedId");
      Map _map = {
        "catalog_id": selectedId,
        "catalog_title": controller[0].text,
        "catalog_price": controller[1].text,
        "catalog_desc": controller[2].text,
        "product_url": controller[3].text,
        "product_id": controller[4].text
      };
      print("Image Sending id:${_map.toString()}");

      await WebService.catlogEdit(_map, context).then((value) {
        if (value.status == "success") {
          clearAll();
          BotToast.showText(
              text: value.message, duration: Duration(seconds: 5));

          Navigator.pop(context);
        } else
          BotToast.showText(
              text: value.message, duration: Duration(seconds: 5));
      });
    } else {
      autovalidate = true;
      notifyListeners();
    }
  }

  void attachImages() async {
    double size = 0;
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowCompression: true,
        allowedExtensions: ['jpg'],
        allowMultiple: false);
    if (result != null)
      imgFiles.addAll(result.paths.map((path) => File(path)).toList());

    if (result != null) {
      PlatformFile file = result.files.first;
      print("File name:${file.name}");
      print("size in byte:${file.bytes}");
      print("Size:${file.size}");
      print(file.extension);
      print(file?.path);

      for (int i = 0; i < result?.files?.length; i++)
        size = size + result.files[i].size;
      print("size in loop:${size}");

      try {
        if (double.parse(size.toString()) < 200048) {
          pr.show().timeout(Duration(seconds: 10));
          await WebService.funCatalogAddPhoto(result.files, selectedId ?? '')
              .then((value) {
            pr.hide();
            if (value.status == "success") {
              imgUrls.clear();
              imgUrlsId.clear();
              for (int i = 0; i < value.data.length; i++) {
                if (!imgUrlsId.contains(value.data[i].id)) {
                  imgUrls.add(value.data[i].photo);
                  imgUrlsId.add(value.data[i].id.toString());
                }
                selectedId = value.catalogId.toString();
              }
            }
            notifyListeners();
          });
        } else {
          pr.hide();
          BotToast.showText(
              text: 'size of attachment is greater then 2 mb',
              duration: Duration(seconds: 5));
          // text: FlutterConfig.get('image_max_length_message'));
        }
      } catch (e) {} finally {
        pr.hide();
      }
    }
  }

  deleteImage(int _i) async {
    // funCatalogDeletePhoto
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '\t\t\t\t\tAre you sure you want to delete ?',
                  style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Medium'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        child: Text("Ok",
                            style: TextStyle(
                                color: myRed,
                                fontSize: 16,
                                fontFamily: 'Gilroy-Medium')),
                        onPressed: () async {
                          await WebService.funCatalogDeletePhoto(
                              {'photo_id': imgUrlsId[_i]}).then((value) {
                            imgUrlsId.removeAt(_i);
                            imgUrls.removeAt(_i);
                            notifyListeners();

                            Navigator.pop(context);
                          });
                        }),
                    InkWell(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: myRed,
                            fontSize: 16,
                            fontFamily: 'Gilroy-Medium'),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  setSelectedCatalog(String _id) {
    selectedId = _id;
    WebService.funCatalogDetail({'catalog_id': selectedId}).then((value) {
      controller[0].text = value.data[0].catalogTitle;
      controller[1].text = value.data[0].catalogPrice.toString();
      controller[2].text = value.data[0].catalogDesc;
      controller[3].text = value.data[0].productUrl;
      controller[4].text = value.data[0].productId;
      try {
        var _v = value.data[0].photos.split(',');
        imgUrls.addAll(_v);
        var _vv = value.data[0].photosId.split(',');
        imgUrlsId.addAll(_vv);
      } catch (e) {
        imgUrls.add(value.data[0].photos);
      }
      needSubmit(false);
      notifyListeners();
    });
  }

  needSubmit(_val) {
    _needSubmit = _val;
    notifyListeners();
  }

  getNeedSubmit() => _needSubmit;

  clearAll() {
    selectedId = null;
    for (int i = 0; i < 5; i++) controller[i].text = '';
    imgUrls.clear();
    imgUrlsId.clear();
  }

  // void checkinternet() async {
  //   if (!await Provider.of<UtilProvider>(this.context, listen: false)
  //       .checkInternet()) {
  //     BotToast.showText(text: 'Please chaeck internet connection');
  //   }
  // }
}
