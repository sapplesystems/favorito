import 'dart:io';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/catalog/Catalog.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:transparent_image/transparent_image.dart';

class NewCatlog extends StatefulWidget {
  CatalogModel ct;
  NewCatlog(ct) {
    this.ct = ct;
  }
  @override
  _NewCatlogState createState() => _NewCatlogState();
}

class _NewCatlogState extends State<NewCatlog> {
  List<bool> checked = [false, false, false];
  List<bool> radioChecked = [true, false, false];

  bool _autovalidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var submitBtnTxt = "Submit";
  List<String> lst = [];
  List<TextEditingController> controller = [];
  List<String> selectedlist = [];
  List title = ["Title", "Price", "Discription", "Url", "Id"];

  List<File> imgFiles = List();
  List<String> imgUrls = List();
  List<String> imgUrlsId = List();
  void initState() {
    imgUrls = (widget.ct != null && widget.ct.photos != null)
        ? widget.ct.photos.split(",")
        : null;
    imgUrlsId = (widget.ct != null && widget.ct.photos != null)
        ? widget.ct.photosId.split(",")
        : null;
    super.initState();
    for (int i = 0; i < 5; i++) controller.add(TextEditingController());
    if (widget.ct != null) {
      controller[0].text = widget.ct.catalogTitle;
      controller[1].text = widget.ct.catalogPrice.toString();
      controller[2].text = widget.ct.catalogDesc;
      controller[3].text = widget.ct.productUrl;
      controller[4].text = widget.ct.productId;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myBackGround,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Catalog",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.error_outline, color: Colors.black),
          //   onPressed: () => Navigator.of(context).pop(),
          // )
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            Container(
              height: sm.scaledHeight(20),
              margin: EdgeInsets.symmetric(vertical: sm.scaledHeight(4)),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                      onTap: () async {
                        FilePickerResult result = await FilePicker.platform
                            .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg'],
                                allowMultiple: true);
                        if (result != null)
                          setState(() => imgFiles.addAll(
                              result.paths.map((path) => File(path)).toList()));

                        if (result != null) {
                          PlatformFile file = result.files.first;
                          print(file.name);
                          print(file.bytes);
                          print(file.size);
                          print(file.extension);
                          print(file.path);

                          WebService.catlogImageUpdate(result.files,
                                  widget.ct != null ? widget.ct.id : null)
                              .then((value) {
                            if (value.status == "success") {
                              imgUrls.clear();
                              imgUrlsId.clear();
                              for (int i = 0; i < value.data.length; i++) {
                                if (!imgUrlsId.contains(value.data[i].id)) {
                                  imgUrls.add(value.data[i].photo);
                                  imgUrlsId.add(value.data[i].id.toString());
                                }
                              }
                            }
                            setState(() {});
                          });
                        }
                      },
                      child: Container(
                        width: sm.scaledHeight(18),
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
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 5,
                            margin: EdgeInsets.all(10)),
                      )),
                  if (imgUrls != null)
                    for (int i = imgUrls.length - 1; i >= 0; i--) //Network
                      Container(
                        width: sm.scaledHeight(20),
                        child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: imgUrls[i]),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 5,
                            margin: EdgeInsets.all(10)),
                      )
                ],
              ),
            ),
            Builder(
                builder: (context) => Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(children: [
                      for (int i = 0; i < 5; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: sm.scaledHeight(1)),
                          child: txtfieldboundry(
                            valid: true,
                            title: title[i],
                            hint: "Enter ${title[i]}",
                            controller: controller[i],
                            maxLines: i == 2 ? 4 : 1,
                            security: false,
                          ),
                        ),
                    ]))),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sm.scaledWidth(16),
                    vertical: sm.scaledHeight(2)),
                child: roundedButton(
                    clicker: () {
                      if (_formKey.currentState.validate()) funSublim();
                    },
                    clr: Colors.red,
                    title: submitBtnTxt))
          ],
        ),
      ),
    );
  }

  funSublim() async {
    Map _map = {
      "catalog_id": widget.ct.id,
      "catalog_title": controller[0].text,
      "catalog_price": controller[1].text,
      "catalog_desc": controller[2].text,
      "product_url": controller[3].text,
      "product_id": controller[4].text
    };
    setState(() => submitBtnTxt = "Please Wait..");
    await WebService.catlogEdit(_map).then((value) {
      if (value.status == "success") {
        // for (var va in controller) va.text = "";
        BotToast.showText(text: value.message);
        BotToast.showLoading(duration: Duration(seconds: 1));
        // Navigator.pop(context);

        setState(() => submitBtnTxt = "Submit");
      } else
        BotToast.showText(text: value.message);
    });
  }
}
