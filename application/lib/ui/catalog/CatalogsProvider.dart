import 'package:Favorito/model/catalog/CatlogListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_config/flutter_config.dart';

class CatalogsProvider extends ChangeNotifier {
  BuildContext context;
  ProgressDialog pr;
  CatlogListModel catalogListdata;
  bool selected = false;
  String newCatalogTxt = 'New Catalog';
  String selectedId;
  bool autovalidate = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var submitBtnTxt = "Submit";
  List<String> lst = [];
  List<TextEditingController> controller = [];
  List<String> selectedlist = [];
  List title = ["Title", "Price", "Discription", "Url", "Id"];
  List<File> imgFiles = List();
  List<String> imgUrls = List();
  bool _needSubmit = false;
  List<String> imgUrlsId = List();
  CatalogsProvider() {
    for (int i = 0; i < 5; i++) controller.add(TextEditingController());

    getCatelogList(false);
  }
  setContext(BuildContext _context) {
    this.context = _context;
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true)
      ..style(message: 'please wait..');
  }

  getCatelogList(bool _val) async {
    _val ? pr?.show() : pr?.hide();
    await WebService.funGetCatalogs(context).then((value) {
      _val ? pr?.hide() : pr?.show();
      catalogListdata = value;
      notifyListeners();
    });
  }

  funSublim() async {
    if (formKey.currentState.validate()) {
      Map _map = {
        "catalog_id": selectedId,
        "catalog_title": controller[0].text,
        "catalog_price": controller[1].text,
        "catalog_desc": controller[2].text,
        "product_url": controller[3].text,
        "product_id": controller[4].text
      };
      print("Image Sending id:${_map.toString()}");
      submitBtnTxt = "Please Wait..";
      await WebService.catlogEdit(_map, context).then((value) {
        if (value.status == "success") {
          clearAll();
          BotToast.showText(text: value.message);

          submitBtnTxt = "Submit";
          Navigator.pop(context);
        } else
          BotToast.showText(text: value.message);
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
        allowedExtensions: ['jpg'],
        allowMultiple: false);
    if (result != null)
      imgFiles.addAll(result.paths.map((path) => File(path)).toList());

    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);

      if (!result.isSinglePick) {
        for (int i = 0; i < result.files.length; i++)
          size = size + result.files[i].size;
      }

      if (double.parse(size.toString()) <
          double.parse(FlutterConfig.get('image_max_length'))) {
        pr.show();
        WebService.catlogImageUpdate(result.files, selectedId ?? '')
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
        BotToast.showText(text: FlutterConfig.get('image_max_length_message'));
      }
    }
  }

  setSelectedCatalog(String _id) {
    selectedId = _id;
    WebService.funCatalogDetail({'catalog_id': selectedId}).then((value) {
      controller[0].text = value.data[0].catalogTitle;
      controller[1].text = value.data[0].catalogPrice.toString();
      controller[2].text = value.data[0].catalogDesc;
      controller[3].text = value.data[0].productUrl;
      controller[4].text = value.data[0].id.toString();
      try {
        var v = value.data[0].photos.split(',');
        imgUrls.addAll(v);
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
}
